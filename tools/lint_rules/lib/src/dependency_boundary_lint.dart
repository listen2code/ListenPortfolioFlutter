// ignore_for_file: avoid_print
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint/custom_lint.dart';

/// Dependency boundary check Lint rule
class DependencyBoundaryLint extends PluginLint {
  const DependencyBoundaryLint() : super(
    code: const LintCode(
      name: 'dependency_boundary',
      problemMessage: 'Dependency boundary rule violation',
      correctionMessage: 'Please check dependency hierarchy and refactor code',
    ),
  );

  @override
  LintSeverity get severity => LintSeverity.warning;

  @override
  bool canRunInPackage(String package) => true;

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addImportDirective((node) {
      final uri = node.uri.stringValue;
      if (uri == null) return;

      // Get current file path
      final filePath = resolver.source.fullName;
      
      // Check various violation scenarios
      _checkCrossFeatureDependency(uri, filePath, node, reporter);
      _checkUpwardDependency(uri, filePath, node, reporter);
      _checkPrivateImplementation(uri, node, reporter);
      _checkCoreUpwardDependency(uri, filePath, node, reporter);
    });
  }

  /// Check cross-feature module dependencies
  void _checkCrossFeatureDependency(
    String uri,
    String filePath,
    ImportDirective node,
    ErrorReporter reporter,
  ) {
    // If current file is under features, check if importing other features
    if (filePath.contains('features/')) {
      final currentFeature = _extractFeatureName(filePath);
      final importedFeature = _extractFeatureName(uri);
      
      if (currentFeature != null && 
          importedFeature != null && 
          currentFeature != importedFeature) {
        reporter.reportErrorForOffset(
          code,
          node.offset,
          node.length,
          arguments: [
            'Cross-feature module dependency not allowed: $currentFeature should not depend on $importedFeature',
          ],
        );
      }
    }
  }

  /// Check upward dependencies
  void _checkUpwardDependency(
    String uri,
    String filePath,
    ImportDirective node,
    ErrorReporter reporter,
  ) {
    // shared should not depend on features
    if (filePath.contains('shared/') && uri.contains('features/')) {
      reporter.reportErrorForOffset(
        code,
        node.offset,
        node.length,
        arguments: ['shared module should not depend on features module'],
      );
    }
    
    // core should not depend on upper layer modules
    if (filePath.contains('core/') && 
        (uri.contains('features/') || uri.contains('shared/'))) {
      reporter.reportErrorForOffset(
        code,
        node.offset,
        node.length,
        arguments: ['core module should not depend on upper layer modules'],
      );
    }
  }

  /// Check private implementation imports
  void _checkPrivateImplementation(
    String uri,
    ImportDirective node,
    ErrorReporter reporter,
  ) {
    // Check if importing private files (underscore prefix)
    if (uri.contains('_') && uri.endsWith('.dart')) {
      final fileName = uri.split('/').last;
      if (fileName.startsWith('_')) {
        reporter.reportErrorForOffset(
          code,
          node.offset,
          node.length,
          arguments: ['Direct import of private implementation file not allowed: $fileName'],
        );
      }
    }
  }

  /// Check core upward dependencies (through relative paths)
  void _checkCoreUpwardDependency(
    String uri,
    String filePath,
    ImportDirective node,
    ErrorReporter reporter,
  ) {
    if (filePath.contains('core/')) {
      // Check if relative path goes upward
      if (uri.startsWith('../') && 
          (uri.contains('features/') || uri.contains('shared/'))) {
        reporter.reportErrorForOffset(
          code,
          node.offset,
          node.length,
          arguments: ['core module should not depend on upper layer modules through relative paths'],
        );
      }
    }
  }

  /// Extract feature name from path
  String? _extractFeatureName(String path) {
    final match = RegExp(r'features/([^/]+)/').firstMatch(path);
    return match?.group(1);
  }
}

/// Circular dependency check Lint rule
class CircularDependencyLint extends PluginLint {
  const CircularDependencyLint() : super(
    code: const LintCode(
      name: 'circular_dependency',
      problemMessage: 'Potential circular dependency detected',
      correctionMessage: 'Please refactor code to eliminate circular dependencies',
    ),
  );

  @override
  LintSeverity get severity => LintSeverity.error;

  @override
  bool canRunInPackage(String package) => true;

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    // Here we can implement more complex circular dependency detection
    // Since it requires global analysis, currently serves as a placeholder
  }
}

/// Prevent direct import of implementation classes
class ImplementationImportLint extends PluginLint {
  const ImplementationImportLint() : super(
    code: const LintCode(
      name: 'implementation_import',
      problemMessage: 'Should not directly import implementation classes',
      correctionMessage: 'Please import abstract interfaces or public classes',
    ),
  );

  @override
  LintSeverity get severity => LintSeverity.warning;

  @override
  bool canRunInPackage(String package) => true;

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addImportDirective((node) {
      final uri = node.uri.stringValue;
      if (uri == null) return;

      // Check if importing implementation classes (usually in data/impl or implementation directories)
      if (uri.contains('implementation/') || 
          uri.contains('impl/') ||
          uri.contains('_impl.dart')) {
        reporter.reportErrorForOffset(
          code,
          node.offset,
          node.length,
          arguments: ['Avoid direct import of implementation classes, should depend on abstract interfaces'],
        );
      }
    });
  }
}

/// Plugin entry point
class DependencyLintPlugin extends Plugin {
  @override
  List<LintRule> getLintRules() => [
    const DependencyBoundaryLint(),
    const CircularDependencyLint(),
    const ImplementationImportLint(),
  ];
}

/// Main function - for testing
void main() {
  print('Dependency Lint Rules Plugin');
  print('Usage: Add custom_lint dependency in pubspec.yaml');
  print('Then enable rules in analysis_options.yaml');
}
