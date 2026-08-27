import 'package:flutter/material.dart';
import 'package:listen_core/core.dart';

import '../services/referrer/install_referrer_data.dart';
import '../widgets/dialogs/referral_welcome_dialog.dart';

/// Side effect for displaying the first-launch deferred deep link welcome dialog.
class ReferralWelcomeEffect extends BaseEffect {
  final InstallReferrerData data;
  final void Function(bool doNotShowAgain)? onConfirm;

  ReferralWelcomeEffect({
    required this.data,
    this.onConfirm,
  });
}

/// Provider implementation for handling [ReferralWelcomeEffect].
class ReferralWelcomeProviderImpl extends BaseProvider<ReferralWelcomeEffect> {
  /// Optional hook for testing effect dispatch.
  static void Function(ReferralWelcomeEffect)? onEffectReceived;

  const ReferralWelcomeProviderImpl();

  @override
  void handleEffect(ReferralWelcomeEffect effect) {
    appLogger.i('ReferralWelcomeProvider: Handling ReferralWelcomeEffect -> displaySource: "${effect.data.displaySource}", targetRoute: "${effect.data.targetRoute}"');
    onEffectReceived?.call(effect);
    final context = AppNavConfig.context;
    if (context != null) {
      appLogger.d('ReferralWelcomeProvider: Showing ReferralWelcomeDialog on current context.');
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (ctx) => ReferralWelcomeDialog(
          data: effect.data,
          onConfirm: effect.onConfirm,
        ),
      );
    } else {
      appLogger.w('ReferralWelcomeProvider: AppNavConfig.context is null, cannot present ReferralWelcomeDialog.');
    }
  }
}
