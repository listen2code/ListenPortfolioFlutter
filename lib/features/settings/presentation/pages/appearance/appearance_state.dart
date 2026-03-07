import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';

part 'appearance_state.freezed.dart';

@freezed
abstract class AppearanceState extends BaseState with _$AppearanceState {
  const factory AppearanceState({
    required ThemeMode themeMode,
    required Color accentColor,
    required AppFontSize fontSize,
  }) = _AppearanceState;
  const AppearanceState._();
}
