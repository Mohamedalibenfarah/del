import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class PowerBIReport extends StatefulWidget {
  const PowerBIReport({super.key});

  @override
  State<PowerBIReport> createState() => _PowerBIReportState();
}

class _PowerBIReportState extends State<PowerBIReport> {
  String iframeUrl = '';
  bool isLoading = true;
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    fetchPowerBIUrl();
    if (!kIsWeb) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (url) {
              debugPrint('Page started loading: $url');
              setState(() {
                isLoading = true;
              });
            },
            onPageFinished: (url) {
              debugPrint('Page finished loading: $url');
              setState(() {
                isLoading = false;
              });
            },
            onWebResourceError: (error) {
              debugPrint('Page load error: ${error.description}');
              setState(() {
                isLoading = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Failed to load the dashboard: ${error.description}',
                  ),
                ),
              );
            },
          ),
        );
    }
  }

  Future<void> fetchPowerBIUrl() async {
    final response = await http.get(Uri.parse(
        'https://app.powerbi.com/reportEmbed?reportId=c36a6e6c-17c7-4d0a-8f21-15d853c176d5&autoAuth=true&ctid=604f1a96-cbe8-43f8-abbf-f8eaf5d85730'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        iframeUrl = data['url'];
        if (!kIsWeb) {
          _controller.loadRequest(Uri.parse(iframeUrl));
        }
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load Power BI URL');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Power BI Report'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : kIsWeb
              ? HtmlElementView(
                  viewType: 'iframe',
                  onPlatformViewCreated: (int viewId) {
                    debugPrint('IFrameElement created and registered');
                  },
                )
              : Stack(
                  children: [
                    WebViewWidget(controller: _controller),
                    if (isLoading)
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
    );
  }
}
