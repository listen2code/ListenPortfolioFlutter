import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';
import '../../../../../shared/shared.dart';

part 'appearance_state.freezed.dart';

@freezed
abstract class AppearanceState extends BaseState with _$AppearanceState {
  const factory AppearanceState({
    required ThemeMode themeMode,
    required Color accentColor,
    required AppFontSize fontSize,
    required bool useDynamicColor,
  }) = _AppearanceState;
  const AppearanceState._();
}
