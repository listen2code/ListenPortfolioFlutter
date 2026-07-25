import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../shared/shared.dart';
import 'appearance_intent.dart';
import 'appearance_state.dart';
import 'appearance_view_model.dart';
import 'widgets/accent_color_grid.dart';
import 'widgets/font_size_option_tile.dart';
import 'widgets/theme_option_tile.dart';

class AppearancePage extends ConsumerWidget {
  const AppearancePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseRefreshPage<AppearanceViewModel, AppearanceState>(
      title: I18nKeys.appearance.tr,
      provider: appearanceViewModelProvider,
      padding: const EdgeInsets.all(20),
      body: (context, child, viewModel, state) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonSettingsSectionTitle(title: I18nKeys.themeMode.tr),
              CommonSettingsCard(children: [
                ThemeOptionTile(
                  label: I18nKeys.system.tr,
                  icon: Icons.settings_brightness_outlined,
                  mode: ThemeMode.system,
                  currentThemeMode: state.themeMode,
                  onTap: () => viewModel.handleIntent(const AppearanceIntent.setThemeMode(ThemeMode.system)),
                ),
                ThemeOptionTile(
                  label: I18nKeys.light.tr,
                  icon: Icons.light_mode_outlined,
                  mode: ThemeMode.light,
                  currentThemeMode: state.themeMode,
                  onTap: () => viewModel.handleIntent(const AppearanceIntent.setThemeMode(ThemeMode.light)),
                ),
                ThemeOptionTile(
                  label: I18nKeys.dark.tr,
                  icon: Icons.dark_mode_outlined,
                  mode: ThemeMode.dark,
                  currentThemeMode: state.themeMode,
                  onTap: () => viewModel.handleIntent(const AppearanceIntent.setThemeMode(ThemeMode.dark)),
                ),
              ]),
              const SizedBox(height: 25),
              CommonSettingsSectionTitle(title: I18nKeys.accentColor.tr),
              CommonSettingsCard(children: [
                if (defaultTargetPlatform == TargetPlatform.android)
                  SwitchListTile(
                    value: state.useDynamicColor,
                    onChanged: (value) {
                      viewModel.handleIntent(AppearanceIntent.setUseDynamicColor(value));
                    },
                    title: CommonText(I18nKeys.dynamicColor.tr),
                    subtitle: CommonText(I18nKeys.dynamicColorSubtitle.tr),
                    secondary: SizedBox(
                      width: 20,
                      child: Icon(
                        Icons.color_lens_outlined,
                        color: state.useDynamicColor ? context.accentColor : Colors.grey,
                      ),
                    ),
                    activeThumbColor: context.accentColor,
                  ),
                AccentColorGrid(
                  currentAccentColor: state.accentColor,
                  useDynamicColor: state.useDynamicColor,
                  onSelectedColor: (color) => viewModel.handleIntent(AppearanceIntent.setAccentColor(color)),
                  onShowColorPicker: () => viewModel.handleIntent(AppearanceIntent.showColorPicker(state.accentColor)),
                ),
              ]),
              const SizedBox(height: 25),
              CommonSettingsSectionTitle(title: I18nKeys.fontSize.tr),
              CommonSettingsCard(children: [
                FontSizeOptionTile(
                  label: I18nKeys.standard.tr,
                  fontSize: AppFontSize.standard,
                  currentFontSize: state.fontSize,
                  onTap: () => viewModel.handleIntent(const AppearanceIntent.setFontSize(AppFontSize.standard)),
                ),
                FontSizeOptionTile(
                  label: I18nKeys.large.tr,
                  fontSize: AppFontSize.large,
                  currentFontSize: state.fontSize,
                  onTap: () => viewModel.handleIntent(const AppearanceIntent.setFontSize(AppFontSize.large)),
                ),
              ]),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }
}
