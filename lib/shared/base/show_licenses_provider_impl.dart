import 'package:flutter/material.dart';
import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';

import '../../generated/r.dart';
import '../shared.dart';

/// Effect to show the licenses page.
class ShowLicensesEffect extends BaseEffect {
  ShowLicensesEffect();
}

/// Provider to handle [ShowLicensesEffect].
class ShowLicensesProviderImpl extends BaseProvider<ShowLicensesEffect> {
  const ShowLicensesProviderImpl();

  @override
  void handleEffect(ShowLicensesEffect effect) {
    final context = AppNavConfig.context;
    if (context != null) {
      showLicensePage(
        context: context,
        applicationName: AppConstants.appName,
        applicationVersion: AppConstants.appVersion,
        applicationIcon: Padding(
          padding: EdgeInsets.all(8.f),
          child: CommonImage.asset(
            R.imagesIcLauncherAdaptiveFore,
            width: 48.f,
            height: 48.f,
            color: context.accentColor,
            semanticLabel: I18nKeys.appLogoSemanticLabel.tr,
          ),
        ),
        applicationLegalese: '© ${AppConstants.date} ${AppConstants.author}',
      );
    }
  }
}
