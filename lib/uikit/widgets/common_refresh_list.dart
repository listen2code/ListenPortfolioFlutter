import 'package:flutter/material.dart';

/// A flexible wrapper that supports pull-to-refresh functionality for both lists and single children.
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
  }) : assert(
         child != null || (items != null && itemBuilder != null),
         'Either child or both items and itemBuilder must be provided',
       );

  @override
  Widget build(BuildContext context) {
    // Determine what to scroll
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
