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
    const _UseCommonTextRule(),
    const _UseCommonButtonRule(),
    const _UseCommonIconButtonRule(),
    const _UseCommonDialogRule(),
    const _UseCommonSwitchRule(),
    const _UseCommonTextFieldRule(),
    const _UseCommonRefreshListRule(),
    const _ViewModelContextIsolationRule(),
    const _CrossFeatureRelativeImportRule(),
    const _NoHardcodedStringsRule(),
    const _NoRawColorRule(),
    const _NoDirectStateAssignmentRule(),
    const _NoDirectAppNavUsageRule(),
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

      final filePath = resolver.source.fullName;

      // Allow provider/dependency injection files to import implementations to instantiate them
      if (filePath.contains('/provider/') || filePath.endsWith('_provider.dart')) {
        return;
      }

      // Allow data layer files to import implementations (e.g. repository impl importing datasource impl)
      if (filePath.contains('/data/')) {
        return;
      }

      // Check if importing implementation classes (usually in data/impl or implementation directories)
      if (uri.contains('implementation/') || 
          uri.contains('impl/') ||
          uri.contains('_impl.dart') ||
          uri.contains('data/repositories/') ||
          uri.contains('data/datasources/')) {
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

/// Rule to check and discourage direct usage of Text
class _UseCommonTextRule extends DartLintRule {
  static const LintCode _code = LintCode(
    name: 'use_common_text',
    problemMessage: 'Avoid using Text widget directly.',
    correctionMessage: 'Replace with CommonText from package:listen_uikit.',
  );

  const _UseCommonTextRule() : super(code: _code);

  @override
  List<Fix> getFixes() => [_UseCommonTextFix()];

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

      if (typeName == 'Text') {
        reporter.atNode(
          node,
          _code,
        );
      }
    });
  }
}

class _UseCommonTextFix extends DartFix {
  _UseCommonTextFix();

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
      if (typeName != 'Text') return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Replace with CommonText',
        priority: 80,
      );

      changeBuilder.addDartFileEdit((builder) {
        builder.importLibraryElement(Uri.parse('package:listen_uikit/uikit.dart'));

        final constructorName = node.constructorName;
        builder.addSimpleReplacement(
          SourceRange(constructorName.offset, constructorName.length),
          'CommonText',
        );
      });
    });
  }
}

/// Rule to check and discourage direct usage of basic Button widgets
class _UseCommonButtonRule extends DartLintRule {
  static const LintCode _code = LintCode(
    name: 'use_common_button',
    problemMessage: 'Avoid using basic Button widgets directly.',
    correctionMessage: 'Replace with CommonButton from package:listen_uikit.',
  );

  const _UseCommonButtonRule() : super(code: _code);

  @override
  List<Fix> getFixes() => [_UseCommonButtonFix()];

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

      final isBasicButton = typeName == 'ElevatedButton' ||
          typeName == 'TextButton' ||
          typeName == 'OutlinedButton' ||
          typeName == 'FilledButton' ||
          typeName == 'CupertinoButton';

      if (isBasicButton) {
        reporter.atNode(
          node,
          _code,
        );
      }
    });
  }
}

class _UseCommonButtonFix extends DartFix {
  _UseCommonButtonFix();

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
      
      final isBasicButton = typeName == 'ElevatedButton' ||
          typeName == 'TextButton' ||
          typeName == 'OutlinedButton' ||
          typeName == 'FilledButton' ||
          typeName == 'CupertinoButton';

      if (!isBasicButton) return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Replace with CommonButton',
        priority: 80,
      );

      changeBuilder.addDartFileEdit((builder) {
        builder.importLibraryElement(Uri.parse('package:listen_uikit/uikit.dart'));

        final constructorName = node.constructorName;
        builder.addSimpleReplacement(
          SourceRange(constructorName.offset, constructorName.length),
          'CommonButton',
        );
      });
    });
  }
}

/// Rule to check and discourage direct usage of basic IconButton widgets
class _UseCommonIconButtonRule extends DartLintRule {
  static const LintCode _code = LintCode(
    name: 'use_common_icon_button',
    problemMessage: 'Avoid using basic IconButton widgets directly.',
    correctionMessage: 'Replace with CommonIconButton from package:listen_uikit.',
  );

  const _UseCommonIconButtonRule() : super(code: _code);

  @override
  List<Fix> getFixes() => [_UseCommonIconButtonFix()];

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

