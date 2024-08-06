import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_io/io.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/provider/providers.dart';
import 'package:urmytalk/widgets/wigets.dart';

class UrMyTalkSettingAccountDataPage extends ConsumerWidget {
  static const String routeName = '/urmysettingaccountdatapage';

  UrMyTalkSettingAccountDataPage({Key? key}) : super(key: key);
  //const UrMyRegisterPage({Key key}) : super(key: key);


  final _globalWidget = GlobalWidget();


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: _globalWidget.globalAppBar('setting.account.title'.tr()),
      backgroundColor: Colors.white,
      body:  AnnotatedRegion<SystemUiOverlayStyle>(
        value: Platform.isIOS
            ? SystemUiOverlayStyle.light
            : const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light),
        child: ListView(
            padding: const EdgeInsets.fromLTRB(14, 14, 24, 16),
            children: [
              //_globalWidget.screenTabList(context: context, title: 'setting.account.email.title'.tr(), routename: UrMyTalkSettingUpdateEmailPage.routeName),
              _globalWidget.screenTabList(context: context, title: 'setting.account.password.title'.tr(),  routename: UrMyTalkSettingPasswordPage.routeName),
              _globalWidget.screenTabList(context: context, title: 'setting.account.withdrawal.title'.tr(), routename: UrMyTalkSettingWithdrawalPage.routeName),
            ]
        ),
      )
    );
  }

}