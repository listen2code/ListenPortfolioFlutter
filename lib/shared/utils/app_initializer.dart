import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/provider/auth_provider.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_uikit/uikit.dart';

import '../services/iap/iap_service_impl.dart';
import '../services/review/review_service.dart';

/// A central class to handle all application-wide initializations.
/// This acts as the 'Composition Root' where core interfaces are tied to shared implementations.
class AppInitializer {
  AppInitializer._();

  /// Executes all initialization steps in order.
  /// [container] is the Riverpod container to be used for dependency resolution.
  static Future<void> init(ProviderContainer container) async {
    // 1. Initialize Infrastructure & Core Module (Including Nav & Error Hooks)
    await _initCore(container);
  }

  /// Initializes infrastructure and the centralized ListenCore module.
  static Future<void> _initCore(ProviderContainer container) async {
    WidgetsFlutterBinding.ensureInitialized();

    // 1. Centralized Core Initialization (Encapsulates Storage, Bus, Net, Crash, I18n, Nav, Error)
    await Core.init(
      CoreConfig(
        // Storage Configuration
        storagePrefix: "${AppConstants.appName}_",
        // Inject Core Architecture capability providers
        initialProviders: [
          const LoadingProviderImpl(),
          const MessageProviderImpl(),
          const NavigationProviderImpl(),
          const LaunchUrlProviderImpl(),
          const LogoutProviderImpl(),
          const ShareProviderImpl(),
          const CoffeePurchaseProviderImpl(),
          const SwitchDialogProviderImpl(),
          const ConfirmProviderImpl(),
          const LogOverlayProviderImpl(),
          const RateAppProviderImpl(),
          const ShowLicensesProviderImpl(),
          const ColorPickerProviderImpl(),
          const PrintPdfProviderImpl(),
        ],
        // Link Core Network to Shared Auth Logic with injected container
        apiDelegate: _ApiAuthHandlerImpl(container),
        // Configure Crash Protection (Safe Mode)
        safeModeConfig: SafeModeConfig(
          onReset: () async {
            await settingManager.resetSettings();
            AppNav.offAll(Routes.home);
            CommonToast.show(I18nKeys.safetyResetMsg.tr, type: ToastType.error);
          },
        ),
        // Pass Environment configurations
        envConfigs: EnvConfigs.values,
        // Localization Configuration
        i18nData: {AppLanguage.chinese.locale.languageCode: zh, AppLanguage.japanese.locale.languageCode: ja},
        languageCodeProvider: () => settingManager.locale.languageCode,
        // Navigation & Auth Interception Logic
        routes: Routes.routes,
        isGuestCheck: () => authManager.state.isGuest,
        onLoginRedirect: (context) async {
          final result = await AppNav.to(Routes.login);
          return result == true;
        },
        onLoginSuccessCallback: () => CommonToast.show(I18nKeys.loginSuccess.tr),
        onShowLoginDialogCallback: (context) async {
          final result = await CommonDialog.showConfirm(
            title: I18nKeys.loginLink.tr,
            message: I18nKeys.signInToContinue.tr,
          );
          return result == true;
        },
        networkConfig: NetworkConfig(
          visitorPaths: [
            '/v1/auth/signUp',
            '/v1/auth/login',
            '/v1/auth/forgot-password',
            '/v1/auth/refresh',
            '/v1/projects',
          ],
        ),
      ),
    );

    // 2. Shared Layer Services Initialization
    QuickActionsManager.init();
    settingManager.loadSettings();
    UIKitConfig.init(stringProvider: (key) => key.tr);
    ReviewService().logAppLaunch();

    // 3. Initialize push notification service & configure deep link routing listeners
    // Run push notification initialization asynchronously so slow/blocked
    // network or platform behaviors in release (Play signing, network latency,
    // permission dialogs) won't delay or clutter app startup. Errors and
    // timing will still be logged for diagnosis.
    Future<void>.microtask(() async {
      final start = DateTime.now();
      try {
        await notificationService.initialize().timeout(const Duration(seconds: 30));
        final dur = DateTime.now().difference(start);
        appLogger.i('AppInitializer: notificationService.initialize completed in ${dur.inMilliseconds}ms');
      } on TimeoutException catch (e, stackTrace) {
        appLogger.e(
          'AppInitializer: Push notification initialization timed out after 30s.',
          error: e,
          stackTrace: stackTrace,
        );
      } catch (e, stackTrace) {
        appLogger.e(
          'AppInitializer: Push notification initialization failed.',
          error: e,
          stackTrace: stackTrace,
        );
      }
    });

    // 4. Initialize in-app purchase service
    try {
      iapService = IapServiceImpl();
      await iapService.initialize();
    } catch (e, stackTrace) {
      appLogger.e('AppInitializer: In-App Purchase initialization failed.', error: e, stackTrace: stackTrace);
    }
  }
}

/// Private implementation of the API authentication and tracing handler.
class _ApiAuthHandlerImpl implements IApiInterceptorDelegate {
  final ProviderContainer container;

  _ApiAuthHandlerImpl(this.container);

  @override
  Future<bool> onRefreshToken() async {
    try {
      // Use the local container reference instead of a static one.
      final repository = await container.read(authRepositoryProvider.future);
      final result = await repository.refreshToken();
      return result.isRight();
    } catch (e) {
      appLogger.e('AppInitializer: Failed to bridge token refresh: $e');
      return false;
    }
  }

  @override
  Future<void> onInjectAuthHeader(RequestOptions options) async {
    final token = await SecureStorageUtil.get(AppConstants.authTokenKey);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
  }

  @override
  void onInjectTraceHeader(RequestOptions options, String traceId) {
    options.headers['X-Trace-Id'] = traceId;
  }
}
