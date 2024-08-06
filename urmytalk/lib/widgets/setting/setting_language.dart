import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_io/io.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/provider/providers.dart';
import 'package:urmytalk/widgets/wigets.dart';




class UrMyTalkSettingLanguagePage extends ConsumerStatefulWidget {
  static const String routeName = '/urmysettinglanguagepage';

  const UrMyTalkSettingLanguagePage({Key? key}) : super(key: key);
  //const UrMyRegisterPage({Key key}) : super(key: key);

  @override
  ConsumerState<UrMyTalkSettingLanguagePage> createState() => _UrMyTalkSettingLanguagePageState();
}

class _UrMyTalkSettingLanguagePageState extends ConsumerState<UrMyTalkSettingLanguagePage> {
  final _globalWidget = GlobalWidget();
  final GlobalKey<FormState> _settingLanguageFormkey = GlobalKey<FormState>();
  var _isChecked = false;
  Language _language = Language.en;

  @override
  void initState() {
  }



  Widget buildBody(SignInState signInState) {
    return Form(
        key: _settingLanguageFormkey,
        child: languagelistWidget(signInState)
    );
  }

  Widget languagelist(String title) {
    return Container(
      padding: const EdgeInsets.all(18.0),
      child: Text(title,
        style: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 18.0,
        ),),
    );
  }

  Widget languagelistWidget(SignInState signInState) {
    return Column(
      children: [
        RadioListTile(
          title: const Text("setting.language.list.en", style: TextStyle(
            fontSize: urmyContentFontSize,
            fontWeight: urmyContentFontWeight
          )).tr(),
            value: Language.en,
            groupValue: _language,
            onChanged: (Language? value) {
              setState(() {
                _language = value!;
                context.setLocale(const Locale('en', 'US'));
              });
            }
        ),
        RadioListTile(
            title: const Text("setting.language.list.kr", style: TextStyle(
                fontSize: urmyContentFontSize,
                fontWeight: urmyContentFontWeight
            )).tr(),
            value: Language.kr,
            groupValue: _language,
            onChanged: (Language? value) {
              setState(() {
                _language = value!;
                context.setLocale(const Locale('ko', 'KR'));
              });
            }
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _globalWidget.globalAppBar('setting.language.title'.tr()),
      backgroundColor: Colors.white,
      body: _globalWidget.customConsumerWidget(
          buildBody(ref.watch(signinStateProvider))
      ),
    );
  }

}