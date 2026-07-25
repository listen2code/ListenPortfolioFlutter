
import '../shared.dart';

/// Effect to toggle the visibility of the log overlay.
class LogOverlayEffect extends BaseEffect {
  final bool show;
  LogOverlayEffect(this.show);
}

/// Provider to handle [LogOverlayEffect].
class LogOverlayProviderImpl extends BaseProvider<LogOverlayEffect> {
  const LogOverlayProviderImpl();

  @override
  void handleEffect(LogOverlayEffect effect) {
    final context = AppNavConfig.context;
    if (context != null) {
      if (effect.show) {
        LogOverlayManager.show(context);
      } else {
        LogOverlayManager.hide();
      }
    }
  }
}
