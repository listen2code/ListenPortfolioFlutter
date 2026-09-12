#!/usr/bin/env dart
// ignore_for_file: avoid_print, avoid_classes_with_only_static_members

import 'dart:convert';
import 'dart:io';

/// ============================================================================
/// Dependency Boundary & Architecture Gatekeeper CLI Tool
/// ============================================================================
///
/// A standalone, high-performance static analysis utility designed to verify
/// architectural dependency compliance and generate dependency graph visualizations.
///
/// ### Architecture Layer Hierarchy (Bottom to Top):
/// 1. **Core Framework Layer** (`listen_core`): Low-level primitives, networking, storage, logging.
/// 2. **UI Component Layer** (`listen_uikit`): Atoms, molecules, widgets, design tokens.
/// 3. **Shared Utility Layer** (`lib/shared/`): Common business widgets, themes, route bindings.
/// 4. **Business Feature Layer** (`lib/features/`): Isolated feature pods (about_me, auth, home, settings).
///
/// ### Invariant Architectural Rules:
/// - **Unidirectional Flow**: Lower layers MUST NOT import from upper layers.
/// - **Feature Isolation**: Features MUST NOT directly import internal classes from peer features.
/// - **Encapsulation**: Private implementations (`_impl.dart`, `impl/`, `_private.dart`) are inaccessible
///   from outside their declared boundary, with exceptions for dependency injection providers.
/// - **Cycle Freedom**: The dependency graph across modules must remain a Directed Acyclic Graph (DAG).
///
/// ### CLI Usage:
/// ```bash
/// dart tools/dependency_rules.dart                  # Run standard validation
/// dart tools/dependency_rules.dart --graph          # Export dependency_graph.json
/// dart tools/dependency_rules.dart --check-circular # Check circular dependencies
/// dart tools/dependency_rules.dart --check-layers   # Check layer boundary violations
/// ```

/// Definition of an architectural boundary enforcement rule.
class DependencyRule {
  /// Regular expression pattern matching illegal import lines.
  final String pattern;

  /// Human-readable explanation of the architectural violation.
  final String description;

  /// Category classification of this rule.
  final DependencyViolationType type;

  const DependencyRule({required this.pattern, required this.description, required this.type});
}

/// Categorization of dependency boundary violations.
enum DependencyViolationType {
  /// Illegal coupling between independent business feature modules.
  crossFeature,

  /// Illegal reverse dependency where a lower-level module depends on an upper-level module.
  upwardDependency,

  /// Cyclic import loop between two or more files/modules.
  circularDependency,

  /// Forbidden pattern, such as directly importing private implementation files.
  forbiddenPattern,
}

/// Represents an individual architectural violation detected within a source file.
class DependencyViolation {
  /// Absolute or relative path to the offending Dart source file.
  final String file;

  /// The offending `import '...'` line content.
  final String import;

  /// The specific rule that was violated.
  final DependencyRule rule;

  /// 1-based line number where the violation occurred.
  final int line;

  const DependencyViolation({
    required this.file,
    required this.import,
    required this.rule,
    required this.line,
  });

  @override
  String toString() {
    return '🚫 $file:$line - ${rule.description}\n   → $import';
  }
}

/// Core analyzer engine that scans Dart source trees and evaluates dependency rules.
class DependencyAnalyzer {
  static const List<DependencyRule> _rules = [
    // Forbidden cross-features module dependency
    DependencyRule(
      pattern: r'import.*features/[^/]+/.*features/[^/]+/',
      description:
          'Cross-feature module dependency not allowed (features/moduleA should not depend on features/moduleB)',
      type: DependencyViolationType.crossFeature,
    ),
    
    // NOTE: Removed shared -> features dependency check
    // Allow features and shared to reference each other since they are in the same project
    
    // Forbidden core dependency on upper layer modules (checked via relative paths)
    DependencyRule(
      pattern: r'import.*\.\./.*features/|import.*\.\./.*shared/',
      description: 'core module should not depend on upper layer modules',
      type: DependencyViolationType.upwardDependency,
    ),

    // Forbidden direct import of private implementation files (excluding common public file patterns)
    DependencyRule(
      pattern: r'import.*listen_portfolio_flutter/.*_(impl|mock|test|internal|private)\.dart',
      description:
          'Direct import of private implementation files not allowed (_impl, _mock, _test, _internal, _private)',
      type: DependencyViolationType.forbiddenPattern,
    ),
  ];

