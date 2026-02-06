import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_portfolio_flutter/core/constants/app_constants.dart';
import 'package:listen_portfolio_flutter/core/theme/theme_provider.dart';
import 'package:listen_portfolio_flutter/features/splash/presentation/pages/splash_page.dart';

import 'core/theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeManager,
      builder: (context, child) {
        return MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.getLightTheme(themeManager.accentColor),
          darkTheme: AppTheme.getDarkTheme(themeManager.accentColor),
          themeMode: themeManager.themeMode,
          home: const SplashPage(),
        );
      },
    );
  }
}
