import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// A custom builder for [BasePage] that provides the resolved [viewModel].
typedef BasePageBodyBuilder<T extends BaseViewModel> =
    Widget Function(BuildContext context, Widget? child, T? viewModel);

/// A shared-layer wrapper for the core [BaseLifeCyclePage].
/// This widget acts as a bridge between business-specific Riverpod providers
/// and the pure core architecture, keeping [BaseLifeCyclePage] independent.
class BasePage<T extends BaseViewModel> extends ConsumerWidget {
  /// The builder for the page content, now receiving the [viewModel].
  final BasePageBodyBuilder<T> body;

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

  /// The Riverpod Provider used to automatically resolve the [BaseViewModel].
  final ProviderListenable<BaseState<dynamic>>? provider;

  /// An explicitly provided [BaseViewModel] instance.
  final T? viewModel;

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
    // Logic to resolve the ViewModel:
    // 1. Use the explicitly provided [viewModel] if available.
    // 2. Otherwise, try to read the notifier from the [provider].
    final effectiveViewModel =
        viewModel ?? (provider != null ? ref.read((provider as dynamic).notifier) as T : null);

    return BaseLifeCyclePage(
      // Wrap the user's body to inject the effectiveViewModel
      body: (context, child) => body(context, child, effectiveViewModel),
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
