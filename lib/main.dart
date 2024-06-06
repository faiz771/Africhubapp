import 'dart:async';
import 'dart:math';

import 'package:afriqmarkethub/onboarding_screen.dart';
import 'package:afriqmarkethub/splash_screen.dart';
import 'package:afriqmarkethub/utils/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:webview_flutter/webview_flutter.dart';

int onboardingStatus = 0;
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return MaterialApp(
      title: 'AfricMarketHub',
      theme: ThemeData(
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: OnboardingScreen(),
    );
  }
}

class WebViewExample extends StatefulWidget {
  const WebViewExample({super.key});

  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  void _onRefresh() async {
    // Call the refresh function here
    // For example:
    controller.reload();
    // Call _refreshController.refreshCompleted() when refresh is done
    _refreshController.refreshCompleted();
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(Uri.parse('https://afriqmarket.azsolutionspk.com'))
    ..enableZoom(false);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (controller != null && await controller!.canGoBack()) {
            await controller!.goBack();
            return false; // Prevent default back button behavior
          }
          return false; // Allow default back button behavior (exit app)
        },
        child: Scaffold(
            // appBar: AppBar(
            //   backgroundColor: Color.fromRGBO(0, 204, 255, 1),
            //   centerTitle: true,
            //   title: const Text('AfriqMarketHub'),
            // ),
            body: WebViewWidget(
          controller: controller,
        )),
      ),
    );
  }
}
