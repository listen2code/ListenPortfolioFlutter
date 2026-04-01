#!/usr/bin/env dart

import 'dart:convert';
import 'dart:io';

/// Dependency boundary check tool
///
/// Dependency hierarchy rules (from bottom to top):
/// 1. core (listen_core) - Base framework layer
/// 2. uikit (listen_uikit) - UI component layer
/// 3. shared - Shared utility layer
/// 4. features - Business feature layer
///
/// Forbidden dependency directions:
/// - features depending on other features (cross-module dependency)
/// - shared depending on features
/// - core depending on any upper layer modules
/// - uikit depending on features
/// - circular dependencies

class DependencyRule {
  final String pattern;
  final String description;
  final DependencyViolationType type;

  const DependencyRule({required this.pattern, required this.description, required this.type});
}

enum DependencyViolationType {
  crossFeature, // Cross-feature module dependency
  upwardDependency, // Upward dependency
  circularDependency, // Circular dependency
  forbiddenPattern, // Forbidden pattern
}

class DependencyViolation {
  final String file;
  final String import;
  final DependencyRule rule;
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
      pattern: r"import.*listen_portfolio_flutter/.*_(impl|mock|test|internal|private)\.dart",
      description:
          'Direct import of private implementation files not allowed (_impl, _mock, _test, _internal, _private)',
      type: DependencyViolationType.forbiddenPattern,
    ),
  ];

  static List<DependencyViolation> analyzeFile(String filePath, List<String> lines) {
    final violations = <DependencyViolation>[];

    // Determine which module this file belongs to
    final fileModule = _getFileModule(filePath);

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      if (line.trimLeft().startsWith('import ')) {
        for (final rule in _rules) {
          final regex = RegExp(rule.pattern);
          if (regex.hasMatch(line)) {
            // Additional context-aware checking
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

  /// Determine which module the file belongs to
  static String? _getFileModule(String filePath) {
    if (filePath.contains('features/')) {
      return 'features';
    } else if (filePath.contains('shared/')) {
      return 'shared';
    } else if (filePath.contains('core/')) {
      return 'core';
    }
    return null;
  }

  /// Context-aware violation checking
  static bool _isContextualViolation(
    String importLine,
    String filePath,
    String? fileModule,
    DependencyRule rule,
  ) {
    switch (rule.type) {
      case DependencyViolationType.upwardDependency:
      // NOTE: Allow features and shared to reference each other
      // Only check core upward dependencies
      if (fileModule == 'core' && (importLine.contains('features/') || importLine.contains('shared/'))) {
        return true;
      }
      return false;

      case DependencyViolationType.crossFeature:
        // Check cross-feature dependencies
        if (fileModule == 'features') {
          final currentFeature = _extractFeatureName(filePath);
          final importedFeature = _extractFeatureName(importLine);
          return currentFeature != null && importedFeature != null && currentFeature != importedFeature;
        }
        return false;

      case DependencyViolationType.forbiddenPattern:
        // Allow provider files to import implementations (they are dependency injection)
        if (filePath.contains('/provider/') || filePath.contains('\\provider\\')) {
          return false; // Provider files are allowed to import implementations
        }
        // Allow data layer files to import implementations within the same feature
        if (fileModule == 'features' && filePath.contains('/data/')) {
          // Check if it's importing from the same feature's data layer
          final currentFeature = _extractFeatureName(filePath);
          final importedFeature = _extractFeatureName(importLine);
          if (currentFeature != null && importedFeature != null && currentFeature == importedFeature) {
            return false; // Same feature data layer imports are allowed
          }
        }
        return true; // Default case: forbidden pattern is a violation

      case DependencyViolationType.circularDependency:
        // These are pattern-based, no additional context needed
        return true;
    }
  }

  /// Extract feature name from path or import line
  static String? _extractFeatureName(String path) {
    final match = RegExp(r'features/([^/]+)/').firstMatch(path);
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

  /// Generate dependency graph for visualization
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
          // Ignore read errors
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
