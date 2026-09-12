import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../../shared/shared.dart';

part 'appearance_state.freezed.dart';

/// ============================================================================
/// AppearanceState
/// ============================================================================
/// Immutable UI state model for the Appearance settings screen.
///
/// Encapsulates user appearance preferences, including active [themeMode],
/// [accentColor], typography [fontSize], [fontFamily], and [useDynamicColor].
@freezed
abstract class AppearanceState extends BaseState with _$AppearanceState {
  const factory AppearanceState({
    required ThemeMode themeMode,
    required Color accentColor,
    required AppFontSize fontSize,
    required AppFontFamily fontFamily,
    required bool useDynamicColor,
  }) = _AppearanceState;
  const AppearanceState._();
}
