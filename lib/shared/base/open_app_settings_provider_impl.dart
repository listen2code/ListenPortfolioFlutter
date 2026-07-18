import 'package:listen_core/core.dart';
import 'package:permission_handler/permission_handler.dart';

/// Single-use UI side-effect to open system settings for this app.
class OpenAppSettingsEffect extends BaseEffect {
  OpenAppSettingsEffect();

  @override
  String toString() => 'OpenAppSettingsEffect()';
}

/// Concrete provider implementation that launches system application settings.
class OpenAppSettingsProviderImpl extends BaseProvider<OpenAppSettingsEffect> {
  const OpenAppSettingsProviderImpl();

  @override
  void handleEffect(OpenAppSettingsEffect effect) async {
    await openAppSettings();
  }
}
