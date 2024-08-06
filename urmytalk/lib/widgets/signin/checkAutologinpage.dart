import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:universal_io/io.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/widgets/wigets.dart';
import 'package:urmytalk/provider/providers.dart';


class UrMyTalkCheckAutologinPage extends ConsumerStatefulWidget {
  static const String routeName = '/checkautologin';
  const UrMyTalkCheckAutologinPage({Key? key}) : super(key: key);
  @override
  ConsumerState<UrMyTalkCheckAutologinPage> createState() => _UrMyTalkCheckAutologinPageState();
}

class _UrMyTalkCheckAutologinPageState extends ConsumerState<UrMyTalkCheckAutologinPage> {

  @override
  void initState() {
    // TODO: implement initState
    ref.read(signinProvider.notifier).checkAutologin();
    ref.read(signinProvider.notifier).getCFurl();


    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  final _globalWidget = GlobalWidget();
  @override
  Widget build(BuildContext context) {

    final signinWatch = ref.watch(signinStateProvider);
    final autologin = ref.watch(userautoLoginProvider);

    ref.listen(signinStateProvider, (SignInState? previous, SignInState? next) {

      if(ref.read(appConfigProvider.notifier).state.buildFlavor == 'dev') {
        print(context.locale.toString());
        print("needProfileUpdate: ${signinWatch.needprofileupdate}");
        print("autologin: ${signinWatch.autoLogin}");
        print("authenticated: ${signinWatch.authenticated}");
        print("uuid: ${signinWatch.uuid}");
      }

      if(!next!.intro) {
        ref.read(signinProvider.notifier).doneIntro();
        Navigator.popAndPushNamed(context, UrMyTalkIntroductionPage.routeName);
      } else {
        if(next!.autoLogin && !next.authenticated) {
          ref.read(signinProvider.notifier).autologin();
        }
      }
/*
      if(next!.needprofileupdate == 10 && next.authenticated && previous!.authenticated != next.authenticated){
        Navigator.popAndPushNamed(context, UrMyTalkMainPage.routeName);
      } else if (next!.needprofileupdate == 20 && next.authenticated && previous!.authenticated != next.authenticated) {
        Navigator.popAndPushNamed(context, UrMyTalkSignUpAgreementPage.routeName);
      }

 */
    });

    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: Platform.isIOS
        ? SystemUiOverlayStyle.light
            : const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light),
        child: autologin.when(
            data: ((data){
              if (data) {
                return const UrMyTalkMainPage();
              } else {
                return const UrMyTalkSignInPage();
              }
            }),
            error: ((error, stackTrace) {
              _globalWidget.showNormalDialog(context, "error", error.toString());
              return const UrMyTalkSignInPage();
            }),
            loading: ((){
              return  const Center(child: CircularProgressIndicator(),);
            }))/*autologin.when(
            data: ((data){
              if (data == false) {
                return const UrMyTalkSignInPage();
              } else {
                return const UrMyTalkMainPage();
              }
            }),
            error: ((error, stackTrace) {
              _globalWidget.showNormalDialog(context, "error", error.toString());
              return const UrMyTalkSignInPage();
            }),
            loading: ((){
              return  const Center(child: CircularProgressIndicator(),);
            })),*/
    )
    );
  }
}

