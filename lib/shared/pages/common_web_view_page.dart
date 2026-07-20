import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

class CommonWebViewPage extends StatelessWidget {
  final String title;
  final String url;
  final void Function(String? url)? onLoadStart;
  final void Function(String? url)? onLoadStop;
  final bool Function(String url)? shouldOverrideUrlLoading;
  final Map<String, dynamic Function(List<dynamic> args)>? javascriptHandlers;

  const CommonWebViewPage({
    super.key,
    required this.title,
    required this.url,
    this.onLoadStart,
    this.onLoadStop,
    this.shouldOverrideUrlLoading,
    this.javascriptHandlers,
  });

  @override
  Widget build(BuildContext context) {
    return CommonWebView(
      title: title,
      initialUrl: url,
      showAppBar: true,
      shrinkWrap: false,
      onLoadStart: onLoadStart,
      onLoadStop: onLoadStop,
      shouldOverrideUrlLoading: shouldOverrideUrlLoading,
      javascriptHandlers: javascriptHandlers,
    );
  }
}
