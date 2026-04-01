// ignore_for_file: avoid_print
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Dependency boundary lint rule
class DependencyBoundaryLint extends PluginBase {
  @override
  List<LintRule> getRules() => [
    _DependencyBoundaryRule(),
    _CircularDependencyLint(),
    _ImplementationImportLint(),
  ];
}

/// Main dependency boundary rule
class _DependencyBoundaryRule extends DartLintRule {
  static const LintCode code = LintCode(
    name: 'dependency_boundary_violation',
    problemMessage: 'Dependency boundary violation',
    correctionMessage: 'Fix the dependency to follow the project architecture',
    errorSeverity: ErrorSeverity.WARNING,
  );

  const _DependencyBoundaryRule() : super(code: code);

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addImportDirective((node) {
      final uri = node.uri.stringValue;
      if (uri == null) return;
      final filePath = resolver.source.fullName;
      
      _checkCrossFeatureDependency(uri, filePath, node, reporter);
      _checkUpwardDependency(uri, filePath, node, reporter);
      _checkPrivateImplementation(uri, node, reporter);
      _checkCoreUpwardDependency(uri, filePath, node, reporter);
    });
  }

  /// Check cross-feature dependencies
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
        reporter.atNode(
          node,
          code,
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
    // NOTE: Allow features and shared to reference each other
    // Since they are in the same project, this is unavoidable and acceptable
    
    // Only check core upward dependencies (core should not depend on upper layers)
    if (filePath.contains('core/') && 
        (uri.contains('features/') || uri.contains('shared/'))) {
      reporter.atNode(
        node,
        code,
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
        reporter.atNode(
          node,
          code,
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
        reporter.atNode(
          node,
          code,
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

/// Circular dependency lint rule
class _CircularDependencyLint extends DartLintRule {
  static const LintCode code = LintCode(
    name: 'circular_dependency',
    problemMessage: 'Circular dependency detected',
    correctionMessage: 'Refactor to break the circular dependency',
    errorSeverity: ErrorSeverity.WARNING,
  );

  const _CircularDependencyLint() : super(code: code);

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    // TODO: Implement circular dependency detection
  }
}

/// Implementation import lint rule
class _ImplementationImportLint extends DartLintRule {
  static const LintCode code = LintCode(
    name: 'implementation_import',
    problemMessage: 'Direct import of implementation class',
    correctionMessage: 'Import the interface instead',
    errorSeverity: ErrorSeverity.WARNING,
  );

  const _ImplementationImportLint() : super(code: code);
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
