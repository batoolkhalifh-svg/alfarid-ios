import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VrViewerScreen extends StatefulWidget {
  final String url;

  const VrViewerScreen({
    super.key,
    required this.url,
  });

  @override
  State<VrViewerScreen> createState() => _VrViewerScreenState();
}

class _VrViewerScreenState extends State<VrViewerScreen> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("VR Lab"),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}