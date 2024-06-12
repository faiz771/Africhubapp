import 'package:afriqmarkethub/splash_screen.dart';
import 'package:afriqmarkethub/utils/appcolor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

int onboardingStatus = 0;
void main() async {
  // it should be the first line in main method
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  // rest of your app code
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return MaterialApp(
      title: 'AfriqMarketHub',
      theme: ThemeData(
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class WebViewExample extends StatefulWidget {
  const WebViewExample({super.key});

  @override
  State<WebViewExample> createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  PullToRefreshController? pullToRefreshController;

  bool pullToRefreshEnabled = true;
  bool _isInternetError(int code) {
    // Add other relevant error codes here
    return code == -2 || // ERR_FAILED
        code == -6 || // ERR_NAME_NOT_RESOLVED
        code == -106 || // ERR_INTERNET_DISCONNECTED
        code == -105 || // ERR_NAME_NOT_RESOLVED (alternate)
        code == -118; // ERR_CONNECTION_TIMED_OUT
  }

  bool _isHttpInternetError(int statusCode) {
    // HTTP status codes that might indicate no internet
    return statusCode >= 500 && statusCode < 600;
  }

  @override
  void initState() {
    super.initState();

    pullToRefreshController = PullToRefreshController(
      onRefresh: () async {
        if (defaultTargetPlatform == TargetPlatform.android) {
          webViewController?.reload();
          pullToRefreshController!.setColor(Appcolors.bluecolor);
          pullToRefreshController!.setBackgroundColor(Colors.black);
        } else if (defaultTargetPlatform == TargetPlatform.iOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
          pullToRefreshController!.setBackgroundColor(Colors.white);
          pullToRefreshController!.setColor(Colors.black);
        }
      },
    );
  }

  void showNoConnectionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: const Text(
            'Something went wrong',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: const Text(
            'Please check your internet connection and try again.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Appcolors.bluecolor, // Text Color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
              onPressed: () {
                webViewController!.reload();
                Navigator.of(context).pop(); // Close the dialog and retry
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Text(
                  'Retry',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // ignore: deprecated_member_use
      child: WillPopScope(
          onWillPop: () async {
            if (webViewController != null &&
                await webViewController!.canGoBack()) {
              await webViewController!.goBack();
              return false; // Prevent default back button behavior
            }
            return false; // Allow default back button behavior (exit app)
          },
          child: Scaffold(
              body: Column(children: <Widget>[
            Expanded(
              child: InAppWebView(
                initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                  javaScriptCanOpenWindowsAutomatically: true,
                  transparentBackground: true,
                  horizontalScrollBarEnabled: false,
                  verticalScrollBarEnabled: false,
                  userAgent:
                      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Safari/605.1.15',
                  javaScriptEnabled: true,
                  useShouldOverrideUrlLoading: true,
                  useOnLoadResource: true,
                  cacheEnabled: true,
                  allowFileAccessFromFileURLs: false,
                )),
                key: webViewKey,
                initialUrlRequest: URLRequest(
                  url: Uri.parse("https://afriqmarket.azsolutionspk.com"),
                ),
                pullToRefreshController: pullToRefreshController,
                onWebViewCreated: (InAppWebViewController controller) async {
                  webViewController = controller;
                },
                onLoadStop: (controller, url) {
                  pullToRefreshController?.endRefreshing();
                },
                onProgressChanged: (controller, progress) {
                  if (progress == 100) {
                    pullToRefreshController?.endRefreshing();
                  }
                },
                onLoadError: (controller, url, code, message) {
                  if (_isInternetError(code)) {
                    showNoConnectionDialog(context);
                  }
                },
                onLoadHttpError: (controller, url, statusCode, description) {
                  if (_isHttpInternetError(statusCode)) {
                    showNoConnectionDialog(context);
                  }
                },
              ),
            ),
          ]))),
    );
  }
}
