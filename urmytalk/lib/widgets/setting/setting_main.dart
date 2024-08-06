import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_io/io.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/widgets/config/constant.dart';
import 'package:urmytalk/widgets/config/global_widget.dart';
import 'package:urmytalk/widgets/wigets.dart';
import 'package:urmytalk/provider/providers.dart';

class UrMyTalkSettingMainPage extends ConsumerStatefulWidget {
  static const String routeName = '/urmysettingmainpage';

  const UrMyTalkSettingMainPage({Key? key}) : super(key: key);
  //const UrMyRegisterPage({Key key}) : super(key: key);

  @override
  ConsumerState<UrMyTalkSettingMainPage> createState() => _UrMyTalkSettingMainPageState();
}

class _UrMyTalkSettingMainPageState extends ConsumerState<UrMyTalkSettingMainPage> {
  final _globalWidget = GlobalWidget();

  Widget buildBody(SignInState signinState) {
    return ListView(
        padding: const EdgeInsets.fromLTRB(14, 14, 24, 16),
        children: [
          _globalWidget.screenTabList(context: context, title: 'setting.main.account'.tr(), routename: UrMyTalkSettingAccountDataPage.routeName),
          _globalWidget.screenTabList(context: context, title: 'setting.main.agefilter'.tr(),  routename: UrMyTalkSettingAgeFilterPage.routeName),
          _globalWidget.screenTabList(context: context, title: 'setting.main.blacklist'.tr(),  routename: UrMyTalkSettingBlacklistPage.routeName),
          _globalWidget.screenTabList(context: context, title: 'setting.main.language'.tr(),  routename: UrMyTalkSettingLanguagePage.routeName),
        ]
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _globalWidget.globalAppBar('setting.main.title'.tr()),
      backgroundColor: Colors.white,
      body: _globalWidget.customConsumerWidget(
          buildBody(ref.watch(signinStateProvider))
      ),
    );
  }

}