import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// A professional, unified page wrapper that handles lifecycle management
/// and ViewModel state listening, delegating UI structure to [BaseScaffoldPage].
class BaseLifeCyclePage extends ConsumerStatefulWidget {
  final TransitionBuilder body;
  final String? title;
  final List<Widget>? actions;
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

  /// Whether to use the gradient background decoration for the Scaffold body.
  final bool useGradientBackground;

  /// Visibility flag for Tab/Page switching inside the same route.
  final bool active;

  /// Whether the page can be popped. If null, it depends on the loading state.
  final bool? canPop;

  /// Custom logic to execute when back is intercepted (e.g., custom confirmation dialogs).
  /// If null, default behavior is to cancel requests and hide loading.
  final VoidCallback? onInterceptBack;

  /// Explicitly provided ViewModel instance. If null, tries to resolve from [provider].
  final BaseViewModel? viewModel;

  /// The Provider to listen for states (errors/messages).
  final ProviderListenable<BaseState<dynamic>>? provider;

  const BaseLifeCyclePage({
    super.key,
    required this.body,
    this.title,
    this.actions,
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
    this.useGradientBackground = true,
    this.active = true,
    this.canPop,
    this.onInterceptBack,
    this.viewModel,
    this.provider,
  });

  @override
  ConsumerState<BaseLifeCyclePage> createState() => _BaseLifeCyclePageState();
}

class _BaseLifeCyclePageState extends ConsumerState<BaseLifeCyclePage> {
  bool _isRouteVisible = false;
  BaseViewModel? _viewModel;

  // Observers moved to dedicated proxy classes for clarity
  late final _RouteAwareProxy _routeObserver;
  late final _AppLifecycleProxy _lifecycleObserver;

  @override
  void initState() {
    super.initState();

    // 1. Resolve ViewModel: Priority given to explicit viewModel, then provider.notifier
    _viewModel = widget.viewModel;
    if (_viewModel == null && widget.provider != null) {
      try {
        _viewModel = ref.read((widget.provider as dynamic).notifier) as BaseViewModel;
      } catch (_) {
        // Error reading provider is ignored
      }
    }

    // Initialize Observers
    _routeObserver = _RouteAwareProxy(
      onVisible: () => _checkVisibilityChange(true),
      onInVisible: () => _checkVisibilityChange(false),
      onPush: () => _isRouteVisible = true,
    );

    _lifecycleObserver = _AppLifecycleProxy(
      onStateChanged: (state) {
        if (!_isRouteVisible || !widget.active) return;

        if (state == AppLifecycleState.resumed) {
          _viewModel?.onResume();
        } else if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
          _viewModel?.onPause();
        }
      },
    );

    WidgetsBinding.instance.addObserver(_lifecycleObserver);

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
      AppNav.observer.subscribe(_routeObserver, route);
    }
  }

  @override
  void didUpdateWidget(BaseLifeCyclePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.active != widget.active) {
      _checkVisibilityChange(widget.active);
    }
  }

  @override
  void dispose() {
    AppNav.observer.unsubscribe(_routeObserver);
    WidgetsBinding.instance.removeObserver(_lifecycleObserver);
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
  Widget build(BuildContext context) {
    if (widget.provider != null) {
      ref.listenError(widget.provider!);
      ref.listenMessage(widget.provider!);
    }

    // Resolve the loading state notifier from the ViewModel's provider
    final isLoadingNotifier = _viewModel?.loadingProvider?.isLoading ?? ValueNotifier<bool>(false);

    return ListenableBuilder(
      listenable: isLoadingNotifier,
      builder: (context, child) {
        // Effective canPop: user's canPop (default true) and not loading
        final effectiveCanPop = (widget.canPop ?? true) && !isLoadingNotifier.value;

        return BaseScaffoldPage(
          title: widget.title,
          actions: widget.actions,
          appBar: widget.appBar,
          drawer: widget.drawer,
          floatingActionButton: widget.floatingActionButton,
          useSafeArea: widget.useSafeArea,
          padding: widget.padding,
          resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
          extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
          useStatusBar: widget.useStatusBar,
          useBottomBar: widget.useBottomBar,
          isEmptyTitle: widget.isEmptyTitle,
          statusBarColor: widget.statusBarColor,
          bottomBarColor: widget.bottomBarColor,
          useGradientBackground: widget.useGradientBackground,
          canPop: effectiveCanPop,
          onBackInvoked: () {
            // Priority given to custom interception logic
            if (widget.onInterceptBack != null) {
              widget.onInterceptBack!();
            } else {
              _viewModel?.cancelRequests("on BackInvoked");
              _viewModel?.loadingProvider?.hide();
            }
          },
          child: widget.body(context, child),
        );
      },
    );
  }
}

/// Dedicated class to handle RouteAware callbacks without polluting the main State class.
class _RouteAwareProxy extends RouteAware {
  final VoidCallback onVisible;
  final VoidCallback onInVisible;
  final VoidCallback onPush;

  _RouteAwareProxy({required this.onVisible, required this.onInVisible, required this.onPush});

  @override
  /// Called when the current route has been pushed.
  void didPush() => onPush();

  @override
  /// Called when the top route has been popped off, and the current route shows up.
  void didPopNext() => onVisible();

  @override
  /// Called when a new route has been pushed, and the current route is no longer visible.
  void didPushNext() => onInVisible();

  @override
  /// Called when the current route has been popped off.
  void didPop() => onInVisible();
}

/// Dedicated class to handle WidgetsBindingObserver callbacks.
class _AppLifecycleProxy extends WidgetsBindingObserver {
  final ValueChanged<AppLifecycleState> onStateChanged;

  _AppLifecycleProxy({required this.onStateChanged});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    onStateChanged(state);
  }
}
