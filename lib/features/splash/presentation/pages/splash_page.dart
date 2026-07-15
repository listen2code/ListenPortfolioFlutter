import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';
import '../../../../generated/r.dart';
import '../../../../shared/shared.dart';

import 'splash_state.dart';
import 'splash_view_model.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  static const String logo = 'logo';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseRefreshPage<SplashViewModel, SplashState>(
      provider: splashViewModelProvider,
      // No scaffold for splash to allow full-screen branding
      useScaffold: false,
      // Handle UI-related lifecycle logic via the new parameter
      lifecycle: _SplashLifecycle(context),
      body: (context, child, viewModel, state) {
        return Material(
          color: context.theme.scaffoldBackgroundColor,
          child: Center(
            // Use TweenAnimationBuilder to handle fade animation without manually managing AnimationController
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeIn,
              builder: (context, opacity, child) {
                return Opacity(opacity: opacity, child: child);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Hero(
                    tag: SplashPage.logo,
                    child: CommonImage.asset(
                      R.imagesIcLauncherAdaptiveFore,
                      width: 120,
                      height: 120,
                      color: context.accentColor,
                      semanticLabel: I18nKeys.appLogoSemanticLabel.tr,
                    ),
                  ),
                  const SizedBox(height: 24),
                  CommonText(
                    AppConstants.appName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w300,
                      color: context.accentColor,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Dedicated lifecycle observer for UI-level initialization
class _SplashLifecycle extends PageLifecycle {
  final BuildContext context;
  _SplashLifecycle(this.context);

  @override
  void onReady() {
    // Record first frame of the app startup
    LaunchMonitor.recordFirstFrame();
    // Initialize Log Overlay when the page is fully ready
    LogOverlayManager.init(context);
  }
}
