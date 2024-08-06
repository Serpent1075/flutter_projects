import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_io/io.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/provider/providers.dart';
import 'package:urmytalk/widgets/wigets.dart';


class UrMyTalkSettingNotificationPage extends ConsumerStatefulWidget {
  static const String routeName = '/urmysettingnotificationpage';

  const UrMyTalkSettingNotificationPage({Key? key}) : super(key: key);
  //const UrMyRegisterPage({Key key}) : super(key: key);

  @override
  ConsumerState<UrMyTalkSettingNotificationPage> createState() => _UrMyTalkSettingNotificationPageState();
}

class _UrMyTalkSettingNotificationPageState extends ConsumerState<UrMyTalkSettingNotificationPage> {
  final _globalWidget = GlobalWidget();
  final GlobalKey<FormState> _settingNotificationFormkey = GlobalKey<FormState>();
  bool _isChecked = false;

  var notificationlist = [
    "setting.notification.pushnoti".tr(),
    "setting.notification.stopall".tr(),
    "setting.notification.emailorsms".tr(),
    "setting.notification.extra".tr(),
  ];

  @override
  void initState() {
  }



  Widget buildBody(SignInState signInState) {
    return Form(
        key: _settingNotificationFormkey,
        child: urmysetting_notificationWidget(signInState)
    );
  }

  Widget notilist(String title) {
    return Container(
      padding: const EdgeInsets.all(18.0),
      child: Text(title,
        style: const TextStyle(
        fontWeight: FontWeight.normal,
          fontSize: 18.0,
      ),),
    );
  }

  Widget urmysetting_notificationWidget(SignInState signInState) {
    return Column(
      children: [
        Expanded(
            child: SizedBox(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(5, 20, 20, 16),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, index) {

                  if(index ==1){
                    return Row(
                      children: [
                        notilist(notificationlist[index]),
                        /*
                        SizedBox(width: MediaQuery.of(context).size.width/6),
                        Switch(
                          value: _isChecked,
                          onChanged: (value){
                            setState((){
                              _isChecked = value;
                            });
                          },
                        ),

                         */
                      ],
                    );
                  } else {
                    return notilist(notificationlist[index]);
                  }
                },
                itemCount: notificationlist.length,

              ),
            )
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _globalWidget.globalAppBar('setting.notification.title'.tr()),
      backgroundColor: Colors.white,
      body: _globalWidget.customConsumerWidget(
          buildBody(ref.watch(signinStateProvider))
      )
    );
  }

}