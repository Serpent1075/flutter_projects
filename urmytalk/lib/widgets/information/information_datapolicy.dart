import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/provider/providers.dart';
import 'package:urmytalk/widgets/wigets.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';


class UrMyTalkInformationDataPolicyPage extends ConsumerWidget {
  static const String routeName = '/urmyinformationdatapolicypage';

  UrMyTalkInformationDataPolicyPage({Key? key}) : super(key: key);
  //const UrMyRegisterPage({Key key}) : super(key: key);

  final _globalWidget = GlobalWidget();


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final signInState = ref.watch(signinStateProvider);
    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('${signInState.contentUrl}policy/${context.locale.toString()}/privacy.html'));
    return Scaffold(
      appBar: _globalWidget.globalAppBar("information.datapolicy.title".tr()),
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: Platform.isIOS
            ? SystemUiOverlayStyle.light
            : const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light),
        child: WebViewWidget(controller: controller),
      ),
    );
  }
}