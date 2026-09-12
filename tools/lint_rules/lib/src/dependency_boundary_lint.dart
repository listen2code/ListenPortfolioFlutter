// ignore_for_file: avoid_print
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Entrypoint function invoked by the `custom_lint` analysis server plugin runner.
PluginBase createPlugin() => DependencyBoundaryLint();

/// ============================================================================
/// DependencyBoundaryLint Plugin
/// ============================================================================
///
/// A comprehensive custom static analysis plugin tailored for the ListenPortfolio
/// architecture, powered by `custom_lint_builder` and the Dart Analyzer AST.
///
/// ### Rule Classification Matrix:
/// 1. **Architectural & Boundary Governance**:
///    - [_DependencyBoundaryRule]: Enforces strict unidirectional dependencies between layers.
///    - [_CircularDependencyLint]: Detects cyclic module dependency graphs.
///    - [_ImplementationImportLint]: Enforces dependency inversion by barring direct imports of data/impl classes.
///    - [_CrossFeatureRelativeImportRule]: Prevents relative imports from escaping feature module boundaries.
///    - [_NoDirectAppNavUsageRule]: Guards unidirectional navigation via MVI Effects.
///
/// 2. **Clean Architecture & MVI Purity**:
///    - [_ViewModelContextIsolationRule]: Enforces separation of concerns by barring [BuildContext] in ViewModels.
///    - [_NoDirectStateAssignmentRule]: Ensures state immutability by requiring `updateState(...)`.
///
/// 3. **Design System & Component Governance**:
///    - [_UseCommonImageRule], [_UseCommonClickableRule], [_UseCommonTextRule],
///      [_UseCommonButtonRule], [_UseCommonIconButtonRule], [_UseCommonDialogRule],
///      [_UseCommonSwitchRule], [_UseCommonTextFieldRule], [_UseCommonRefreshListRule]:
///      Steers code towards the standardized `ListenUiKit` component ecosystem with
///      automated Quick-Fix (`--fix`) AST transformations.
///
/// 4. **Design Tokens & Localization Safety**:
///    - [_NoHardcodedStringsRule]: Mandates i18n localization keys (`I18nKeys.xxx.tr`).
///    - [_NoRawColorRule]: Prevents raw hex/Color hardcoding to guarantee dark mode compatibility.
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

/// ============================================================================
/// _DependencyBoundaryRule
/// ============================================================================
/// Enforces architectural boundary constraints on [ImportDirective] nodes:
/// 1. Feature Isolation: `features/moduleA` must never import from `features/moduleB`.
/// 2. Upward Dependency Guard: Core framework layer must never depend on upper layers (`features/` or `shared/`).
/// 3. Private File Encapsulation: Files prefixed with an underscore (`_xxx.dart`) are private and cannot be imported.
/// 4. Relative Path Integrity: Core module must not use `../` relative paths to reach into upper layers.
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

/// ============================================================================
/// _CircularDependencyLint
/// ============================================================================
/// Intended to detect cyclic import dependencies (e.g. A -> B -> C -> A) across files.
///
/// ### Architecture Note & Current Limitation:
/// Dart's `custom_lint_builder` processes compilation units modularly in the IDE.
/// Accurately detecting cycles across the entire codebase requires building and
/// querying a global directed dependency graph (using Tarjan's Strongly Connected
/// Components or DFS cycle detection). This rule serves as an architectural placeholder
/// while full cycle verification is executed by `tools/dependency_rules.dart --check-circular`.
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
    // [Placeholder] Circular dependency detection across modular AST units is registered
    // for future full-graph analyzer integration. Active checks run via tools/dependency_rules.dart.
  }
}

/// ============================================================================
/// _ImplementationImportLint
/// ============================================================================
/// Enforces the Dependency Inversion Principle (DIP) by prohibiting presentation
/// and domain layers from directly importing concrete data-layer implementation files
/// (e.g., `_impl.dart`, `impl/`, `data/repositories/`, `data/datasources/`).
///
/// ### Permitted Architectural Exceptions:
/// 1. **Dependency Injection Providers** (`/provider/` or `_provider.dart`):
///    Permitted to instantiate concrete classes for Riverpod DI bindings.
/// 2. **Data Layer Internals** (`/data/`):
///    Repository implementations are permitted to import their corresponding DataSource implementations.
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

      // Exception 1: Allow provider/dependency injection files to instantiate concrete implementations
      if (filePath.contains('/provider/') || filePath.endsWith('_provider.dart')) {
        return;
      }

      // Exception 2: Allow data layer internals to import each other (e.g. RepositoryImpl -> DataSourceImpl)
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

