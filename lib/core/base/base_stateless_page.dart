import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:listen_portfolio_flutter/core/base/base_listenable_page.dart';
import 'package:listen_portfolio_flutter/core/theme/setting_provider.dart';

/// A common wrapper for pages to provide consistent theme listening,
/// background gradient, and basic layout structure.
class BaseStatelessPage extends StatelessWidget {
  final Widget body;
  final String? title;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Widget? floatingActionButton;
  final bool useSafeArea;
  final bool isScrollable;
  final EdgeInsetsGeometry? padding;
  final bool resizeToAvoidBottomInset;
  final bool extendBodyBehindAppBar;
  final bool useStatusBar;
  final bool useBottomBar;
  final Color statusBarColor;
  final Color bottomBarColor;

  const BaseStatelessPage({
    super.key,
    required this.body,
    this.title,
    this.appBar,
    this.drawer,
    this.floatingActionButton,
    this.useSafeArea = true,
    this.isScrollable = true,
    this.padding,
    this.resizeToAvoidBottomInset = true,
    this.extendBodyBehindAppBar = true,
    this.useStatusBar = false,
    this.useBottomBar = false,
    this.statusBarColor = Colors.transparent,
    this.bottomBarColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return BaseListenablePage(
      builder: (context, child) {
        final theme = Theme.of(context);
        final accentColor = settingManager.accentColor;
        final isDark = theme.brightness == Brightness.dark;

        Widget content = body;

        if (padding != null) {
          content = Padding(padding: padding!, child: content);
        }

        if (isScrollable) {
          content = SingleChildScrollView(physics: const AlwaysScrollableScrollPhysics(), child: content);
        }

        content = Column(
          children: [
            Offstage(offstage: !useStatusBar, child: _createStatusBar(context)),
            Expanded(child: content),
            Offstage(offstage: !useBottomBar, child: _createBottomBar(context)),
          ],
        );

        if (useSafeArea) {
          content = SafeArea(top: !useStatusBar, bottom: !useBottomBar, child: content);
        }

        // Determine which AppBar to use
        PreferredSizeWidget? effectiveAppBar = appBar;
        if (effectiveAppBar == null && title != null) {
          effectiveAppBar = _createAppBar(theme, context);
        }

        // System UI Style configuration for immersive look
        final systemUiOverlayStyle = SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          // Android
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
          // iOS
          systemNavigationBarColor: theme.scaffoldBackgroundColor,
          systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        );

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: systemUiOverlayStyle,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard on tap
            behavior: HitTestBehavior.translucent,
            child: Scaffold(
              appBar: effectiveAppBar,
              drawer: drawer,
              floatingActionButton: floatingActionButton,
              resizeToAvoidBottomInset: resizeToAvoidBottomInset,
              extendBodyBehindAppBar: extendBodyBehindAppBar,
              body: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [accentColor.withValues(alpha: 0.05), theme.scaffoldBackgroundColor],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: content,
              ),
            ),
          ),
        );
      },
    );
  }

  AppBar _createAppBar(ThemeData theme, BuildContext context) {
    return AppBar(
      title: Text(title!, style: const TextStyle(fontWeight: FontWeight.w300)),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: theme.brightness == Brightness.light ? Colors.black87 : Colors.white,
    );
  }

  Widget _createStatusBar(BuildContext context) {
    return Builder(
      builder: (context) {
        return Container(color: statusBarColor, height: MediaQuery.of(context).padding.top);
      },
    );
  }

  Widget _createBottomBar(BuildContext context) {
    return Builder(
      builder: (context) {
        return Container(color: bottomBarColor, height: MediaQuery.of(context).padding.bottom);
      },
    );
  }
}
