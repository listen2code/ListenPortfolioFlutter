import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/provider/auth_provider.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_uikit/uikit.dart';

/// A central class to handle all application-wide initializations.
/// This acts as the 'Composition Root' where core interfaces are tied to shared implementations.
class AppInitializer {
  AppInitializer._();

  /// Global container to access providers during the initialization phase if needed.
  static late final ProviderContainer container;

  /// Executes all initialization steps in order.
  static Future<void> init(ProviderContainer container) async {
    AppInitializer.container = container;

    // 1. Initialize Infrastructure & Core Module (Including Nav & Error Hooks)
    await _initCore();
  }

  /// Initializes infrastructure and the centralized ListenCore module.
  static Future<void> _initCore() async {
    WidgetsFlutterBinding.ensureInitialized();

    // 1. Centralized Core Initialization (Encapsulates Storage, Bus, Net, Crash, I18n, Nav, Error)
    await Core.init(
      CoreConfig(
        // Storage Configuration
        storagePrefix: "${AppConstants.appName}_",
        // Configure Global Event Bus logging
        onEventFired: (event) => appLogger.d('EventBus: [FIRE] -> $event'),
        // Inject Core Architecture capability providers
        initialProviders: [
          const LoadingProviderImpl(),
          const MessageProviderImpl(),
          const NavigationProviderImpl(),
          const LogoutProviderImpl(),
        ],
        // Link Core Network to Shared Auth Logic
        apiDelegate: _ApiAuthHandlerImpl(),
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
      ),
    );

    // 2. Shared Layer Services Initialization
    QuickActionsManager.init();
    settingManager.loadSettings();
    UIKitConfig.setup(stringProvider: (key) => key.tr);
  }
}

/// Private implementation of the API authentication and tracing handler.
class _ApiAuthHandlerImpl implements IApiInterceptorDelegate {
  @override
  Future<bool> onRefreshToken() async {
    try {
      final repository = await AppInitializer.container.read(authRepositoryProvider.future);
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
