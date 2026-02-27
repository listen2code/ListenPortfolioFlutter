/// Interface for UI Side Effects (Toast, Navigation, etc.) that occur once.
abstract class BaseEffect {}

/// Standard Effect for showing error messages.
class ErrorEffect extends BaseEffect {
  final String message;

  ErrorEffect(this.message);
}

/// Standard Effect for showing general info messages.
class MessageEffect extends BaseEffect {
  final String message;

  MessageEffect(this.message);
}

/// Standard Effect for controlling global loading state.
class LoadingEffect extends BaseEffect {
  final bool show;
  final String? message;

  LoadingEffect(this.show, {this.message});
}

/// Standard Effect for navigating to a new target reactively.
class NavigationEffect extends BaseEffect {
  /// The navigation target (Route path or Object). Can be null for back operations.
  final dynamic target;
  final bool isReplace;
  final bool isBack;
  final Object? arguments;
  final bool needLogin;

  NavigationEffect({
    this.target,
    this.isReplace = false,
    this.isBack = false,
    this.arguments,
    this.needLogin = false,
  });

  /// Helper constructor for back navigation.
  factory NavigationEffect.back({Object? result}) => NavigationEffect(isBack: true, arguments: result);
}
