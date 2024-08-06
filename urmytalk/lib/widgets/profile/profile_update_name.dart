import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/provider/providers.dart';
import 'package:urmytalk/widgets/wigets.dart';
import 'dart:io';

class UrMyTalkUpdateNameProfilePage extends ConsumerStatefulWidget {
  static const String routeName = '/urmyupdatenameprofilepage';

  const UrMyTalkUpdateNameProfilePage({Key? key}) : super(key: key);
  //const UrMyRegisterPage({Key key}) : super(key: key);

  @override
  ConsumerState<UrMyTalkUpdateNameProfilePage> createState() => _UrMyTalkUpdateNameProfilePageState();
}

class _UrMyTalkUpdateNameProfilePageState extends ConsumerState<UrMyTalkUpdateNameProfilePage> {
  late String _name;

  final GlobalKey<FormState> _updateUrDataFormkey = GlobalKey<FormState>();
  final _globalWidget = GlobalWidget();

  @override
  void initState() {
    super.initState();
    _name = ref.read(signinProvider.notifier).state.name;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void submit() {
    final form = _updateUrDataFormkey.currentState;
    if (!form!.validate()) return;
    form.save();
    ref.read(signinProvider.notifier).updateProfile("name", base64.encode(utf8.encode(_name)));
  }

  Widget buildBody(SignInState signInState) {
    return Form(
        key: _updateUrDataFormkey,
        child: _globalWidget.createBackground(context, formListview(context, signInState))
    );
  }

  ListView formListview(BuildContext context, SignInState signInState) {
    return ListView(
      children: <Widget>[
        // create form login
        _globalWidget.createCard(context, urmyupdate_nameWidget(signInState)),
        // create sign up link
      ],
    );
  }

  Widget urmyupdate_nameWidget(SignInState signInState) {
      return Column(
        children: <Widget>[
          const SizedBox(
            height: urmyTitlePadding,
          ),
          Center(
            child: const Text(
              'profile.update.name.title',
              style: TextStyle(
                  color: urmyMainColor,
                  fontSize: urmyTitleFontSize,
                  fontWeight: urmyTitleFontWeight),
            ).tr(),
          ),
          const SizedBox(
            height: urmyTitlePadding,
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              'profile.update.name.subtitle',
              style: TextStyle(
                  color: urmyLabelColor,
                  fontSize: urmysubTitleFontSize,
                  fontWeight: urmysubTitleFontWeight
              ),
            ).tr(),
          ),
          const SizedBox(
            height: urmyDefaultPadding,
          ),

          TextFormField(
            cursorColor: urmyLabelColor,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: urmyUnderlineInActiveColor)),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: urmyUnderlineActiveColor),
                ),
                labelText: 'profile.update.name.nameinput'.tr(),
                labelStyle: const TextStyle(
                    fontSize: urmyContentFontSize,
                    fontWeight: urmyContentFontWeight,
                    color: urmyTextColor
                )),
            onSaved: (value) => _name = value!,
          ),
          const SizedBox(
            height: urmyParagraphPadding,
          ),

          SizedBox(
            width: double.maxFinite,
            child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) => urmyMainColor,
                  ),
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                  ),
                ),
                onPressed: () {
                  submit();
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: const Text(
                    'profile.update.name.submitbutton',
                    style: TextStyle(
                        fontWeight: urmyButtonFontWeight,
                        fontSize: urmyButtonTextFontSize,
                        color: urmyButtonTextColor),
                    textAlign: TextAlign.center,
                  ).tr(),
                )
            ),
          ),
        ],
      );
  }



  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: Platform.isIOS
        ? SystemUiOverlayStyle.light
            : const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
    ),
    child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: urmyGradientTop,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(8.0,8.0,0.0,0.0),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: urmyLogoColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: _globalWidget.customConsumerWidget(
          buildBody(ref.watch(signinStateProvider))
      ),
      ),
    );
  }

}