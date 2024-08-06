import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:universal_io/io.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/widgets/wigets.dart';
import 'package:urmytalk/provider/providers.dart';


class UrMyTalkForgotPasswordPage extends ConsumerStatefulWidget {
  static const String routeName = '/forgotpassword';

  const UrMyTalkForgotPasswordPage({Key? key}) : super(key: key);

  @override
  ConsumerState<UrMyTalkForgotPasswordPage> createState() => _UrMyTalkForgotPasswordPageState();
}

class _UrMyTalkForgotPasswordPageState extends ConsumerState<UrMyTalkForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();

  final _globalWidget = GlobalWidget();
  late String _email;


  @override
  void initState() {
    super.initState();
    //_checkAutoLogin();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showSnackbar(String text) {
    SnackBar(
      content: Text(text),
    );
  }

  void submit() async {
    final form = formKey.currentState;
    if (!form!.validate()) return;
    form.save();

    showDialog(context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child:CircularProgressIndicator());
      },
    );
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _email.trim());
      showSnackbar('forgotpassword.mailsent'.tr());
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch(e) {
      showSnackbar(e.message!);
      Navigator.of(context).pop();
    }
  }



  Widget buildBody(SignInState signinState) {

    if (signinState.autoLogin) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (signinState.loggingIn) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Form(
      key: formKey,
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
        outsideCard(),
        const SizedBox(
          height: 20,
        ),
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
            'signin.title',
            style: TextStyle(
                color: urmyMainColor,
                fontSize: urmyTitleFontSize,
                fontWeight: urmyTitleFontWeight),
          ).tr(),
        ),
        const SizedBox(
          height: urmyTitlePadding,
        ),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              focusedBorder: const UnderlineInputBorder(
                  borderSide:
                  BorderSide(color: urmyUnderlineInActiveColor)),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: urmyUnderlineActiveColor),
              ),
              labelText: 'forgotpassword.emailInput'.tr(),
              labelStyle: const TextStyle(
                  fontSize: urmyContentFontSize,
                  fontWeight: urmyContentFontWeight,
                  color: urmyTextColor
              )),
          onSaved: (value) => _email = value!,
        ),

        const SizedBox(
          height: 40,
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
                submit();

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
                  'forgotpassword.resetbutton',
                  style: TextStyle(
                      fontWeight: urmyButtonFontWeight,
                      fontSize: urmyButtonTextFontSize, color: urmyButtonTextColor),
                  textAlign: TextAlign.center,
                ).tr(),
              )),
        ),
      ],
    );
  }

  Widget outsideCard() {
    return Center(
      child: Wrap(
        children: <Widget>[

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final signinWatch = ref.watch(signinStateProvider);

    if (signinWatch.authenticated == true){
      Navigator.pushReplacementNamed(context, UrMyTalkMainPage.routeName);
    }

    return Scaffold(
      body: _globalWidget.customConsumerWidget(
          buildBody(ref.watch(signinStateProvider))
      ),
    );
  }
}
