import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_portfolio_flutter/core/core.dart';

part 'overview_state.freezed.dart';

@freezed
abstract class OverviewState extends BaseState with _$OverviewState {
  const factory OverviewState({@Default(false) bool isInitialLoaded}) = _OverviewState;

  const OverviewState._();
}
