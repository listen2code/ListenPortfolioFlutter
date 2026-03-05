import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_portfolio_flutter/core/core.dart';

part 'architecture_state.freezed.dart';

@freezed
abstract class ArchitectureState extends BaseState with _$ArchitectureState {
  const factory ArchitectureState({@Default(false) bool isInitialLoaded}) = _ArchitectureState;

  const ArchitectureState._();
}
