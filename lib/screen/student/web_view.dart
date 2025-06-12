import 'package:alfarid/core/remote/my_dio.dart';
import 'package:alfarid/core/utils/my_navigate.dart';
import 'package:alfarid/generated/locale_keys.g.dart';
import 'package:alfarid/screen/student/bottom_nav_student/view/bottom_nav_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPaymentScreen extends StatefulWidget {
  final String paymentUrl;

  const WebViewPaymentScreen({super.key, required this.paymentUrl});

  @override
  State<WebViewPaymentScreen> createState() => _WebViewPaymentScreenState();
}

class _WebViewPaymentScreenState extends State<WebViewPaymentScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('success')) {
              return navigateAndFinish(widget: const BottomNavScreen());
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.paymentNow.tr())),
      body: WebViewWidget(controller: _controller),
    );
  }
}