      final isBasicIconButton = typeName == 'IconButton' ||
          typeName == 'FilledIconButton' ||
          typeName == 'FilledTonalIconButton' ||
          typeName == 'OutlinedIconButton';

      if (isBasicIconButton) {
        reporter.atNode(
          node,
          _code,
        );
      }
    });
  }
}

class _UseCommonIconButtonFix extends DartFix {
  _UseCommonIconButtonFix();

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
      
      final isBasicIconButton = typeName == 'IconButton' ||
          typeName == 'FilledIconButton' ||
          typeName == 'FilledTonalIconButton' ||
          typeName == 'OutlinedIconButton';

      if (!isBasicIconButton) return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Replace with CommonIconButton',
        priority: 80,
      );

      changeBuilder.addDartFileEdit((builder) {
        builder.importLibraryElement(Uri.parse('package:listen_uikit/uikit.dart'));

        final constructorName = node.constructorName;
        builder.addSimpleReplacement(
          SourceRange(constructorName.offset, constructorName.length),
          'CommonIconButton',
        );
      });
    });
  }
}

/// Rule to check and discourage direct usage of showDialog and showGeneralDialog
class _UseCommonDialogRule extends DartLintRule {
  static const LintCode _code = LintCode(
    name: 'use_common_dialog',
    problemMessage: 'Avoid using showDialog or showGeneralDialog directly.',
    correctionMessage: 'Use CommonDialog helper methods instead.',
  );

  const _UseCommonDialogRule() : super(code: _code);

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addMethodInvocation((MethodInvocation node) {
      final name = node.methodName.name;
      if (name != 'showDialog' && name != 'showGeneralDialog' && name != 'showCupertinoDialog') return;
      
      // Ensure it is a top-level or library function from package:flutter
      final element = node.methodName.element;
      final libraryUri = element?.library?.uri.toString() ?? '';
      if (!libraryUri.startsWith('package:flutter/')) return;

      // Avoid flagging files in ListenUiKit or within tools/
      final filePath = resolver.source.fullName;
      if (filePath.contains('ListenUiKit') || filePath.contains('tools/')) return;

      reporter.atNode(
        node,
        _code,
      );
    });
  }
}

/// Rule to check and discourage direct usage of Switch
class _UseCommonSwitchRule extends DartLintRule {
  static const LintCode _code = LintCode(
    name: 'use_common_switch',
    problemMessage: 'Avoid using Switch widget directly.',
    correctionMessage: 'Replace with CommonSwitch from package:listen_uikit.',
  );

  const _UseCommonSwitchRule() : super(code: _code);

  @override
  List<Fix> getFixes() => [_UseCommonSwitchFix()];

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

      if (typeName == 'Switch' || typeName == 'CupertinoSwitch') {
        reporter.atNode(
          node,
          _code,
        );
      }
    });
  }
}

class _UseCommonSwitchFix extends DartFix {
  _UseCommonSwitchFix();

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
      if (typeName != 'Switch' && typeName != 'CupertinoSwitch') return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Replace with CommonSwitch',
        priority: 80,
      );

      changeBuilder.addDartFileEdit((builder) {
        builder.importLibraryElement(Uri.parse('package:listen_uikit/uikit.dart'));

        final constructorName = node.constructorName;
        builder.addSimpleReplacement(
          SourceRange(constructorName.offset, constructorName.length),
          'CommonSwitch',
        );
      });
    });
  }
}

/// Rule to check and discourage direct usage of TextField and TextFormField
class _UseCommonTextFieldRule extends DartLintRule {
  static const LintCode _code = LintCode(
    name: 'use_common_text_field',
    problemMessage: 'Avoid using TextField or TextFormField directly.',
    correctionMessage: 'Replace with CommonTextField from package:listen_uikit.',
  );

  const _UseCommonTextFieldRule() : super(code: _code);

  @override
  List<Fix> getFixes() => [_UseCommonTextFieldFix()];

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

      if (typeName == 'TextField' || typeName == 'TextFormField') {
        reporter.atNode(
          node,
          _code,
        );
      }
    });
  }
}

class _UseCommonTextFieldFix extends DartFix {
  _UseCommonTextFieldFix();

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
      if (typeName != 'TextField' && typeName != 'TextFormField') return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Replace with CommonTextField',
        priority: 80,
      );

      changeBuilder.addDartFileEdit((builder) {
        builder.importLibraryElement(Uri.parse('package:listen_uikit/uikit.dart'));

        final constructorName = node.constructorName;
        builder.addSimpleReplacement(
          SourceRange(constructorName.offset, constructorName.length),
          'CommonTextField',
        );
      });
    });
  }
}

