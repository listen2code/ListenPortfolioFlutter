import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';
import '../../../../shared/utils/playback_observer_manager.dart';
import 'home_state.dart';

part 'home_intent.freezed.dart';

@freezed
class HomeIntent extends BaseIntent with _$HomeIntent {
  const factory HomeIntent.tabChanged(HomeTab tab, {@Default(false) bool closeDrawer}) = _TabChanged;
  const factory HomeIntent.logout() = _Logout;
  const factory HomeIntent.toSettings() = _ToSettings;
  const factory HomeIntent.toAppearance() = _ToAppearance;

  const HomeIntent._();

  /// Registers deserializers for MVI playback.
  static void registerPlayback() {
    MviPlaybackRegistry.register('HomeIntent', 'tabChanged', (args) {
      final tabStr = args['tab'] ?? '';
      final tab = HomeTab.values.firstWhere(
        (e) => e.toString().split('.').last == tabStr || 
               e.toString() == tabStr || 
               e.toString().split('.').last == tabStr.split('.').last,
        orElse: () => HomeTab.overview,
      );
      final closeDrawer = args['closeDrawer'] == 'true';
      return HomeIntent.tabChanged(tab, closeDrawer: closeDrawer);
    });
    MviPlaybackRegistry.register('HomeIntent', 'logout', (args) => const HomeIntent.logout());
    MviPlaybackRegistry.register('HomeIntent', 'toSettings', (args) => const HomeIntent.toSettings());
    MviPlaybackRegistry.register('HomeIntent', 'toAppearance', (args) => const HomeIntent.toAppearance());
  }
}
