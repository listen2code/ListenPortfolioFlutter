import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';
import '../../../../../shared/shared.dart';

part 'appearance_intent.freezed.dart';

@freezed
class AppearanceIntent extends BaseIntent with _$AppearanceIntent {
  const factory AppearanceIntent.setThemeMode(ThemeMode mode) = _SetThemeMode;
  const factory AppearanceIntent.setAccentColor(Color color) = _SetAccentColor;
  const factory AppearanceIntent.setFontSize(AppFontSize size) = _SetFontSize;
  const factory AppearanceIntent.setUseDynamicColor(bool use) = _SetUseDynamicColor;
  const AppearanceIntent._();
}
