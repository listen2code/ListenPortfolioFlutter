import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_portfolio_flutter/core/base/base_listenable_page.dart';
import 'package:listen_portfolio_flutter/core/base/base_view_model.dart';
import 'package:listen_portfolio_flutter/core/extension/widget_ref_extension.dart';
import 'package:listen_portfolio_flutter/core/route/app_nav.dart';
import 'package:listen_portfolio_flutter/core/theme/setting_provider.dart';
import 'package:listen_portfolio_flutter/shared/widgets/common_text.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// A professional, unified page wrapper that handles UI structure,
/// theme listening, complete lifecycle management, and automatic state listening.
class BaseStatelessPage extends ConsumerStatefulWidget {
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

  /// Visibility flag for Tab/Page switching inside the same route.
  final bool active;

  /// The Provider to listen for states (errors/messages) and manage lifecycles via its Notifier.
  final ProviderListenable<BaseState<dynamic>>? provider;

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
    this.provider,
  });

  @override
  ConsumerState<BaseStatelessPage> createState() => _BaseStatelessPageState();
}

class _BaseStatelessPageState extends ConsumerState<BaseStatelessPage>
    with RouteAware, WidgetsBindingObserver {
  bool _isRouteVisible = false;
  BaseViewModel? _cachedViewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Store ViewModel reference and trigger onInit
    if (widget.provider != null) {
      try {
        _cachedViewModel = ref.read((widget.provider as dynamic).notifier);
      } catch (_) {}
    }

    _cachedViewModel?.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _cachedViewModel?.onReady();
        if (widget.active) _checkVisibilityChange(true);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      AppNav.observer.subscribe(this, route);
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
    AppNav.observer.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);

    // Trigger onDispose on the cached reference to guarantee execution on page exit
    _cachedViewModel?.onDispose();

    super.dispose();
  }

  void _checkVisibilityChange(bool isVisible) {
    if (isVisible) {
      _cachedViewModel?.onVisible();
    } else {
      _cachedViewModel?.onInVisible();
    }
  }

  // --- App Lifecycle ---
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_isRouteVisible || !widget.active) return;

    if (state == AppLifecycleState.resumed) {
      _cachedViewModel?.onVisible();
    } else if (state == AppLifecycleState.paused) {
      _cachedViewModel?.onInVisible();
    }
  }

  // --- Route Lifecycle ---
  @override
  void didPush() => _isRouteVisible = true;

  @override
  void didPopNext() {
    _isRouteVisible = true;
    if (widget.active) _cachedViewModel?.onVisible();
  }

  @override
  void didPushNext() {
    _isRouteVisible = false;
    if (widget.active) _cachedViewModel?.onInVisible();
  }

  @override
  void didPop() {
    _isRouteVisible = false;
    if (widget.active) _cachedViewModel?.onInVisible();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.provider != null) {
      ref.listenError(widget.provider!);
      ref.listenMessage(widget.provider!);
    }

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
            if (widget.useStatusBar) _createStatusBar(),
            Expanded(child: content),
            if (widget.useBottomBar) _createBottomBar(),
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
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
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
