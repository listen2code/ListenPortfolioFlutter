import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

class CommonWebViewPage extends StatelessWidget {
  final String title;
  final String url;
  final void Function(String? url)? onLoadStart;
  final void Function(String? url)? onLoadStop;
  final bool Function(String url)? shouldOverrideUrlLoading;
  final Map<String, Function(List<dynamic> args)>? javascriptHandlers;

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
    return Scaffold(
      body: CommonWebView(
        title: title,
        initialUrl: url,
        showAppBar: true,
        onLoadStart: onLoadStart,
        onLoadStop: onLoadStop,
        shouldOverrideUrlLoading: shouldOverrideUrlLoading,
        javascriptHandlers: javascriptHandlers,
      ),
    );
  }
}
