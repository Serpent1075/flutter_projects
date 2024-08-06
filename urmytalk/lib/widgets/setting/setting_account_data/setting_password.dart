import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_io/io.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/provider/providers.dart';
import 'package:urmytalk/widgets/wigets.dart';


class UrMyTalkSettingPasswordPage extends ConsumerStatefulWidget {
  static const String routeName = '/urmysettingpasswordpage';

  const UrMyTalkSettingPasswordPage({Key? key}) : super(key: key);
  //const UrMyRegisterPage({Key key}) : super(key: key);

  @override
  ConsumerState<UrMyTalkSettingPasswordPage> createState() => _UrMyTalkSettingPasswordPageState();
}

class _UrMyTalkSettingPasswordPageState extends ConsumerState<UrMyTalkSettingPasswordPage> {

  final GlobalKey<FormState> _updatePasswordFormkey = GlobalKey<FormState>();


  final _globalWidget = GlobalWidget();



  void showSnackbar(String text) {
    SnackBar(
      content: Text(text),
    );
  }

  void submit(String email) async {
    final form = _updatePasswordFormkey.currentState;
    if (!form!.validate()) return;
    form.save();

    showDialog(context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child:CircularProgressIndicator());
      },
    );
    try {
      FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
      showSnackbar('setting.account.password.mailsent'.tr());
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch(e) {
      showSnackbar(e.message!);
      Navigator.of(context).pop();
    }
  }



  Widget buildBody(SignInState signinState) {

    return Form(
      key: _updatePasswordFormkey,
      child: _globalWidget.createBackground(context, formListview(context, signinState)),
    );
  }

  ListView formListview(BuildContext context, SignInState signinState) {
    return ListView(
      children: <Widget>[
        // create form login
        _globalWidget.createCard(context, urmyloginWidget(signinState)),
        const SizedBox(
          height: 50,
        ),
        // create sign up link

      ],
    );
  }

  Widget urmyloginWidget(SignInState signinState) {

    return Column(
      children: <Widget>[
        const SizedBox(
          height: urmyTitlePadding,
        ),
        Center(
          child: const Text(
            'setting.account.password.title',
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
          child: const Text(
            'setting.account.password.curremail',
            style: TextStyle(
                color: urmyTextColor,
                fontSize: urmyContentFontSize,
                fontWeight: urmyContentFontWeight),
          ).tr(),
        ),
        const SizedBox(
          height: urmyDefaultPadding,
        ),
        Text(
          signinState.email,
          style: const TextStyle(
              color: urmyTextColor,
              fontSize: urmysubTitleFontSize,
              fontWeight: urmyContentFontWeight),
        ),
        const SizedBox(
          height: urmyParagraphPadding,
        ),
        SizedBox(
          width: double.maxFinite,
          child: TextButton(
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) => urmyMainColor,
                ),
                overlayColor: MaterialStateProperty.all(
                    Colors.transparent),
                shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
              onPressed: () {
                submit(signinState.email);

              },
              child: Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 5),
                child: signinState
                    .loggingIn
                    ? const SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(
                    valueColor:
                    AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                )
                    : const Text(
                  'setting.account.password.submit',
                  style: TextStyle(
                      fontWeight: urmyButtonFontWeight,
                      fontSize: urmyButtonTextFontSize,
                      color: urmyButtonTextColor),
                  textAlign: TextAlign.center,
                ).tr(),
              )),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }

}