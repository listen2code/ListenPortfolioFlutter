import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_portfolio_flutter/core/base/base_view_model.dart';
import 'package:listen_portfolio_flutter/core/extension/widget_ref_extension.dart';
import 'package:listen_portfolio_flutter/core/route/app_nav.dart';
import 'package:listen_portfolio_flutter/shared/base/base_listenable_page.dart';
import 'package:listen_portfolio_flutter/shared/theme/setting_provider.dart';
import 'package:listen_portfolio_flutter/uikit/uikit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// A professional, unified page wrapper that handles UI structure,
/// theme listening, complete lifecycle management, and automatic state listening.
class BasePage extends ConsumerStatefulWidget {
  final TransitionBuilder body;
  final String? title;
  final List<Widget>? actions; // Added actions parameter
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

  const BasePage({
    super.key,
    required this.body,
    this.title,
    this.actions, // Initialize actions
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
  ConsumerState<BasePage> createState() => _BaseStatelessPageState();
}

class _BaseStatelessPageState extends ConsumerState<BasePage> with RouteAware, WidgetsBindingObserver {
  bool _isRouteVisible = false;
  BaseViewModel? _viewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Store ViewModel reference and trigger onInit
    if (widget.provider != null) {
      try {
        _viewModel = ref.read((widget.provider as dynamic).notifier);
      } catch (_) {}
    }

    _viewModel?.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _viewModel?.onReady();
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
  void didUpdateWidget(BasePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.active != widget.active) {
      _checkVisibilityChange(widget.active);
    }
  }

  @override
  void dispose() {
    AppNav.observer.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    _viewModel?.onDispose();
    super.dispose();
  }

  void _checkVisibilityChange(bool isVisible) {
    if (isVisible) {
      _viewModel?.onVisible();
    } else {
      _viewModel?.onInVisible();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_isRouteVisible || !widget.active) return;

    if (state == AppLifecycleState.resumed) {
      _viewModel?.onVisible();
    } else if (state == AppLifecycleState.paused) {
      _viewModel?.onInVisible();
    }
  }

  @override
  void didPush() => _isRouteVisible = true;

  @override
  void didPopNext() {
    _isRouteVisible = true;
    if (widget.active) _viewModel?.onVisible();
  }

  @override
  void didPushNext() {
    _isRouteVisible = false;
    if (widget.active) _viewModel?.onInVisible();
  }

  @override
  void didPop() {
    _isRouteVisible = false;
    if (widget.active) _viewModel?.onInVisible();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.provider != null) {
      ref.listenError(widget.provider!);
      ref.listenMessage(widget.provider!);
    }

    return BaseListenablePage(
      extraListenable: [CommonLoading.isShowNotifier],
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

        final scaffoldWidget = Scaffold(
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
        );

        final systemUiOverlayStyle = SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
          systemNavigationBarColor: theme.scaffoldBackgroundColor,
          systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        );

        return PopScope(
          canPop: !CommonLoading.isShow,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            _viewModel?.cancelRequests("on Pop");
            CommonLoading.hide();
          },
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: systemUiOverlayStyle,
            child: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              behavior: HitTestBehavior.translucent,
              child: scaffoldWidget,
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
      actions: widget.actions,
      // Use the actions here
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
