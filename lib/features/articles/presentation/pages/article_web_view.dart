import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  static String routeName = 'articleWebView';
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  bool init = true;
  late final WebViewController controller;
  late final String link;

  @override
  void didChangeDependencies() {
    if (init) {
      link = ModalRoute.of(context)!.settings.arguments as String;
      controller.loadRequest(
        Uri.parse(link),
      );
      init = !init;
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    controller = WebViewController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        floatingActionButton: const ClosePage(),
        body: WebViewWidget(
          controller: controller,
        ),
      ),
    );
  }
}

class ClosePage extends StatelessWidget {
  const ClosePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      child: const Icon(Icons.close),
      onPressed: () => Navigator.of(context).pop(),
    );
  }
}
