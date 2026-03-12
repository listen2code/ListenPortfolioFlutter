import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/uikit/uikit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// A custom builder for [BaseRefreshPage] that provides the resolved [viewModel] and current [state].
typedef BasePageBodyBuilder<V extends BaseViewModel, S extends BaseState> =
    Widget Function(BuildContext context, Widget? child, V? viewModel, S? state);

/// A shared-layer wrapper for the core [BaseLifeCyclePage].
/// This widget acts as a bridge between business-specific Riverpod providers
/// and the pure core architecture, keeping [BaseLifeCyclePage] independent.
class BaseRefreshPage<V extends BaseViewModel, S extends BaseState> extends ConsumerWidget {
  /// The builder for the page content.
  final BasePageBodyBuilder<V, S>? body;
  final String? title;
  final Widget? drawer;
  final bool? canPop;
  final VoidCallback? onInterceptBack;
  final List<Widget>? actions;
  final PreferredSizeWidget? appBar;
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

  /// Whether to wrap the content in a Scaffold.
  /// Defaults to true for root pages, false for embedded sub-pages.
  final bool useScaffold;

  /// The Riverpod Provider used to automatically resolve the [BaseViewModel] and [BaseState].
  final ProviderListenable<S>? provider;

  /// An explicitly provided [BaseViewModel] instance.
  final V? viewModel;

  /// Callback for handling custom business side effects.
  final void Function(BaseEffect effect)? onEffect;

  /// A widget to display when the page is in a loading state.
  final Widget? onLoading;

  /// A widget to display when the page is in an empty state.
  final Widget? onEmpty;

  // --- Refresh Integration ---
  /// If provided, the page content will be wrapped in a [RefreshIndicator].
  /// Provides the current [viewModel] and [state] for easy intent dispatching.
  final Future<void> Function(V? viewModel, S? state)? onRefresh;

  /// Optional list of items. If provided, renders as a ListView.
  final List<dynamic>? items;

  /// A function to extract the list of items from the [state].
  /// Use this to avoid watching the state manually in the parent widget.
  final List<dynamic> Function(S state)? itemSource;

  /// Builder for list items. Required if [items] or [itemSource] is provided.
  final Widget Function(BuildContext context, dynamic item, int index)? itemBuilder;

  /// Optional UI-layer lifecycle listener.
  final PageLifecycle? lifecycle;

  const BaseRefreshPage({
    super.key,
    this.body,
    this.title,
    this.drawer,
    this.canPop,
    this.onInterceptBack,
    this.actions,
    this.appBar,
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
    this.useScaffold = true,
    this.provider,
    this.viewModel,
    this.onEffect,
    this.onLoading,
    this.onEmpty,
    this.onRefresh,
    this.items,
    this.itemSource,
    this.itemBuilder,
    this.lifecycle,
  }) : assert(
         body != null || ((items != null || itemSource != null) && itemBuilder != null),
         'Either body or a combination of (items/itemSource + itemBuilder) must be provided',
       );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Resolve the ViewModel instance
    final effectiveViewModel =
        viewModel ?? (provider != null ? ref.read((provider as dynamic).notifier) as V : null);

    // 2. Resolve the current State
    final state = provider != null ? ref.watch(provider!) : null;

    // 3. Resolve items from either static [items] or dynamic [itemSource]
    final effectiveItems = items ?? (state != null ? itemSource?.call(state) : null);

    Widget? content;
    if (body != null) {
      content = body!(context, null, effectiveViewModel, state);
    }

    if (onRefresh != null) {
      if (itemBuilder != null && effectiveItems != null) {
        content = CommonRefreshList(
          onRefresh: () => onRefresh!(effectiveViewModel, state),
          itemBuilder: itemBuilder,
          items: effectiveItems,
        );
      } else {
        content = CommonRefreshList(onRefresh: () => onRefresh!(effectiveViewModel, state), child: content);
      }
    }

    return BaseLifeCyclePage(
      body: (context, child) => content ?? const CommonEmptyView(),
      title: title,
      drawer: drawer,
      canPop: canPop,
      onInterceptBack: onInterceptBack,
      actions: actions,
      appBar: appBar,
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
      useScaffold: useScaffold,
      viewModel: effectiveViewModel,
      onEffect: onEffect,
      onLoading: onLoading,
      onEmpty: onEmpty,
      lifecycle: lifecycle,
    );
  }
}
