import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';
import '../../../../shared/services/referrer/install_referrer_data.dart';
import '../../../../shared/utils/playback_registry_init.dart';
import 'home_state.dart';

part 'home_intent.freezed.dart';

@freezed
class HomeIntent extends BaseIntent with _$HomeIntent {
  const factory HomeIntent.tabChanged(
    HomeTab tab, {
    String? targetProjectBusinessId,
    @Default(false) bool closeDrawer,
  }) = _TabChanged;
  const factory HomeIntent.logout() = _Logout;
  const factory HomeIntent.confirmLogout() = _ConfirmLogout;
  const factory HomeIntent.toSettings() = _ToSettings;
  const factory HomeIntent.toAppearance() = _ToAppearance;
  const factory HomeIntent.handleDeepLink(Uri uri) = _HandleDeepLink;
  const factory HomeIntent.init() = _Init;
  const factory HomeIntent.previewAvatar() = _PreviewAvatar;
  const factory HomeIntent.checkDeferredDeepLink() = _CheckDeferredDeepLink;
  const factory HomeIntent.handleDeferredDeepLink(InstallReferrerData data) = _HandleDeferredDeepLink;

  const HomeIntent._();

  /// Registers deserializers for MVI playback.
  static void registerPlayback() {
    MviPlaybackRegistry.register('HomeIntent', 'tabChanged', (args) {
      final tabStr = args['tab'] ?? '';
      final tab = HomeTab.values.firstWhere(
        (e) =>
            e.toString().split('.').last == tabStr ||
            e.toString() == tabStr ||
            e.toString().split('.').last == tabStr.split('.').last,
        orElse: () => HomeTab.overview,
      );
      final closeDrawer = args['closeDrawer'] == 'true';
      final targetProjectBusinessId = args['targetProjectBusinessId'];
      return HomeIntent.tabChanged(
        tab,
        targetProjectBusinessId: targetProjectBusinessId,
        closeDrawer: closeDrawer,
      );
    });
    MviPlaybackRegistry.register('HomeIntent', 'logout', (args) => const HomeIntent.logout());
    MviPlaybackRegistry.register('HomeIntent', 'confirmLogout', (args) => const HomeIntent.confirmLogout());
    MviPlaybackRegistry.register('HomeIntent', 'toSettings', (args) => const HomeIntent.toSettings());
    MviPlaybackRegistry.register('HomeIntent', 'toAppearance', (args) => const HomeIntent.toAppearance());
    MviPlaybackRegistry.register('HomeIntent', 'handleDeepLink', (args) {
      final uriStr = args['uri'] ?? '';
      return HomeIntent.handleDeepLink(Uri.parse(uriStr));
    });
    MviPlaybackRegistry.register('HomeIntent', 'init', (args) => const HomeIntent.init());
    MviPlaybackRegistry.register('HomeIntent', 'previewAvatar', (args) => const HomeIntent.previewAvatar());
    MviPlaybackRegistry.register(
      'HomeIntent',
      'checkDeferredDeepLink',
      (args) => const HomeIntent.checkDeferredDeepLink(),
    );
    MviPlaybackRegistry.register('HomeIntent', 'handleDeferredDeepLink', (args) {
      final raw = args['raw'] ?? '';
      return HomeIntent.handleDeferredDeepLink(InstallReferrerData.fromRawReferrer(raw));
    });
  }
}
