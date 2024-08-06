import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_io/io.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/provider/providers.dart';
import 'package:urmytalk/widgets/wigets.dart';

class UrMyTalkSettingUpdateEmailPage extends ConsumerStatefulWidget {
  static const String routeName = '/urmyupdateemailpage';

  const UrMyTalkSettingUpdateEmailPage({Key? key}) : super(key: key);
  //const UrMyRegisterPage({Key key}) : super(key: key);

  @override
  ConsumerState<UrMyTalkSettingUpdateEmailPage> createState() => _UrMyTalkSettingUpdateEmailPageState();
}

class _UrMyTalkSettingUpdateEmailPageState extends ConsumerState<UrMyTalkSettingUpdateEmailPage> {
  late String email = '';
  final GlobalKey<FormState> _updateUrDataFormkey = GlobalKey<FormState>();
  final _globalWidget = GlobalWidget();


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  submit() {
    final form = _updateUrDataFormkey.currentState;
    if (!form!.validate()) return false;
    form.save();
    ref.read(signinProvider.notifier).updateProfile("email", email);
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
        _globalWidget.createCard(context, urmyupdate_emailWidget(signInState)),
      ],
    );
  }

  Widget urmyupdate_emailWidget(SignInState signInState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: urmyTitlePadding,
        ),
        Center(
          child: const Text(
            'setting.account.email.title',
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
            'setting.account.email.curremail',
            style: TextStyle(
                color: urmyTextColor,
                fontSize: urmyContentFontSize,
                fontWeight: urmyContentFontWeight),
          ).tr(),
        ),
        Container(
          child: Text(
            signInState.email,
            style: const TextStyle(
                color: urmyTextColor,
                fontSize: urmyContentFontSize,
                fontWeight: urmyContentFontWeight),
          ),
        ),
        const SizedBox(
          height: urmyDefaultPadding,
        ),

        TextFormField(
          cursorColor: urmyLabelColor,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: urmyUnderlineInActiveColor)),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: urmyUnderlineActiveColor),
                ),
                labelText: 'setting.account.email.emailinput'.tr(),
                labelStyle: const TextStyle(
                    fontSize: urmyContentFontSize,
                    fontWeight: urmyContentFontWeight,
                    color: urmyTextColor
                )),
            onSaved: (value) => email = value!,
            validator: (val){
              val = val!.trim();
              if (val.isEmpty) {
                return 'Email is required';
              }
              if (!RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(val)) {
                return 'Invalid Email Address';
              }
              return null;
            },
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
                  'setting.account.email.submitbutton',
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


    ref.listen(signinStateProvider, (SignInState? previous, SignInState? next) {
      if (next!.error.isNotEmpty) {
        if (next.error == "updateprofile") {
          _globalWidget.showDialogWithFunc(context, 'setting.account.email.unupdatable'.tr(), ref.read(signinProvider.notifier).setErrorEmpty());
        }else {
          _globalWidget.showDialogWithFunc(context, next!.error, ref.read(signinProvider.notifier).setErrorEmpty());
        }
      }
    });

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