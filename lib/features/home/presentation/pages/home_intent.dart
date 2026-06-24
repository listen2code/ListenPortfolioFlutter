import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';
import 'home_state.dart';

part 'home_intent.freezed.dart';

@freezed
class HomeIntent extends BaseIntent with _$HomeIntent {
  const factory HomeIntent.tabChanged(HomeTab tab) = _TabChanged;
  const factory HomeIntent.logout() = _Logout;
  const factory HomeIntent.toSettings() = _ToSettings;
  const factory HomeIntent.toAppearance() = _ToAppearance;

  const HomeIntent._();
}
