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
  // 💡 DESIGN NOTE: Function Parameter Contravariance & Implicit Downcasting
  // Why do we use `(effect as dynamic).onResult` instead of `effect.onResult`?
  //
  // 1. Type Conflict:
  //    The page callback passed (e.g. `onResult: (LoginState? state) {}`) has a
  //    concrete runtime type of `void Function(LoginState?)`. However, since
  //    `effect` is statically typed as `NavigationEffect<dynamic>` here, its
  //    `onResult` getter is statically expected to return `void Function(dynamic)?`.
  //
  // 2. Contravariance Restriction:
  //    In Dart, a function expecting a specific parameter type (narrow) cannot be
  //    assigned to a variable expecting a general parameter type (wide/dynamic),
  //    because it would be unsafe if someone invoked the variable with a different
  //    type (e.g. calling it with a String). Therefore, accessing `effect.onResult`
  //    directly causes Dart's runtime implicit downcast check to throw:
  //    `type '(LoginState?) => void' is not a subtype of type '((dynamic) => void)?'`.
  //
  // 3. Solution:
  //    Casting the entire `effect` to `dynamic` bypasses the static getter
  //    downcast check, allowing Dart to retrieve the raw function reference via
  //    dynamic dispatch and call it safely with the actual return value.
  void handleEffect(NavigationEffect<dynamic> effect) async {
    if (effect.isBack) {
      AppNav.back(effect.arguments);
    } else if (effect.isReplace) {
      final result = await AppNav.off(
        effect.target,
        needLogin: effect.needLogin,
        arguments: effect.arguments as Map<String, dynamic>?,
      );
      (effect as dynamic).onResult?.call(result);
    } else if (effect.isReplaceAll) {
      final result = await AppNav.offAll(
        effect.target,
        needLogin: effect.needLogin,
        arguments: effect.arguments as Map<String, dynamic>?,
      );
      (effect as dynamic).onResult?.call(result);
    } else {
      final result = await AppNav.to(
        effect.target,
        needLogin: effect.needLogin,
        arguments: effect.arguments,
        replaceIfExists: effect.replaceIfExists,
      );
      (effect as dynamic).onResult?.call(result);
    }
  }
}
