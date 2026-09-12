import 'package:flutter/material.dart';
import 'package:listen_core/core.dart';

import '../services/referrer/install_referrer_data.dart';
import '../services/referrer/install_referrer_service.dart';
import '../widgets/dialogs/referral_welcome_dialog.dart';

/// MVI side effect emitted by [HomeViewModel] to request the presentation
/// of the personalized onboarding / deferred deep link welcome dialog.
///
/// Encapsulates parsed [InstallReferrerData] and the callback [onConfirm]
/// invoked when the user proceeds past the dialog.
class ReferralWelcomeEffect extends BaseEffect {
  /// The parsed referral data containing refer identification, UTM parameters, and target route.
  final InstallReferrerData data;

  /// Callback invoked when the user confirms the welcome modal, providing the state
  /// of the "Don't show again" checkbox.
  final void Function(bool doNotShowAgain)? onConfirm;

  ReferralWelcomeEffect({
    required this.data,
    this.onConfirm,
  });
}

/// Provider implementation for handling [ReferralWelcomeEffect].
///
/// ### Architecture & Clean MVI Separation:
/// In accordance with Clean Architecture and MVI principles, ViewModels do not
/// hold references to [BuildContext]. Instead, [HomeViewModel] emits
/// [ReferralWelcomeEffect]. This provider intercepts the effect and uses
/// [AppNavConfig.context] to display the [ReferralWelcomeDialog] on the current navigator stack.
class ReferralWelcomeProviderImpl extends BaseProvider<ReferralWelcomeEffect> {
  /// Optional hook for testing effect dispatching in automated unit and widget tests.
  static void Function(ReferralWelcomeEffect)? onEffectReceived;

  const ReferralWelcomeProviderImpl();

  @override
  void handleEffect(ReferralWelcomeEffect effect) {
    appLogger.i('[${IInstallReferrerService.tag}] Handling ReferralWelcomeEffect -> displaySource: "${effect.data.displaySource}", targetRoute: "${effect.data.targetRoute}"');
    onEffectReceived?.call(effect);
    final context = AppNavConfig.context;
    if (context != null) {
      appLogger.d('[${IInstallReferrerService.tag}] Showing ReferralWelcomeDialog on current context.');
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (ctx) => ReferralWelcomeDialog(
          data: effect.data,
          onConfirm: effect.onConfirm,
        ),
      );
    } else {
      appLogger.w('[${IInstallReferrerService.tag}] AppNavConfig.context is null, cannot present ReferralWelcomeDialog.');
    }
  }
}