/// Rule to check and discourage direct usage of RefreshIndicator or CupertinoSliverRefreshControl
class _UseCommonRefreshListRule extends DartLintRule {
  static const LintCode _code = LintCode(
    name: 'use_common_refresh_list',
    problemMessage: 'Avoid using RefreshIndicator or CupertinoSliverRefreshControl directly.',
    correctionMessage: 'Replace with CommonRefreshList from package:listen_uikit.',
  );

  const _UseCommonRefreshListRule() : super(code: _code);

  @override
  List<Fix> getFixes() => [_UseCommonRefreshListFix()];

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

      final isBasicRefresh = typeName == 'RefreshIndicator' ||
          typeName == 'CupertinoSliverRefreshControl';

      if (isBasicRefresh) {
        reporter.atNode(
          node,
          _code,
        );
      }
    });
  }
}

class _UseCommonRefreshListFix extends DartFix {
  _UseCommonRefreshListFix();

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
      
      final isBasicRefresh = typeName == 'RefreshIndicator' ||
          typeName == 'CupertinoSliverRefreshControl';

      if (!isBasicRefresh) return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Replace with CommonRefreshList',
        priority: 80,
      );

      changeBuilder.addDartFileEdit((builder) {
        builder.importLibraryElement(Uri.parse('package:listen_uikit/uikit.dart'));

        final constructorName = node.constructorName;
        builder.addSimpleReplacement(
          SourceRange(constructorName.offset, constructorName.length),
          'CommonRefreshList',
        );
      });
    });
  }
}

/// Rule to check and discourage BuildContext in ViewModels
class _ViewModelContextIsolationRule extends DartLintRule {
  static const LintCode _code = LintCode(
    name: 'view_model_context_isolation',
    problemMessage: 'ViewModels should not reference BuildContext directly.',
    correctionMessage: 'Remove BuildContext usage from ViewModel. Emitting Effects instead.',
  );

  const _ViewModelContextIsolationRule() : super(code: _code);

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    final filePath = resolver.source.fullName;
    if (!filePath.endsWith('_view_model.dart')) return;

    context.registry.addSimpleIdentifier((SimpleIdentifier node) {
      if (node.name == 'BuildContext') {
        reporter.atNode(node, _code);
      }
    });
  }
}

/// Rule to check and discourage cross-feature relative imports
class _CrossFeatureRelativeImportRule extends DartLintRule {
  static const LintCode _code = LintCode(
    name: 'cross_feature_relative_import',
    problemMessage: 'Cross-feature relative imports are not allowed.',
    correctionMessage: 'Import via package paths or defined routing endpoints.',
  );

  const _CrossFeatureRelativeImportRule() : super(code: _code);

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addImportDirective((ImportDirective node) {
      final uri = node.uri.stringValue;
      if (uri == null) return;
      if (!uri.startsWith('.')) return;

      final filePath = resolver.source.fullName;
      if (!filePath.contains('features/')) return;

      // Extract current feature directory name
      final currentMatch = RegExp(r'features/([^/]+)/').firstMatch(filePath);
      if (currentMatch == null) return;
      final currentFeature = currentMatch.group(1);

      // Check if relative path leaves feature bounds
      if (uri.contains('features/')) {
        final importedMatch = RegExp(r'features/([^/]+)/').firstMatch(uri);
        if (importedMatch != null) {
          final importedFeature = importedMatch.group(1);
          if (currentFeature != importedFeature) {
            reporter.atNode(node, _code);
          }
        }
      } else if (uri.startsWith('../..') && 
                 (uri.contains('/about_me/') || 
                  uri.contains('/home/') || 
                  uri.contains('/settings/') || 
                  uri.contains('/splash/') || 
                  uri.contains('/auth/'))) {
        reporter.atNode(node, _code);
      }
    });
  }
}

/// Rule to check and discourage hardcoded strings in Text widgets
class _NoHardcodedStringsRule extends DartLintRule {
  static const LintCode _code = LintCode(
    name: 'no_hardcoded_strings',
    problemMessage: 'Avoid hardcoding user-facing strings.',
    correctionMessage: 'Use I18nKeys.something.tr for localization.',
  );

  const _NoHardcodedStringsRule() : super(code: _code);

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    final filePath = resolver.source.fullName;
    // Exclude tests, generated files, localizations themselves, and system files
    if (filePath.contains('/test/') || 
        filePath.contains('.g.dart') || 
        filePath.contains('.freezed.dart') || 
        filePath.contains('/i18n/') || 
        filePath.contains('tools/')) return;

