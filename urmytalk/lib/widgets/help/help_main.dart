import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/widgets/wigets.dart';
import 'dart:io';


class UrMyTalkHelpMainPage extends ConsumerWidget {
  static const String routeName = '/urmyhelpmainpage';

  UrMyTalkHelpMainPage({Key? key}) : super(key: key);
  //const UrMyRegisterPage({Key key}) : super(key: key);

  final _globalWidget = GlobalWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: _globalWidget.globalAppBar("help.main.title".tr()),
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: Platform.isIOS
            ? SystemUiOverlayStyle.light
            : const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light),
        child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            children: [
              _globalWidget.screenTabList(context: context, title: 'help.main.inquiry'.tr(), routename: UrMyTalkHelpInquiryPage.routeName),
              _globalWidget.screenTabList(context: context, title: 'help.main.inquirylist'.tr(), routename: UrMyTalkHelpInquiryListPage.routeName),
            ]
        ),
      ),
    );
  }

}