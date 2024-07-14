import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leger holidays web browser',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WebBrowser(),
    );
  }
}

class WebBrowser extends StatefulWidget {
  const WebBrowser({super.key});

  @override
  _WebBrowserState createState() => _WebBrowserState();
}

class _WebBrowserState extends State<WebBrowser> {
  InAppWebViewController? webViewController;
  TextEditingController urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Padding(
          padding:
              const EdgeInsets.all(8.0), // Add padding around the TextField
          child: TextField(
            controller: urlController,
            decoration: const InputDecoration(
              hintText: 'Enter URL',
              hintStyle: TextStyle(color: Colors.white),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10.0),
            ),
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.url,
            onSubmitted: (url) {
              if (webViewController != null) {
                webViewController!.loadUrl(
                  urlRequest: URLRequest(url: WebUri(url)),
                );
              }
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              if (webViewController != null) {
                webViewController!.goBack();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.white),
            onPressed: () {
              if (webViewController != null) {
                webViewController!.goForward();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              if (webViewController != null) {
                webViewController!.reload();
              }
            },
          ),
        ],
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri("https://www.google.com")),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        onLoadStart: (controller, url) {
          setState(() {
            urlController.text = url.toString();
          });
        },
        onLoadStop: (controller, url) async {
          setState(() {
            urlController.text = url.toString();
          });

          if (url.toString().startsWith("https://login.zettle.com/login")) {
            webViewController?.evaluateJavascript(source: """
              document.querySelector('input[type="password"]').value = 'your_password';
            """);
          }
        },
      ),
    );
  }
}
