import 'dart:developer';

import 'package:duel_links_meta/components/Loading.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewPage extends StatefulWidget {
  const WebviewPage({Key? key, this.title = '', required this.url}) : super(key: key);

  final String title;
  final String url;

  @override
  State<WebviewPage> createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  String get title => super.widget.title;

  String get url => super.widget.url;

  late final WebViewController _webViewController;
  int loadingPercentage = 0;

  void initWebViewController() {
    _webViewController = WebViewController()
      ..loadRequest(Uri.parse(url))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              if (loadingPercentage == 100) return;
              loadingPercentage = 0;
            });
          },
          onProgress: (progress) {
            setState(() {
              if (loadingPercentage == 100) return;
              loadingPercentage = progress;
            });
          },
          onPageFinished: (url) {
            setState(() {
              if (loadingPercentage == 100) return;
              loadingPercentage = 100;
            });
          },
        ),
      );
  }

  void openByBrowser() {
    final uri = Uri.parse(url);
    launchUrl(uri).ignore();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initWebViewController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: openByBrowser,
                icon: const Icon(Icons.open_in_browser_rounded),
              ),
              // IconButton(
              //   icon: const Icon(Icons.replay),
              //   onPressed: () {
              //     _webViewController.reload();
              //   },
              // ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          AnimatedOpacity(
            duration: Duration.zero,
            opacity: loadingPercentage == 100 ? 1 : 0,
            child: WebViewWidget(
              controller: _webViewController,
            ),
          ),
          if (loadingPercentage < 100)
            const Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Loading(),
                ))
        ],
      ),
    );
  }
}
