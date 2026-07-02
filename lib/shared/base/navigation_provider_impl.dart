import 'package:listen_core/core.dart';

/// Standard Effect for navigating to a new target reactively.
class NavigationEffect extends BaseEffect {
  /// The navigation target (Route path or Object). Can be null for back operations.
  final dynamic target;
  final bool isReplace;
  final bool isReplaceAll;
  final bool isBack;
  final Object? arguments;
  final bool needLogin;

  NavigationEffect({
    this.target,
    this.isReplace = false,
    this.isReplaceAll = false,
    this.isBack = false,
    this.arguments,
    this.needLogin = false,
  });

  /// Helper constructor for back navigation.
  factory NavigationEffect.back({Object? result}) => NavigationEffect(isBack: true, arguments: result);

  @override
  String toString() {
    return 'NavigationEffect(target: $target, isReplace: $isReplace, isBack: $isBack, needLogin: $needLogin, arguments: $arguments';
  }
}

/// Concrete implementation for handling [NavigationEffect] using [AppNav].
class NavigationProviderImpl extends BaseProvider<NavigationEffect> {
  const NavigationProviderImpl();

  @override
  void handleEffect(NavigationEffect effect) {
    if (effect.isBack) {
      AppNav.back(effect.arguments);
    } else if (effect.isReplace) {
      AppNav.off(
        effect.target,
        needLogin: effect.needLogin,
        arguments: effect.arguments as Map<String, dynamic>?,
      );
    } else if (effect.isReplaceAll) {
      AppNav.offAll(
        effect.target,
        needLogin: effect.needLogin,
        arguments: effect.arguments as Map<String, dynamic>?,
      );
    } else {
      AppNav.to(effect.target, needLogin: effect.needLogin, arguments: effect.arguments);
    }
  }
}
