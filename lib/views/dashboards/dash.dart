import 'package:deloitte/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

class Dashboarding extends StatelessWidget {
  Dashboarding({super.key});

  final PlatformWebViewController controller =
      PlatformWebViewController(const PlatformWebViewControllerCreationParams())
        ..loadRequest(
          LoadRequestParams(
            uri: Uri.parse(
              'https://app.powerbi.com/reportEmbed?reportId=c36a6e6c-17c7-4d0a-8f21-15d853c176d5&autoAuth=true&ctid=604f1a96-cbe8-43f8-abbf-f8eaf5d85730',
            ),
          ),
        );
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: [
              Column(
                children: [
                  const Header(),
                  Flexible(
                    child: PlatformWebViewWidget(
                      PlatformWebViewWidgetCreationParams(controller: controller),
                    ).build(context),
                  ),
                ],
              ),
              PointerInterceptor(
                child: const Text(""),
              )
            ],
          ),
        ),
      ),
    );
  }
}
