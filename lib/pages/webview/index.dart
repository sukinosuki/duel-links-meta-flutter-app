import 'package:duel_links_meta/components/Loading.dart';
import 'package:flutter/material.dart';
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
  var loadingPercentage = 0;

  initWebViewController() {
    _webViewController = WebViewController()
      ..loadRequest(Uri.parse(url))
      ..setNavigationDelegate(NavigationDelegate(onPageStarted: (url) {
        setState(() {
          if (loadingPercentage == 100) return;
          loadingPercentage = 0;
        });
      }, onProgress: (progress) {
        setState(() {
          if (loadingPercentage == 100) return;
          loadingPercentage = progress;
        });
      }, onPageFinished: (url) {
        setState(() {
          if (loadingPercentage == 100) return;
          loadingPercentage = 100;
        });
      }));
  }

  @override
  void initState() {
    super.initState();
    initWebViewController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001b35),
      appBar: AppBar(
        title: Text(title),
        actions: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  if (await _webViewController.canGoBack()) {
                    await _webViewController.goBack();
                  } else {
                    messenger.showSnackBar(
                      const SnackBar(content: Text('No back history item')),
                    );
                    return;
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  if (await _webViewController.canGoForward()) {
                    await _webViewController.goForward();
                  } else {
                    messenger.showSnackBar(
                      const SnackBar(content: Text('No forward history item')),
                    );
                    return;
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.replay),
                onPressed: () {
                  _webViewController.reload();
                },
              ),
            ],
          )
        ],
      ),
      body: Stack(
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 0),
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
