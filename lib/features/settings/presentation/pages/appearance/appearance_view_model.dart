import 'dart:async';

import 'package:flutter/material.dart';
import '../../../../../shared/shared.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'appearance_intent.dart';
import 'appearance_state.dart';

part 'appearance_view_model.g.dart';

@riverpod
class AppearanceViewModel extends _$AppearanceViewModel
    with ViewModelMixin<AppearanceState, AppearanceIntent> {
  @override
  AppearanceState build() {
    return AppearanceState(
      themeMode: settingManager.themeMode,
      accentColor: settingManager.accentColor,
      fontSize: settingManager.fontSize,
      fontFamily: settingManager.fontFamily,
      useDynamicColor: settingManager.useDynamicColor,
    );
  }

  @override
  FutureOr<void> onIntent(AppearanceIntent intent) {
    return intent.when<FutureOr<void>>(
      setThemeMode: _onSetThemeMode,
      setAccentColor: _onSetAccentColor,
      setFontSize: _onSetFontSize,
      setFontFamily: _onSetFontFamily,
      setUseDynamicColor: _onSetUseDynamicColor,
      showColorPicker: _onShowColorPicker,
    );
  }

  Future<void> _onSetThemeMode(ThemeMode mode) async {
    updateState(state.copyWith(themeMode: mode));
    await settingManager.setThemeMode(mode);
  }

  Future<void> _onSetAccentColor(Color color) async {
    updateState(state.copyWith(accentColor: color));
    await settingManager.setAccentColor(color);
  }

  Future<void> _onSetFontSize(AppFontSize size) async {
    updateState(state.copyWith(fontSize: size));
    await settingManager.setFontSize(size);
  }

  Future<void> _onSetFontFamily(AppFontFamily family) async {
    updateState(state.copyWith(fontFamily: family));
    await settingManager.setFontFamily(family);
  }

  Future<void> _onSetUseDynamicColor(bool use) async {
    updateState(state.copyWith(useDynamicColor: use));
    await settingManager.setUseDynamicColor(use);
  }

  void _onShowColorPicker(Color initialColor) {
    emitEffect(
      ColorPickerEffect(
        initialColor: initialColor,
        onColorSelected: (color) {
          handleIntent(AppearanceIntent.setAccentColor(color));
        },
      ),
    );
  }
}
