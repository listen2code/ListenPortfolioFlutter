import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// A custom builder for [BasePage] that provides both the resolved [viewModel] and current [state].
typedef BasePageBodyBuilder<V extends BaseViewModel, S extends BaseState> =
    Widget Function(BuildContext context, Widget? child, V? viewModel, S? state);

/// A shared-layer wrapper for the core [BaseLifeCyclePage].
/// This widget acts as a bridge between business-specific Riverpod providers
/// and the pure core architecture, keeping [BaseLifeCyclePage] independent.
class BasePage<V extends BaseViewModel, S extends BaseState> extends ConsumerWidget {
  /// The builder for the page content, now receiving the [viewModel] and [state].
  final BasePageBodyBuilder<V, S> body;

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
  final bool useGradientBackground;
  final bool active;
  final bool? canPop;
  final VoidCallback? onInterceptBack;

  /// The Riverpod Provider used to automatically resolve the [BaseViewModel] and [BaseState].
  final ProviderListenable<S>? provider;

  /// An explicitly provided [BaseViewModel] instance.
  final V? viewModel;

  /// Callback for handling custom business side effects.
  final void Function(BaseEffect effect)? onEffect;

  const BasePage({
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
    this.provider,
    this.viewModel,
    this.onEffect,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Resolve the ViewModel instance (logic remains ref.read to get the notifier)
    final effectiveViewModel =
        viewModel ?? (provider != null ? ref.read((provider as dynamic).notifier) as V : null);

    // 2. Resolve the current State (use ref.watch to ensure the body rebuilds on state changes)
    final state = provider != null ? ref.watch(provider!) : null;

    return BaseLifeCyclePage(
      // Inject both viewModel and state into the user's body builder
      body: (context, child) => body(context, child, effectiveViewModel, state),
      title: title,
      actions: actions,
      appBar: appBar,
      drawer: drawer,
      floatingActionButton: floatingActionButton,
      useSafeArea: useSafeArea,
      padding: padding,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      useStatusBar: useStatusBar,
      useBottomBar: useBottomBar,
      isEmptyTitle: isEmptyTitle,
      statusBarColor: statusBarColor,
      bottomBarColor: bottomBarColor,
      useGradientBackground: useGradientBackground,
      active: active,
      canPop: canPop,
      onInterceptBack: onInterceptBack,
      viewModel: effectiveViewModel,
      onEffect: onEffect,
    );
  }
}
