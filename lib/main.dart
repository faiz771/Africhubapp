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
                  showNoConnectionDialog(context);
                },
                onLoadHttpError: (controller, url, statusCode, description) {
                  showNoConnectionDialog(context);
                },
              ),
            ),
          ]))),
    );
  }
}

// class WebViewExample extends StatefulWidget {
//   const WebViewExample({super.key});

//   @override
//   _WebViewExampleState createState() => _WebViewExampleState();
// }

// class _WebViewExampleState extends State<WebViewExample> {
//   // late WebViewController controller;

//   @override
//   void initState() {
//     super.initState();

//     // controller = WebViewController()
//     //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
//     //   ..loadRequest(Uri.parse('https://afriqmarket.azsolutionspk.com'))
//     //   ..enableZoom(false)
//     //   ..setNavigationDelegate(
//     //     NavigationDelegate(
//     //       onProgress: (int progress) {
//     //         print('Current Progress $progress');
//     //         // Update loading bar.
//     //       },
//     //       onPageStarted: (String url) {},
//     //       onPageFinished: (String url) {},
//     //       onHttpError: (HttpResponseError error) {},
//     //       onWebResourceError: (WebResourceError error) {
//     //         if (error.errorType == WebResourceErrorType.hostLookup) {
//     //           showNoConnectionDialog(context);
//     //         }
//     //       },
//     //     ),
//     //   );
//   }

//   void _onRefresh() async {
//     // Call the refresh function here
//     // For example:
//     // Call _refreshController.refreshCompleted() when refresh is done
//     _refreshController.refreshCompleted();
//   }

//   final RefreshController _refreshController =
//       RefreshController(initialRefresh: false);


//   InAppWebViewController? webViewController;
//   final GlobalKey webViewKey = GlobalKey();
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: WillPopScope(
//           onWillPop: () async {
//             // if (controller != null && await controller!.canGoBack()) {
//             //   await controller!.goBack();
//             //   return false; // Prevent default back button behavior
//             // }
//             return false; // Allow default back button behavior (exit app)
//           },
//           child: Scaffold(
//             // appBar: AppBar(
//             //   backgroundColor: Color.fromRGBO(0, 204, 255, 1),
//             //   centerTitle: true,
//             //   title: const Text('AfriqMarketHub'),
//             // ),
//             body: Column(children: <Widget>[
//               Expanded(
//                   child: InAppWebView(
//                 key: webViewKey,
//                 initialUrlRequest: URLRequest(
//                     url: WebUri('https://afriqmarket.azsolutionspk.com')),
//                 initialSettings: InAppWebViewSettings(
//                     transparentBackground: false,
//                     safeBrowsingEnabled: true,
//                     isFraudulentWebsiteWarningEnabled: true),
//                 onWebViewCreated: (controller) async {
//                   webViewController = controller;
//                   // if (!kIsWeb &&
//                   //     defaultTargetPlatform == TargetPlatform.android) {
//                   //   await controller.startSafeBrowsing();
//                   // }
//                 },
//                 onLoadStart: (controller, url) {
//                   if (url != null) {
//                     // setState(() {
//                     //   this.url = url.toString();
//                     //   isSecure = urlIsSecure(url);
//                     // });
//                   }
//                 },
//                 onLoadStop: (controller, url) async {
//                   if (url != null) {
//                     // setState(() {
//                     //   this.url = url.toString();
//                     // });
//                   }

//                   // final sslCertificate = await controller.getCertificate();
//                   // setState(() {
//                   //   isSecure = sslCertificate != null ||
//                   //       (url != null && urlIsSecure(url));
//                   // });
//                 },
//                 onUpdateVisitedHistory: (controller, url, isReload) {
//                   // if (url != null) {
//                   //   setState(() {
//                   //     this.url = url.toString();
//                   //   });
//                   // }
//                 },
//                 onTitleChanged: (controller, title) {
//                   // if (title != null) {
//                   //   setState(() {
//                   //     this.title = title;
//                   //   });
//                   // }
//                 },
//                 onProgressChanged: (controller, progress) {
//                   // setState(() {
//                   //   this.progress = progress / 100;
//                   // });
//                 },
//                 shouldOverrideUrlLoading: (controller, navigationAction) async {
//                   final url = navigationAction.request.url;
//                   if (navigationAction.isForMainFrame &&
//                       url != null &&
//                       ![
//                         'http',
//                         'https',
//                         'file',
//                         'chrome',
//                         'data',
//                         'javascript',
//                         'about'
//                       ].contains(url.scheme)) {
//                     // if (await canLaunchUrl(url)) {
//                     //   launchUrl(url);
//                     //   return NavigationActionPolicy.CANCEL;
//                     // }
//                   }
//                   return NavigationActionPolicy.ALLOW;
//                 },
//               )),
//             ]),
//             bottomNavigationBar: BottomAppBar(
//               child: Row(
//                 mainAxisSize: MainAxisSize.max,
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   IconButton(
//                     icon: const Icon(Icons.share),
//                     onPressed: () {
//                       // Share.share(url, subject: title);
//                     },
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.refresh),
//                     onPressed: () {
//                       // webViewController?.reload();
//                     },
//                   ),
//                   PopupMenuButton<int>(
//                     // onSelected: (item) => handleClick(item),
//                     itemBuilder: (context) => [
//                       PopupMenuItem<int>(
//                           enabled: false,
//                           child: Column(
//                             children: [
//                               Row(
//                                 children: const [
//                                   FlutterLogo(),
//                                   Expanded(
//                                       child: Center(
//                                     child: Text(
//                                       'Other options',
//                                       style: TextStyle(color: Colors.black),
//                                     ),
//                                   )),
//                                 ],
//                               ),
//                               const Divider()
//                             ],
//                           )),
//                       PopupMenuItem<int>(
//                           value: 0,
//                           child: Row(
//                             children: const [
//                               Icon(Icons.open_in_browser),
//                               SizedBox(
//                                 width: 5,
//                               ),
//                               Text('Open in the Browser')
//                             ],
//                           )),
//                       PopupMenuItem<int>(
//                           value: 1,
//                           child: Row(
//                             children: const [
//                               Icon(Icons.clear_all),
//                               SizedBox(
//                                 width: 5,
//                               ),
//                               Text('Clear your browsing data')
//                             ],
//                           )),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           )),
//       // floatingActionButton:  WebResourceErrorType.hostLookup?,
//     );
//   }
// }
