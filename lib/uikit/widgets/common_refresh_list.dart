import 'package:flutter/material.dart';
import '../uikit.dart';

/// A flexible wrapper that supports pull-to-refresh functionality for both lists and single children.
/// Integrated with [CommonEmptyView] to handle empty states automatically.
class CommonRefreshList<T> extends StatelessWidget {
  /// Optional list of items. If provided, renders as a ListView.
  final List<T>? items;

  /// Builder for list items. Required if [items] is provided.
  final Widget Function(BuildContext context, T item, int index)? itemBuilder;

  /// Optional single child. If provided, [items] will be ignored.
  final Widget? child;

  /// The async callback triggered when pulling down.
  final Future<void> Function()? onRefresh;

  final EdgeInsetsGeometry? padding;
  final Widget? separator;
  final ScrollController? controller;
  final ScrollPhysics? physics;

  /// Whether to show the empty view when [items] is empty.
  final bool showEmptyView;

  const CommonRefreshList({
    super.key,
    this.items,
    this.itemBuilder,
    this.child,
    this.onRefresh,
    this.padding,
    this.separator,
    this.controller,
    this.physics,
    this.showEmptyView = true,
  }) : assert(
         child != null || (items != null && itemBuilder != null),
         'Either child or both items and itemBuilder must be provided',
       );

  @override
  Widget build(BuildContext context) {
    // 1. Handle Empty State
    if (child == null && items != null && items!.isEmpty && showEmptyView) {
      final emptyContent = SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          alignment: Alignment.center,
          // Use a percentage of screen height to ensure enough scroll space for RefreshIndicator
          height: MediaQuery.of(context).size.height * 0.6,
          child: const CommonEmptyView(),
        ),
      );

      return onRefresh != null ? RefreshIndicator(onRefresh: onRefresh!, child: emptyContent) : emptyContent;
    }

    // 2. Determine what to scroll
    final Widget scrollableContent;

    if (child != null) {
      // Single child mode: Wrap in SingleChildScrollView to support RefreshIndicator
      scrollableContent = SingleChildScrollView(
        controller: controller,
        physics: physics ?? const AlwaysScrollableScrollPhysics(),
        padding: padding ?? EdgeInsets.zero,
        child: child,
      );
    } else {
      // List mode: Use ListView.separated
      scrollableContent = ListView.separated(
        controller: controller,
        physics: physics ?? const AlwaysScrollableScrollPhysics(),
        padding: padding ?? EdgeInsets.zero,
        itemCount: items!.length,
        separatorBuilder: (context, index) => separator ?? const SizedBox.shrink(),
        itemBuilder: (context, index) => itemBuilder!(context, items![index], index),
      );
    }

    if (null != onRefresh) {
      return RefreshIndicator(onRefresh: onRefresh!, child: scrollableContent);
    } else {
      return scrollableContent;
    }
  }
}
