import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/provider/providers.dart';
import 'dart:io';
import 'package:urmytalk/widgets/wigets.dart';


class UrMyTalkInformationMainPage extends ConsumerWidget {
  static const String routeName = '/urmyinformationmainpage';

  UrMyTalkInformationMainPage({Key? key}) : super(key: key);
  //const UrMyRegisterPage({Key key}) : super(key: key);

  final _globalWidget = GlobalWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final signInState = ref.watch(signinStateProvider);
    return Scaffold(
      appBar: _globalWidget.globalAppBar("information.main.title".tr()),
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: Platform.isIOS
            ? SystemUiOverlayStyle.light
            : const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light),
        child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            children: [
              _globalWidget.screenTabList(context: context, title: 'information.main.servicepolicy'.tr(), routename: UrMyTalkInformationServicePolicyPage.routeName),
              _globalWidget.screenTabList(context: context, title: 'information.main.datapolicy'.tr(), routename: UrMyTalkInformationDataPolicyPage.routeName),
              _globalWidget.screenTabList(context: context, title: 'information.main.illegalpolicy'.tr(), routename: UrMyTalkInformationIllegalPolicyPage.routeName),
              //_globalWidget.screenTabList(context: context, title: 'information.main.opensourcepolicy'.tr(), routename: UrMyTalkInformationOpenSourcePage.routeName),
            ]
        ),
      ),
    );
  }

}