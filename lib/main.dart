import 'package:afriqmarkethub/onboarding_screen.dart';
import 'package:afriqmarkethub/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      home: SplashScreen(),
    );
  }
}

class WebViewExample extends StatefulWidget {
  const WebViewExample({super.key});

  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(Uri.parse('https://afriqmarket.azsolutionspk.com'));
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          // Check if web view can go back
          // final controller = WebViewFlutterPlugin.platformViewsRegistry.cast<WebViewControllerRegistry>()?.controller;
          // if (controller != null && await controller.canGoBack()) {
          //   await controller.goBack();
          //   return false; // Prevent default back button behavior
          // }
          return false; // Allow default back button behavior (exit app)
        },
        child: Scaffold(
            // appBar: AppBar(
            //   backgroundColor: Color.fromRGBO(0, 204, 255, 1),
            //   centerTitle: true,
            //   title: const Text('AfriqMarketHub'),
            // ),
            body: WebViewWidget(controller: controller)),
      ),
    );
  }
}
