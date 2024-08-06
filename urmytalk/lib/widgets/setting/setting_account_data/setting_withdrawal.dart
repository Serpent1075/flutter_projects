import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_io/io.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/provider/providers.dart';
import 'package:urmytalk/widgets/wigets.dart';


class UrMyTalkSettingWithdrawalPage extends ConsumerStatefulWidget {
  static const String routeName = '/urmysettingwithdrawalpage';

  const UrMyTalkSettingWithdrawalPage({Key? key}) : super(key: key);
  //const UrMyRegisterPage({Key key}) : super(key: key);

  @override
  ConsumerState<UrMyTalkSettingWithdrawalPage> createState() => _UrMyTalkSettingWithdrawalPageState();
}

class _UrMyTalkSettingWithdrawalPageState extends ConsumerState<UrMyTalkSettingWithdrawalPage> {

  final _globalWidget = GlobalWidget();



  void showSnackbar(String text) {
    SnackBar(
      content: Text(text),
    );
  }



  Widget buildBody(SignInState signinState) {
    return _globalWidget.createBackground(context, formListview(context, signinState));
  }

  ListView formListview(BuildContext context, SignInState signinState) {
    return ListView(
      children: <Widget>[
        // create form login
        _globalWidget.createCard(context, urmywithdrawlWidget(signinState)),
        const SizedBox(
          height: 50,
        ),
        // create sign up link

      ],
    );
  }

  Widget urmywithdrawlWidget(SignInState signinState) {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: urmyTitlePadding,
        ),
        Center(
          child: const Text(
            'setting.account.withdrawal.title',
            style: TextStyle(
                color: urmyMainColor,
                fontSize: urmyTitleFontSize,
                fontWeight: urmyTitleFontWeight),
          ).tr(),
        ),
        const SizedBox(
          height: urmyTitlePadding,
        ),
        Center(
          child: const Text(
            'setting.account.withdrawal.notice',
            style: TextStyle(
                color: urmyLabelColor,
                fontSize: urmysubTitleFontSize,
                fontWeight: urmysubTitleFontWeight),
          ).tr(),
        ),
        const SizedBox(
          height: urmyDefaultPadding,
        ),
        Center(
          child: const Text(
            'setting.account.withdrawal.specific',
            style: TextStyle(
                color: urmyTextColor,
                fontSize: urmyContentFontSize,
                fontWeight: urmyContentFontWeight),
          ).tr(),
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
                ref.read(signinProvider.notifier).withdrawal();
                //Navigator.pushNamedAndRemoveUntil(context, UrMyTalkSignInPage.routeName, (route) => false);
              },
              child: Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 5),
                child: const Text(
                  'setting.account.withdrawal.submitbutton',
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

    ref.listen(signinStateProvider, (SignInState? previous, SignInState? next) {
      if(!next!.authenticated && previous!.authenticated != next.authenticated) {
        Navigator.pushNamedAndRemoveUntil(context, UrMyTalkSignInPage.routeName, (route) => false);
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