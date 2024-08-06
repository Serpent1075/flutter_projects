
import 'package:easy_localization/easy_localization.dart';
import 'package:universal_io/io.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/widgets/wigets.dart';
import 'package:urmytalk/provider/providers.dart';
import 'package:webview_flutter/webview_flutter.dart';


class UrMyTalkErrorPage extends ConsumerStatefulWidget {
  static const String routeName = '/errorpage';

  const UrMyTalkErrorPage({Key? key}) : super(key: key);

  @override
  ConsumerState<UrMyTalkErrorPage> createState() => _UrMyTalkErrorPageState();
}

class _UrMyTalkErrorPageState extends ConsumerState<UrMyTalkErrorPage> {
  final _globalWidget = GlobalWidget();

  late final WebViewController controller;
  @override
  void initState() {
    ref.read(signinProvider.notifier).checkPM();
    controller = WebViewController()
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
      ..loadRequest(Uri.parse('https://contents.jhoh1075.link/policy/kr/error.html'));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  Widget buildBody(SignInState signInState) {
    return Column(
      children: [
        Expanded(
          child: WebViewWidget(controller: controller),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {


    ref.listen(signinStateProvider, (SignInState? previous, SignInState? next) {
      if(next!.pmerr != "pm-time") {
        ref.read(signinProvider.notifier).setErrorEmpty();
        ref.read(signinProvider.notifier).setErrorEmpty();
        Navigator.pushNamedAndRemoveUntil(context,  UrMyTalkCheckAutologinPage.routeName, (Route<dynamic> route) => false);
      }
    });

    return Scaffold(
        body: _globalWidget.customConsumerWidget(
            buildBody(ref.watch(signinStateProvider))
        ),
    );
  }
}
