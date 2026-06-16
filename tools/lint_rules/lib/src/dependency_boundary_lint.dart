// ignore_for_file: avoid_print
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Entrypoint for custom_lint
PluginBase createPlugin() => DependencyBoundaryLint();

/// Dependency boundary lint rules plugin
class DependencyBoundaryLint extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
    const _DependencyBoundaryRule(),
    const _CircularDependencyLint(),
    const _ImplementationImportLint(),
    const _UseCommonImageRule(),
    const _UseCommonClickableRule(),
  ];
}

/// Main dependency boundary rule
class _DependencyBoundaryRule extends DartLintRule {
  static const LintCode _code = LintCode(
    name: 'dependency_boundary_violation',
    problemMessage: 'Dependency boundary violation',
    correctionMessage: 'Fix the dependency to follow the project architecture',
  );

  const _DependencyBoundaryRule() : super(code: _code);

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addImportDirective((ImportDirective node) {
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
          _code,
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
        _code,
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
          _code,
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
          _code,
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
  static const LintCode _code = LintCode(
    name: 'circular_dependency',
    problemMessage: 'Circular dependency detected',
    correctionMessage: 'Refactor to break the circular dependency',
  );

  const _CircularDependencyLint() : super(code: _code);

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
  static const LintCode _code = LintCode(
    name: 'implementation_import',
    problemMessage: 'Direct import of implementation class',
    correctionMessage: 'Import the interface instead',
  );

  const _ImplementationImportLint() : super(code: _code);

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addImportDirective((ImportDirective node) {
      final uri = node.uri.stringValue;
      if (uri == null) return;

      // Check if importing implementation classes (usually in data/impl or implementation directories)
      if (uri.contains('implementation/') || 
          uri.contains('impl/') ||
          uri.contains('_impl.dart')) {
        reporter.atNode(
          node,
          _code,
          arguments: ['Avoid direct import of implementation classes, should depend on abstract interfaces'],
        );
      }
    });
  }
}

/// Rule to check and discourage direct usage of Image
class _UseCommonImageRule extends DartLintRule {
  static const LintCode _code = LintCode(
    name: 'use_common_image',
    problemMessage: 'Avoid using Image widget directly.',
    correctionMessage: 'Replace with CommonImage from package:listen_uikit.',
  );

  const _UseCommonImageRule() : super(code: _code);

  @override
  List<Fix> getFixes() => [_UseCommonImageFix()];

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((InstanceCreationExpression node) {
      final typeElement = node.staticType?.element;
      if (typeElement == null) return;

      final typeName = typeElement.name;
      final libraryUri = typeElement.library?.uri.toString() ?? '';
      
      // Check if it is a Flutter SDK widget creation
      final isFlutterWidget = libraryUri.startsWith('package:flutter/');
      if (!isFlutterWidget) return;

      // Avoid flagging files in ListenUiKit or within tools/
      final filePath = resolver.source.fullName;
      if (filePath.contains('ListenUiKit') || filePath.contains('tools/')) return;

      if (typeName == 'Image') {
        reporter.atNode(
          node,
          _code,
        );
      }
    });
  }
}

class _UseCommonImageFix extends DartFix {
  _UseCommonImageFix();

  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addInstanceCreationExpression((InstanceCreationExpression node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) return;

      final typeElement = node.staticType?.element;
      if (typeElement == null) return;
      final typeName = typeElement.name;
      if (typeName != 'Image') return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Replace with CommonImage',
        priority: 80,
      );

      changeBuilder.addDartFileEdit((builder) {
        builder.importLibraryElement(Uri.parse('package:listen_uikit/uikit.dart'));

        final constructorName = node.constructorName;
        final name = constructorName.name?.name;

        if (name == 'asset') {
          builder.addSimpleReplacement(
            SourceRange(constructorName.offset, constructorName.length),
            'CommonImage.asset',
          );
        } else if (name == 'network') {
          builder.addSimpleReplacement(
            SourceRange(constructorName.offset, constructorName.length),
            'CommonImage.url',
          );
        } else if (name == 'file') {
          builder.addSimpleReplacement(
            SourceRange(constructorName.offset, constructorName.length),
            'CommonImage.file',
          );
        } else {
          builder.addSimpleReplacement(
            SourceRange(constructorName.offset, constructorName.length),
            'CommonImage',
          );
        }
      });
    });
  }
}

/// Rule to check and discourage direct usage of InkWell and GestureDetector
class _UseCommonClickableRule extends DartLintRule {
  static const LintCode _code = LintCode(
    name: 'use_common_clickable',
    problemMessage: 'Avoid using InkWell or GestureDetector directly.',
    correctionMessage: 'Replace with CommonClickable from package:listen_uikit.',
  );

  const _UseCommonClickableRule() : super(code: _code);

  @override
  List<Fix> getFixes() => [_UseCommonClickableFix()];

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((InstanceCreationExpression node) {
      final typeElement = node.staticType?.element;
      if (typeElement == null) return;

      final typeName = typeElement.name;
      final libraryUri = typeElement.library?.uri.toString() ?? '';
      
      // Check if it is a Flutter SDK widget creation
      final isFlutterWidget = libraryUri.startsWith('package:flutter/');
      if (!isFlutterWidget) return;

      // Avoid flagging files in ListenUiKit or within tools/
      final filePath = resolver.source.fullName;
      if (filePath.contains('ListenUiKit') || filePath.contains('tools/')) return;

      if (typeName == 'InkWell' || typeName == 'GestureDetector') {
        reporter.atNode(
          node,
          _code,
        );
      }
    });
  }
}

class _UseCommonClickableFix extends DartFix {
  _UseCommonClickableFix();

  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addInstanceCreationExpression((InstanceCreationExpression node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) return;

      final typeElement = node.staticType?.element;
      if (typeElement == null) return;
      final typeName = typeElement.name;
      if (typeName != 'InkWell' && typeName != 'GestureDetector') return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Replace with CommonClickable',
        priority: 80,
      );

      changeBuilder.addDartFileEdit((builder) {
        builder.importLibraryElement(Uri.parse('package:listen_uikit/uikit.dart'));

        final constructorName = node.constructorName;
        builder.addSimpleReplacement(
          SourceRange(constructorName.offset, constructorName.length),
          'CommonClickable',
        );

        if (typeName == 'GestureDetector') {
          builder.addSimpleInsertion(
            node.argumentList.leftParenthesis.end,
            'ripple: false, ',
          );
        }
      });
    });
  }
}

/// Main function - for testing
void main() {
  print('Dependency Lint Rules Plugin with Common Widgets check');
  print('Usage: Add custom_lint dependency in pubspec.yaml');
  print('Then enable rules in analysis_options.yaml');
}
