import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// A shared-layer wrapper for the core [core.BaseLifeCyclePage].
/// This widget is responsible for injecting shared- and uikit-layer dependencies
/// like [LoadingProviderImpl] and [MessageProviderImpl] into the ViewModel.
///
/// This keeps the core BasePage clean and independent, while allowing feature-level
/// pages to use a single `BasePage` widget that handles all setup.
class BasePage extends ConsumerStatefulWidget {
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

  /// Visibility flag for Tab/Page switching inside the same route.
  final bool active;

  /// The Provider to listen for states (errors/messages) and manage lifecycles via its Notifier.
  final ProviderListenable<BaseState<dynamic>>? provider;

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
    this.active = true,
    this.provider,
  });

  @override
  ConsumerState<BasePage> createState() => _BasePageState();
}

class _BasePageState extends ConsumerState<BasePage> {
  @override
  void initState() {
    super.initState();
    // Inject shared/uikit implementations into the ViewModel if a provider is present.
    // This is done once when the widget is initialized.
    if (widget.provider != null) {
      try {
        final viewModel = ref.read((widget.provider! as dynamic).notifier) as BaseViewModel;

        // Inject the concrete implementation for showing/hiding a loading overlay.
        viewModel.loadingProvider = const LoadingProviderImpl();

        // Inject the concrete implementation for showing info/error toasts.
        viewModel.messageProvider = const MessageProviderImpl();
      } catch (_) {
        // Errors are ignored if the provider or notifier isn't a valid ViewModel.
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Render the core BasePage, passing all properties through.
    // The core BasePage is completely decoupled from shared/uikit layers.
    return BaseLifeCyclePage(
      key: widget.key,
      body: widget.body,
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
      active: widget.active,
      provider: widget.provider,
    );
  }
}
