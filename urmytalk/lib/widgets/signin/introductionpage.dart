import 'package:easy_localization/easy_localization.dart';
import 'package:introduction_slider/introduction_slider.dart';
import 'package:universal_io/io.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/widgets/wigets.dart';
import 'package:urmytalk/provider/providers.dart';


class UrMyTalkIntroductionPage extends ConsumerStatefulWidget {
  static const String routeName = '/introduction';

  const UrMyTalkIntroductionPage({Key? key}) : super(key: key);

  @override
  ConsumerState<UrMyTalkIntroductionPage> createState() => _UrMyTalkIntroductionPageState();
}

class _UrMyTalkIntroductionPageState extends ConsumerState<UrMyTalkIntroductionPage> {

  final _globalWidget = GlobalWidget();

  @override
  void initState() {

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  Widget buildBody(SignInState signinState) {
    return IntroductionSlider(
      dotIndicator: const DotIndicator(
        selectedColor: urmyIntroductionTextColor,
        unselectedColor: urmyIntroductionTextColor
      ),
      next: Next(child: const Text("signin.intro.next", style: TextStyle(
          color: urmyIntroductionTextColor,
          fontSize: urmySubTextTitleFontSize,
          fontWeight: urmySubTextTitleFontWeight),).tr(),),
      done: Done(
          child: const Text("signin.intro.done", style: TextStyle(
          color: urmyIntroductionTextColor,
          fontSize: urmySubTextTitleFontSize,
          fontWeight: urmySubTextTitleFontWeight),).tr(),
          home: const UrMyTalkSignInPage()),
      items: [
        IntroductionSliderItem(
            logo: _globalWidget.createIntroLogoWidget(context),
          title: const Text("signin.intro.one.title", style: TextStyle(
              color: urmyIntroductionTextColor,
              fontSize: urmyTitleFontSize,
              fontWeight: urmyTitleFontWeight),).tr(),
          subtitle: Padding(
            padding: const EdgeInsets.all(15.0),
            child: const Text("signin.intro.one.description", style: TextStyle(
                color: urmyIntroductionTextColor,
                fontSize: urmysubTitleFontSize,
                fontWeight: urmysubTitleFontWeight)).tr(),
          ),
          backgroundColor: umryIntroduction
        ),
        IntroductionSliderItem(
          logo: _globalWidget.createIntroLogoWidget(context),
          title: const Text("signin.intro.two.title", style: TextStyle(
              color: urmyIntroductionTextColor,
              fontSize: urmyTitleFontSize,
              fontWeight: urmyTitleFontWeight),).tr(),
          subtitle: Padding(
            padding: const EdgeInsets.all(15.0),
            child: const Text("signin.intro.two.description", style: TextStyle(
                color: urmyIntroductionTextColor,
                fontSize: urmysubTitleFontSize,
                fontWeight: urmysubTitleFontWeight)).tr(),
          ),
          backgroundColor: umryIntroduction
        ),
        IntroductionSliderItem(
          logo: _globalWidget.createIntroLogoWidget(context),
          title: const Text("signin.intro.three.title", style: TextStyle(
              color: urmyIntroductionTextColor,
              fontSize: urmyTitleFontSize,
              fontWeight: urmyTitleFontWeight),).tr(),
          subtitle: Padding(
            padding: const EdgeInsets.all(15.0),
            child: const Text("signin.intro.three.description", style: TextStyle(
                color: urmyIntroductionTextColor,
                fontSize: urmysubTitleFontSize,
                fontWeight: urmysubTitleFontWeight)).tr(),
          ),
          backgroundColor: umryIntroduction
        ),
      ],
    );
  }



  @override
  Widget build(BuildContext context) {
    ref.listen(signinStateProvider, (SignInState? previous, SignInState? next) {
      if(ref.read(appConfigProvider.notifier).state.buildFlavor == 'dev') {
        print("needProfileUpdate: ${next!.needprofileupdate}");
        print("autologin: ${next!.autoLogin}");
        print("authenticated: ${next!.authenticated}");
        print("uuid: ${next!.uuid}");
      }

    });

    return Scaffold(
        body: _globalWidget.customConsumerWidget(
            buildBody(ref.watch(signinStateProvider))
        ),
    );
  }
}
