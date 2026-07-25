import 'package:listen_core/core.dart';

/// Standard Effect for navigating to a new target reactively.
class NavigationEffect<T> extends BaseEffect {
  /// The navigation target (Route path or Object). Can be null for back operations.
  final dynamic target;
  final Object? arguments;
  final bool isReplace;
  final bool isReplaceAll;
  final bool isBack;
  final bool needLogin;
  final bool replaceIfExists;
  final void Function(T? result)? onResult;

  NavigationEffect({
    this.target,
    this.arguments,
    this.isReplace = false,
    this.isReplaceAll = false,
    this.isBack = false,
    this.needLogin = false,
    this.replaceIfExists = false,
    this.onResult,
  });

  /// Helper constructor for back navigation.
  factory NavigationEffect.back({T? result}) => NavigationEffect<T>(isBack: true, arguments: result);

  @override
  String toString() {
    return 'NavigationEffect(target: $target, isReplace: $isReplace, isReplaceAll: $isReplaceAll, '
        'isBack: $isBack, needLogin: $needLogin, replaceIfExists: $replaceIfExists, arguments: $arguments)';
  }
}

/// Concrete implementation for handling [NavigationEffect] using [AppNav].
class NavigationProviderImpl extends BaseProvider<NavigationEffect<dynamic>> {
  const NavigationProviderImpl();

  @override
  void handleEffect(NavigationEffect<dynamic> effect) async {
    if (effect.isBack) {
      AppNav.back(effect.arguments);
    } else if (effect.isReplace) {
      final result = await AppNav.off(
        effect.target,
        needLogin: effect.needLogin,
        arguments: effect.arguments as Map<String, dynamic>?,
      );
      effect.onResult?.call(result);
    } else if (effect.isReplaceAll) {
      final result = await AppNav.offAll(
        effect.target,
        needLogin: effect.needLogin,
        arguments: effect.arguments as Map<String, dynamic>?,
      );
      effect.onResult?.call(result);
    } else {
      final result = await AppNav.to(
        effect.target,
        needLogin: effect.needLogin,
        arguments: effect.arguments,
        replaceIfExists: effect.replaceIfExists,
      );
      effect.onResult?.call(result);
    }
  }
}