/// ============================================================================
/// _UseCommonImageRule & _UseCommonImageFix
/// ============================================================================
/// Enforces the adoption of [CommonImage] from `ListenUiKit` over Flutter SDK's raw [Image].
///
/// ### Architectural Rationale:
/// - Provides unified memory/disk caching, SVG support, and sub-microsecond Base64 decoding.
/// - Incorporates mandatory `errorBuilder` isolation to prevent `ImageCodecException`
///   from starving the Dart Event Loop during 60fps animations.
///
/// ### Quick-Fix AST Transformations:
/// - Injects `import 'package:listen_uikit/uikit.dart';` (with deduplication).
/// - Translates constructors:
///   - `Image.asset(...)`   -> `CommonImage.asset(...)`
///   - `Image.network(...)` -> `CommonImage.url(...)`
///   - `Image.file(...)`    -> `CommonImage.file(...)`
///   - `Image(...)`         -> `CommonImage(...)`
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

/// Automated AST Quick-Fix for replacing raw `Image` instances with `CommonImage`.
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

/// ============================================================================
/// _UseCommonClickableRule & _UseCommonClickableFix
/// ============================================================================
/// Enforces the adoption of [CommonClickable] from `ListenUiKit` over Flutter's
/// raw [InkWell] or [GestureDetector].
///
/// ### Architectural Rationale:
/// - Provides consistent haptic feedback, debounce throttling, and responsive scale animations.
/// - Unifies ripple configurations across platforms.
///
/// ### Quick-Fix AST Transformations:
/// - Replaces constructor with `CommonClickable`.
/// - For [GestureDetector], automatically prepends `ripple: false, ` to arguments
///   to preserve the non-ripple gesture behavior.
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

/// Automated AST Quick-Fix for replacing `InkWell` or `GestureDetector` with `CommonClickable`.
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

/// ============================================================================
/// _UseCommonTextRule & _UseCommonTextFix
/// ============================================================================
/// Enforces the adoption of [CommonText] from `ListenUiKit` over raw [Text].
///
/// ### Architectural Rationale:
/// - Guarantees application of the active 7-tier dynamic typography family (`fontFamilyFallback`).
/// - Integrates responsive scaling (`NumScaleX.f`) and anti-truncation `useFittedBox` guards.
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

/// ============================================================================
/// _UseCommonButtonRule & _UseCommonButtonFix
/// ============================================================================
/// Enforces the adoption of [CommonButton] from `ListenUiKit` over Flutter SDK's
/// various button variants ([ElevatedButton], [TextButton], [OutlinedButton],
/// [FilledButton], [CupertinoButton]).
///
/// ### Architectural Rationale:
/// - Unifies button height, rounded corner styling, loading state spinner, and tap animations.
/// - Guarantees design token adherence across light and dark themes.
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

/// Automated AST Quick-Fix for converting basic Button instances to `CommonButton`.
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

/// ============================================================================
/// _UseCommonIconButtonRule & _UseCommonIconButtonFix
/// ============================================================================
/// Enforces the adoption of [CommonIconButton] from `ListenUiKit` over SDK icon buttons
/// ([IconButton], [FilledIconButton], [FilledTonalIconButton], [OutlinedIconButton]).
///
/// ### Architectural Rationale:
/// - Provides normalized 44x44 minimum touch targets for accessibility compliance.
/// - Standardizes splash padding, hit test bounds, and disabled opacity.
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

/// ============================================================================
/// _UseCommonDialogRule
/// ============================================================================
/// Enforces triggering dialogs via [CommonDialog] utility methods instead of
/// calling Flutter's raw [showDialog], [showGeneralDialog], or [showCupertinoDialog].
///
/// ### Architectural Rationale:
/// - Guarantees Single UI Binder dialog queue governance (preventing double dialogs).
/// - Enforces uniform barrier dismissibility, entry/exit scale transitions, and dark mode theming.
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

/// ============================================================================
/// _UseCommonSwitchRule & _UseCommonSwitchFix
/// ============================================================================
/// Enforces the adoption of [CommonSwitch] from `ListenUiKit` over Flutter SDK's
/// raw [Switch] or [CupertinoSwitch].
///
/// ### Architectural Rationale:
/// - Provides consistent thumb track sizing, adaptive iOS/Material transitions,
///   and theme-aware active/inactive colors.
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