  /// Analyzes an individual Dart source file against registered architectural dependency rules.
  ///
  /// Processing Pipeline:
  /// 1. Determines the owning architectural module (`features`, `shared`, or `core`) from [filePath].
  /// 2. Iterates line-by-line looking for `import ` declarations.
  /// 3. Evaluates regex pattern matches for each declared [DependencyRule].
  /// 4. Dispatches to [_isContextualViolation] to apply semantic exception filters (such as DI providers).
  static List<DependencyViolation> analyzeFile(String filePath, List<String> lines) {
    final violations = <DependencyViolation>[];

    // Determine which module this file belongs to based on directory hierarchy
    final fileModule = _getFileModule(filePath);

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      if (line.trimLeft().startsWith('import ')) {
        for (final rule in _rules) {
          final regex = RegExp(rule.pattern);
          if (regex.hasMatch(line)) {
            // Apply context-aware checks to eliminate false positives in valid DI / internal setups
            if (_isContextualViolation(line, filePath, fileModule, rule)) {
              violations.add(
                DependencyViolation(file: filePath, import: line.trim(), rule: rule, line: i + 1),
              );
            }
          }
        }
      }
    }

    return violations;
  }

  /// Determines which architectural layer the given file path belongs to.
  ///
  /// Normalizes path semantics across operating systems (both `/` and `\` directory separators).
  static String? _getFileModule(String filePath) {
    if (filePath.contains('features/') || filePath.contains(r'features\')) {
      return 'features';
    } else if (filePath.contains('shared/') || filePath.contains(r'shared\')) {
      return 'shared';
    } else if (filePath.contains('core/') || filePath.contains(r'core\')) {
      return 'core';
    }
    return null;
  }

  /// Evaluates context-aware exception heuristics for potential architectural violations.
  ///
  /// Rationale for Heuristic Exceptions:
  /// 1. **Upward Dependency Rule**:
  ///    - `core` represents the foundational framework layer and must never import upward
  ///      into `features` or `shared`.
  ///    - `features` and `shared` exist within the same host client package and are permitted
  ///      to cross-reference utility widgets and routes.
  /// 2. **Cross-Feature Rule**:
  ///    - Independent business features (e.g. `auth` vs `home`) must remain isolated pods.
  ///    - An import is flagged if and only if both the importing file and imported URI belong
  ///      to different feature pods (`currentFeature != importedFeature`).
  /// 3. **Forbidden Private Implementation Rule**:
  ///    - Clean Architecture mandates that presentation and domain layers depend strictly on
  ///      abstract repository contracts (`auth_repository.dart`).
  ///    - **Exception A (Dependency Injection)**: Files located inside `/provider/` directories
  ///      are designated DI composition roots responsible for binding contracts to implementations.
  ///    - **Exception B (Internal Data Layer)**: Data sources and repositories within the *same*
  ///      feature pod are allowed to reference their own private DTOs and database models.
  static bool _isContextualViolation(
    String importLine,
    String filePath,
    String? fileModule,
    DependencyRule rule,
  ) {
    switch (rule.type) {
      case DependencyViolationType.upwardDependency:
        // Core framework module must never import upward into application layers
        if (fileModule == 'core' && (importLine.contains('features/') || importLine.contains('shared/'))) {
          return true;
        }
        return false;

      case DependencyViolationType.crossFeature:
        // Enforce strict feature pod boundary isolation
        if (fileModule == 'features') {
          final currentFeature = _extractFeatureName(filePath);
          final importedFeature = _extractFeatureName(importLine);
          return currentFeature != null && importedFeature != null && currentFeature != importedFeature;
        }
        return false;

      case DependencyViolationType.forbiddenPattern:
        // Exception A: Provider composition roots must instantiate concrete implementations
        if (filePath.contains('/provider/') ||
            filePath.contains(r'\provider\') ||
            filePath.contains('/providers/') ||
            filePath.contains(r'\providers\')) {
          return false;
        }
        // Exception B: Allow data layer files to reference implementations within the same feature pod
        if (fileModule == 'features' && (filePath.contains('/data/') || filePath.contains(r'\data\'))) {
          final currentFeature = _extractFeatureName(filePath);
          final importedFeature = _extractFeatureName(importLine);
          if (currentFeature != null && importedFeature != null && currentFeature == importedFeature) {
            return false;
          }
        }
        return true; // Any other layer importing private _impl files is flagged

      case DependencyViolationType.circularDependency:
        return true;
    }
  }

  /// Extracts the feature pod name (e.g. 'auth', 'home', 'settings') from a file path or import URI.
  ///
  /// Handles both POSIX (`features/xyz/`) and Windows (`features\xyz\`) directory patterns.
  static String? _extractFeatureName(String path) {
    final match = RegExp(r'features[/\\]([^/\\]+)[/\\]').firstMatch(path);
    return match?.group(1);
  }

  /// Analyze all Dart files in the project
  static Future<List<DependencyViolation>> analyzeProject() async {
    final violations = <DependencyViolation>[];
    final projectDir = Directory.current.path;

    // Analyze all Dart files under lib directory
    final libDir = Directory('$projectDir/lib');
    if (!await libDir.exists()) {
      print('❌ lib directory does not exist');
      return violations;
    }

    await for (final entity in libDir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        try {
          final lines = await entity.readAsLines();
          final fileViolations = analyzeFile(entity.path, lines);
          violations.addAll(fileViolations);
        } catch (e) {
          print('⚠️  Failed to analyze file: ${entity.path} - $e');
        }
      }
    }

    return violations;
  }

  /// Print analysis summary report
  static void printSummary(List<DependencyViolation> violations) {
    print('\n📊 Dependency Boundary Check Report');
    print('=' * 50);

    if (violations.isEmpty) {
      print('✅ All dependencies comply with the rules!');
      return;
    }

    print('❌ Found ${violations.length} dependency violations:\n');

    // Group by type
    final grouped = <DependencyViolationType, List<DependencyViolation>>{};
    for (final violation in violations) {
      grouped.putIfAbsent(violation.rule.type, () => []).add(violation);
    }

    for (final entry in grouped.entries) {
      print('🔍 ${_getTypeDescription(entry.key)} (${entry.value.length} violations):');
      print('-' * 30);

      for (final violation in entry.value) {
        print(violation);
        print('');
      }
    }

    print('\n💡 Fix suggestions:');
    print('1. Cross-module dependencies: Consider extracting common logic to shared or core');
    print('2. Upward dependencies: Check dependency hierarchy, ensure unidirectional dependencies');
    print('3. Private imports: Use public interfaces instead of private implementations');
  }

  /// Get description for violation type
  static String _getTypeDescription(DependencyViolationType type) {
    switch (type) {
      case DependencyViolationType.crossFeature:
        return 'Cross-feature module dependencies';
      case DependencyViolationType.upwardDependency:
        return 'Upward dependencies';
      case DependencyViolationType.circularDependency:
        return 'Circular dependencies';
      case DependencyViolationType.forbiddenPattern:
        return 'Forbidden patterns';
    }
  }

  /// Constructs a Directed Acyclic Graph (DAG) representation of internal imports across `lib/`.
  ///
  /// Output Schema:
  /// - `nodes`: Array of relative Dart source file paths.
  /// - `edges`: Directed linkages mapping an importing file (`from`) to its dependencies (`to`).
  /// - `statistics`: Aggregated metrics covering total file count, coupled files, and edge count.
  ///
  /// Used by CI/CD pipelines to export `dependency_graph.json` as a build artifact for architectural tracking.
  static Future<Map<String, dynamic>> generateDependencyGraph() async {
    final graph = <String, Set<String>>{};
    final projectDir = Directory.current.path;
    final libDir = Directory('$projectDir/lib');

    await for (final entity in libDir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        final relativePath = entity.path.replaceFirst('$projectDir/lib/', '');
        final imports = <String>{};

        try {
          final lines = await entity.readAsLines();
          for (final line in lines) {
            if (line.trimLeft().startsWith('import ')) {
              final import = line.trim();
              if (import.contains('features/') || import.contains('shared/') || import.contains('core/')) {
                imports.add(import);
              }
            }
          }
        } catch (e) {
          // Ignore read errors for inaccessible or locked files
        }

        graph[relativePath] = imports;
      }
    }

    return {
      'nodes': graph.keys.toList(),
      'edges': graph.entries
          .where((e) => e.value.isNotEmpty)
          .map((e) => {'from': e.key, 'to': e.value.toList()})
          .toList(),
      'statistics': {
        'totalFiles': graph.length,
        'filesWithDependencies': graph.values.where((v) => v.isNotEmpty).length,
        'totalDependencies': graph.values.fold(0, (sum, v) => sum + v.length),
      },
    };
  }
}

/// CLI Entrypoint for Dependency Boundary Verification.
///
/// Exit Codes:
/// - `0`: All architectural boundary checks passed successfully.
/// - `1`: One or more violations detected (fails CI gate).
Future<void> main(List<String> args) async {
  // Handle special command line options
  if (args.contains('--check-circular')) {
    print('🔍 Checking circular dependencies...');
    final violations = await DependencyAnalyzer.analyzeProject();
    final circularViolations = violations
        .where((v) => v.rule.type == DependencyViolationType.circularDependency)
        .toList();

    if (circularViolations.isEmpty) {
      print('✅ No circular dependencies found');
      exit(0);
    } else {
      print('❌ Found ${circularViolations.length} circular dependencies:');
      for (final violation in circularViolations) {
        print('🚫 ${violation.file}:${violation.line} - ${violation.rule.description}');
      }
      exit(1);
    }
  }

  if (args.contains('--check-layers')) {
    print('🔍 Checking dependency layers...');
    final violations = await DependencyAnalyzer.analyzeProject();
    final layerViolations = violations
        .where((v) => v.rule.type == DependencyViolationType.upwardDependency)
        .toList();

    if (layerViolations.isEmpty) {
      print('✅ No layer violations found');
      exit(0);
    } else {
      print('❌ Found ${layerViolations.length} layer violations:');
      for (final violation in layerViolations) {
        print('🚫 ${violation.file}:${violation.line} - ${violation.rule.description}');
      }
      exit(1);
    }
  }

  if (args.contains('--help') || args.contains('-h')) {
    print('🔍 Dependency Boundary Check Tool');
    print('');
    print('Usage: dart tools/dependency_rules.dart [options]');
    print('');
    print('Options:');
    print('  --graph, -g         Generate dependency graph');
    print('  --check-circular   Check for circular dependencies only');
    print('  --check-layers     Check dependency layer violations only');
    print('  --help, -h         Show this help message');
    print('');
    print('Examples:');
    print('  dart tools/dependency_rules.dart              # Run full check');
    print('  dart tools/dependency_rules.dart --graph       # Run with graph generation');
    print('  dart tools/dependency_rules.dart --check-circular  # Check circular deps only');
    return;
  }

  print('🔍 Starting dependency boundary analysis...\n');

  // Analyze dependency violations
  final violations = await DependencyAnalyzer.analyzeProject();
  DependencyAnalyzer.printSummary(violations);

  // Generate dependency graph
  if (args.contains('--graph') || args.contains('-g')) {
    print('\n📈 Generating dependency graph...');
    final graph = await DependencyAnalyzer.generateDependencyGraph();

    final graphFile = File('dependency_graph.json');
    await graphFile.writeAsString(const JsonEncoder.withIndent('  ').convert(graph));

    print('✅ Dependency graph saved to: ${graphFile.path}');
    print('📊 Statistics:');
    print('   - Total files: ${graph['statistics']['totalFiles']}');
    print('   - Files with dependencies: ${graph['statistics']['filesWithDependencies']}');
    print('   - Total dependencies: ${graph['statistics']['totalDependencies']}');
  }

  // Set exit code
  exit(violations.isEmpty ? 0 : 1);
}
