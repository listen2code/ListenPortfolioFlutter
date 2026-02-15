import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:listen_portfolio_flutter/core/base/base_listenable_page.dart';
import 'package:listen_portfolio_flutter/core/base/base_view_model.dart';
import 'package:listen_portfolio_flutter/core/theme/setting_provider.dart';
import 'package:listen_portfolio_flutter/main.dart';
import 'package:listen_portfolio_flutter/shared/widgets/common_text.dart';

/// A common wrapper for pages providing professional lifecycle management.
/// Lifecycle events are automatically dispatched to the provided [viewModel].
class BaseStatelessPage extends StatefulWidget {
  final TransitionBuilder body;
  final String? title;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Widget? floatingActionButton;
  final bool useSafeArea;
  final EdgeInsetsGeometry? padding;
  final bool resizeToAvoidBottomInset;
  final bool extendBodyBehindAppBar;
  final bool useStatusBar;
  final bool useBottomBar;
  final bool isEmptyTitle;
  final Color statusBarColor;
  final Color bottomBarColor;

  /// Manual control for visibility (e.g. for TabBarView or IndexedStack)
  final bool active;

  /// The ViewModel associated with this page to handle lifecycle events.
  final BaseViewModel? viewModel;

  const BaseStatelessPage({
    super.key,
    required this.body,
    this.title,
    this.appBar,
    this.drawer,
    this.floatingActionButton,
    this.useSafeArea = true,
    this.padding,
    this.resizeToAvoidBottomInset = true,
    this.extendBodyBehindAppBar = true,
    this.useStatusBar = false,
    this.useBottomBar = false,
    this.isEmptyTitle = false,
    this.statusBarColor = Colors.transparent,
    this.bottomBarColor = Colors.transparent,
    this.active = true,
    this.viewModel,
  });

  @override
  State<BaseStatelessPage> createState() => _BaseStatelessPageState();
}

class _BaseStatelessPageState extends State<BaseStatelessPage> with RouteAware, WidgetsBindingObserver {
  bool _isRouteVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Dispatch onInit to ViewModel
    widget.viewModel?.onInit();

    // Fire onReady and initial onVisible after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.viewModel?.onReady();
        if (widget.active) _checkVisibilityChange(true);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void didUpdateWidget(BaseStatelessPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.active != widget.active) {
      _checkVisibilityChange(widget.active);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);

    // Dispatch onDispose to ViewModel
    widget.viewModel?.onDispose();
    super.dispose();
  }

  void _checkVisibilityChange(bool isVisible) {
    if (isVisible) {
      widget.viewModel?.onVisible();
    } else {
      widget.viewModel?.onInVisible();
    }
  }

  // --- App Lifecycle (Handle background/foreground) ---
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_isRouteVisible || !widget.active) return;

    if (state == AppLifecycleState.resumed) {
      widget.viewModel?.onVisible();
    } else if (state == AppLifecycleState.paused) {
      widget.viewModel?.onInVisible();
    }
  }

  // --- Route Lifecycle (Handle navigation) ---
  @override
  void didPush() {
    _isRouteVisible = true;
  }

  @override
  void didPopNext() {
    _isRouteVisible = true;
    if (widget.active) widget.viewModel?.onVisible();
  }

  @override
  void didPushNext() {
    _isRouteVisible = false;
    if (widget.active) widget.viewModel?.onInVisible();
  }

  @override
  void didPop() {
    _isRouteVisible = false;
    if (widget.active) widget.viewModel?.onInVisible();
  }

  @override
  Widget build(BuildContext context) {
    return BaseListenablePage(
      builder: (context, child) {
        final theme = Theme.of(context);
        final accentColor = settingManager.accentColor;
        final isDark = theme.brightness == Brightness.dark;

        Widget content = widget.body(context, child);

        if (widget.padding != null) {
          content = Padding(padding: widget.padding!, child: content);
        }

        content = Column(
          children: [
            Offstage(offstage: !widget.useStatusBar, child: _createStatusBar()),
            Expanded(child: content),
            Offstage(offstage: !widget.useBottomBar, child: _createBottomBar()),
          ],
        );

        if (widget.useSafeArea) {
          content = SafeArea(top: !widget.useStatusBar, bottom: !widget.useBottomBar, child: content);
        }

        PreferredSizeWidget? effectiveAppBar = widget.appBar;
        if (effectiveAppBar == null && (widget.title != null || widget.isEmptyTitle)) {
          effectiveAppBar = _createAppBar(theme);
        }

        final systemUiOverlayStyle = SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
          systemNavigationBarColor: theme.scaffoldBackgroundColor,
          systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        );

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: systemUiOverlayStyle,
          child: GestureDetector(
            onTap: () {
              // Clear global focus to dismiss keyboard and reset focus state
              FocusManager.instance.primaryFocus?.unfocus();
            },
            behavior: HitTestBehavior.translucent,
            child: Scaffold(
              appBar: effectiveAppBar,
              drawer: widget.drawer,
              floatingActionButton: widget.floatingActionButton,
              resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
              extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
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

  AppBar _createAppBar(ThemeData theme) {
    return AppBar(
      title: CommonText(widget.title ?? "", style: const TextStyle(fontWeight: FontWeight.w300)),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: theme.brightness == Brightness.light ? Colors.black87 : Colors.white,
    );
  }

  Widget _createStatusBar() =>
      Container(color: widget.statusBarColor, height: MediaQuery.of(context).padding.top);

  Widget _createBottomBar() =>
      Container(color: widget.bottomBarColor, height: MediaQuery.of(context).padding.bottom);
}