/// Automated AST Quick-Fix for converting `Switch` or `CupertinoSwitch` to `CommonSwitch`.
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

/// ============================================================================
/// _UseCommonTextFieldRule & _UseCommonTextFieldFix
/// ============================================================================
/// Enforces the adoption of [CommonTextField] from `ListenUiKit` over raw
/// [TextField] or [TextFormField].
///
/// ### Architectural Rationale:
/// - Standardizes floating label layout, clear icon behavior, obscure text toggling,
///   and error state borders with brand typography.
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

/// ============================================================================
/// _UseCommonRefreshListRule & _UseCommonRefreshListFix
/// ============================================================================
/// Enforces the adoption of [CommonRefreshList] from `ListenUiKit` over Flutter's
/// raw [RefreshIndicator] or [CupertinoSliverRefreshControl].
///
/// ### Architectural Rationale:
/// - Provides unified pull-to-refresh indicators, empty state illustrations,
///   and error retry triggers across platforms.
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

/// Automated AST Quick-Fix for replacing `RefreshIndicator` or `CupertinoSliverRefreshControl` with `CommonRefreshList`.
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

/// ============================================================================
/// _ViewModelContextIsolationRule
/// ============================================================================
/// Enforces strict architectural separation of concerns by barring [BuildContext]
/// from any file matching `*_view_model.dart`.
///
/// ### Architectural Rationale:
/// - ViewModels must remain pure business logic units capable of unit testing without widget testers.
/// - Retaining [BuildContext] references leads to memory leaks across widget tree disposal.
/// - UI actions (dialogs, toasts, navigations) must be dispatched via MVI `emitEffect(...)`.
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

/// ============================================================================
/// _CrossFeatureRelativeImportRule
/// ============================================================================
/// Forbids relative imports from crossing feature module boundaries.
///
/// ### Architectural Rationale:
/// - Feature modules (`features/xxx`) should be autonomous and decoupled.
/// - Relative imports like `../../other_feature/some_file.dart` create brittle couplings
///   that break modular compilation and independent testability.
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

/// ============================================================================
/// _NoHardcodedStringsRule
/// ============================================================================
/// Flags hardcoded literal strings inside [Text] or [CommonText] widgets.
///
/// ### Architectural Rationale:
/// - Guarantees full localization (i18n) support across Chinese, English, and Japanese.
/// - Prevents accidental un-translated strings in production releases.
/// - Uses a Unicode regex (`[a-zA-Z\u4e00-\u9fa5]+`) to ignore numbers, punctuation, and math symbols.
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
        // Verify string contains alphabetic or CJK chars (prevent flagging symbols/numbers)
        final hasLetters = RegExp(r'[a-zA-Z\u4e00-\u9fa5]+').hasMatch(value);
        if (hasLetters) {
          reporter.atNode(firstArg, _code);
        }
      }
    });
  }
}

/// ============================================================================
/// _NoRawColorRule
/// ============================================================================
/// Flags direct instantiation of `Color(...)` or references to `Colors.xxx`.
///
/// ### Architectural Rationale:
/// - Guarantees seamless dark/light theme switching without visual artifacts or contrast failures.
/// - Mandates the use of theme tokens (`context.theme.xxx` or theme extensions).
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

/// ============================================================================
/// _NoDirectStateAssignmentRule
/// ============================================================================
/// Enforces MVI state immutability by flagging direct assignments to `state = ...`
/// within files matching `*_view_model.dart`.
///
/// ### Architectural Rationale:
/// - Direct assignment bypasses state transition hooks and MVI playback recording.
/// - Requires using `updateState(state.copyWith(...))` to ensure atomic transitions.
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

/// ============================================================================
/// _NoDirectAppNavUsageRule
/// ============================================================================
/// Prohibits feature-level code from directly calling `AppNav` navigation methods
/// (`AppNav.to`, `AppNav.back`, `AppNav.off`, `AppNav.offAll`).
///
/// ### Architectural Rationale:
/// - Enforces pure unidirectional MVI architecture: UI dispatches Intents, ViewModels
///   emit `NavigationEffect`, and the View executes the navigation.
/// - Decouples business logic from imperative navigation frameworks for easier testing.
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