    context.registry.addInstanceCreationExpression((InstanceCreationExpression node) {
      final typeElement = node.staticType?.element;
      if (typeElement == null) return;
      final typeName = typeElement.name;
      if (typeName != 'Text' && typeName != 'CommonText') return;

      final arguments = node.argumentList.arguments;
      if (arguments.isEmpty) return;

      final firstArg = arguments.first;
      if (firstArg is StringLiteral) {
        final value = firstArg.stringValue;
        if (value == null) return;
        // Verify string contains alphabetic chars (prevent flagging symbols/numbers)
        final hasLetters = RegExp(r'[a-zA-Z\u4e00-\u9fa5]+').hasMatch(value);
        if (hasLetters) {
          reporter.atNode(firstArg, _code);
        }
      }
    });
  }
}

/// Rule to check and discourage direct usage of raw Colors
class _NoRawColorRule extends DartLintRule {
  static const LintCode _code = LintCode(
    name: 'no_raw_color',
    problemMessage: 'Avoid using raw Colors or hex Color values directly.',
    correctionMessage: 'Use context.theme or theme extension colors instead for dark mode safety.',
  );

  const _NoRawColorRule() : super(code: _code);

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    final filePath = resolver.source.fullName;
    if (filePath.contains('ListenUiKit') || 
        filePath.contains('tools/') || 
        filePath.endsWith('_view_model.dart') || 
        filePath.endsWith('_state.dart') || 
        filePath.endsWith('_intent.dart') || 
        filePath.contains('/theme/') ||
        filePath.contains('app_theme.dart') ||
        filePath.contains('/i18n/')) return;

    // Detect direct Color(...) instantiation
    context.registry.addInstanceCreationExpression((InstanceCreationExpression node) {
      final typeElement = node.staticType?.element;
      if (typeElement == null) return;
      final typeName = typeElement.name;
      if (typeName == 'Color') {
        reporter.atNode(node, _code);
      }
    });

    // Detect Colors.xxx access
    context.registry.addPrefixedIdentifier((PrefixedIdentifier node) {
      if (node.prefix.name == 'Colors') {
        reporter.atNode(node, _code);
      }
    });
  }
}

/// Rule to check and discourage direct assignment to state in ViewModels
class _NoDirectStateAssignmentRule extends DartLintRule {
  static const LintCode _code = LintCode(
    name: 'no_direct_state_assignment',
    problemMessage: 'ViewModels should use updateState instead of direct assignment to state.',
    correctionMessage: 'Replace state = ... with updateState(...).',
  );

  const _NoDirectStateAssignmentRule() : super(code: _code);

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    final filePath = resolver.source.fullName;
    if (!filePath.endsWith('_view_model.dart')) return;

    context.registry.addAssignmentExpression((AssignmentExpression node) {
      final left = node.leftHandSide;
      if (left is SimpleIdentifier && left.name == 'state') {
        reporter.atNode(node, _code);
      }
    });
  }
}

/// Rule to check and discourage direct usage of AppNav in UI or ViewModels
class _NoDirectAppNavUsageRule extends DartLintRule {
  static const LintCode _code = LintCode(
    name: 'no_direct_app_nav_usage',
    problemMessage: 'Avoid calling AppNav methods directly in feature code.',
    correctionMessage: 'Emit a NavigationEffect (using emitEffect) to perform navigation via MVI flow.',
  );

  const _NoDirectAppNavUsageRule() : super(code: _code);

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    final filePath = resolver.source.fullName.replaceAll('\\', '/');
    // We only check files under features/ to ensure they conform to pure MVI flow.
    if (!filePath.contains('/features/')) return;
    // Exclude tests or generated files if any
    if (filePath.contains('/test/') || filePath.contains('.g.dart') || filePath.contains('.freezed.dart')) return;

    context.registry.addMethodInvocation((MethodInvocation node) {
      final target = node.target;
      if (target is SimpleIdentifier && target.name == 'AppNav') {
        final methodName = node.methodName.name;
        if (methodName == 'to' || 
            methodName == 'back' || 
            methodName == 'off' || 
            methodName == 'offAll') {
          reporter.atNode(node, _code);
        }
      }
    });
  }
}

/// Main function - for testing
void main() {
  print('Dependency Lint Rules Plugin with Common Widgets check');
  print('Usage: Add custom_lint dependency in pubspec.yaml');
  print('Then enable rules in analysis_options.yaml');
}
