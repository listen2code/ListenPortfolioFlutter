/// Interface for UI Side Effects (Toast, Navigation, etc.) that occur once.
abstract class BaseEffect {}

/// Message type for NotificationEffect
enum MessageType { info, error }

/// Standard Effect for showing messages/toasts.
class MessageEffect extends BaseEffect {
  final String message;
  final MessageType type;

  MessageEffect(this.message, {this.type = MessageType.info});

  /// Factory for error messages
  factory MessageEffect.error(String message) => MessageEffect(message, type: MessageType.error);

  @override
  String toString() {
    return "MessageEffect(message: $message, type: $type)";
  }
}

/// Standard Effect for controlling global loading state.
class LoadingEffect extends BaseEffect {
  final bool show;
  final String? message;

  LoadingEffect(this.show, {this.message});

  @override
  String toString() {
    return "LoadingEffect(show: $show, message: $message)";
  }
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

  @override
  String toString() {
    return "NavigationEffect(target: $target, isReplace: $isReplace, isBack: $isBack, needLogin: $needLogin, arguments: $arguments";
  }
}
