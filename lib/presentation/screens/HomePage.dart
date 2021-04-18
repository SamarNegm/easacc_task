import 'dart:async';
import 'dart:io';

import 'package:easacc_task/data/repo/services/auth.dart';
import 'package:easacc_task/presentation/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Home extends StatefulWidget {
  static const routeName = '/homepage';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final tc = TextEditingController();
  bool isLoading = true;
  WebViewController controller;
  String url = 'https://www.google.com';
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    print(url + ' from inside??????????????????');

    final AuthService auth = Provider.of<AuthService>(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 10),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: tc,
                )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            print('go>>>>>' + url);
                            setState(() {
                              controller.loadUrl(tc.text);
                              url = tc.text;
                            });
                            print('go>>>>>' + url);
                          },
                          child: Text('go'),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: Text(
                      'LogOut',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      Navigator.of(context).pushReplacementNamed('/');
                      await auth.signOut();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () async {
                      Navigator.of(context)
                          .pushReplacementNamed(settings.routeName);
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
                color: Colors.amber,
                child: WebView(
                  initialUrl: url,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    controller = webViewController;
                  },
                  onProgress: (int progress) {
                    print("WebView is loading (progress : $progress%)");
                  },
                  javascriptChannels: <JavascriptChannel>{
                    _toasterJavascriptChannel(context),
                  },
                  navigationDelegate: (NavigationRequest request) {
                    if (request.url.startsWith('https://www.youtube.com/')) {
                      print('blocking navigation to $request}');
                      return NavigationDecision.prevent;
                    }
                    print('allowing navigation to $request');
                    return NavigationDecision.navigate;
                  },
                  onPageStarted: (String url) {
                    print('Page started loading: $url');
                    setState(() {
                      isLoading = true;
                    });
                  },
                  onPageFinished: (String url) {
                    print('Page finished loading: $url');
                    setState(() {
                      isLoading = false;
                    });
                  },
                  gestureNavigationEnabled: true,
                )),
          ),
        ],
      ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}
