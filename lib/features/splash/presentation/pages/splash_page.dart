import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import '../../../../generated/r.dart';
import '../../../../shared/shared.dart';

import 'splash_state.dart';
import 'splash_view_model.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseRefreshPage<SplashViewModel, SplashState>(
      provider: splashViewModelProvider,
      // No scaffold for splash to allow full-screen branding
      useScaffold: false,
      // Handle UI-related lifecycle logic via the new parameter
      lifecycle: _SplashLifecycle(context),
      body: (context, child, viewModel, state) {
        final accentColor = context.accentColor;

        return Scaffold(
          backgroundColor: context.theme.scaffoldBackgroundColor,
          body: Center(
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
                    tag: 'logo',
                    child: Image.asset(
                      R.imagesIcLauncherAdaptiveFore,
                      width: 120,
                      height: 120,
                      color: accentColor,
                      colorBlendMode: BlendMode.srcIn,
                      semanticLabel: I18nKeys.appLogoSemanticLabel.tr,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    AppConstants.appName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w300,
                      color: accentColor,
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
    // Initialize Log Overlay when the page is fully ready
    LogOverlayManager.init(context);
  }
}
