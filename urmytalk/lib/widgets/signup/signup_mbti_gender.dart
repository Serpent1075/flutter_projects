import 'package:csc_picker/csc_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_io/io.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:urmytalk/provider/providers.dart';
import 'package:urmytalk/widgets/wigets.dart';
import 'package:urmytalk/widgets/signin/signin.dart';

class UrMyTalkSignUpMGPage extends ConsumerStatefulWidget {
  static const String routeName = '/urmyregistermbtigender';

  const UrMyTalkSignUpMGPage({Key? key}) : super(key: key);

  @override
  ConsumerState<UrMyTalkSignUpMGPage> createState() => _UrMyTalkSignUpMGPageState();
}

class _UrMyTalkSignUpMGPageState extends ConsumerState<UrMyTalkSignUpMGPage> {
  late bool gender;
  final isSelected = <bool>[false, false];
  final GlobalKey<FormState> _registerMGFormKey = GlobalKey<FormState>();
  final _globalWidget = GlobalWidget();
  final GlobalKey mgIntrokey = GlobalKey();
  late TutorialCoachMark tutorialCoachMark;
  static const int maxindex=6;
  static const int currentindex=6;
  List<String> mbtilist = <String>['NONE','ENTJ', 'ENTP', 'ENFJ', 'ENFP', 'ESTJ','ESTP', 'ESFJ', 'ESFP', 'INTJ', 'INTP', 'INFJ', 'INFP', 'ISTJ','ISTP', 'ISFJ', 'ISFP'];
  late String dropdownValue;


  @override
  void initState() {
    createTutorial();
    dropdownValue = mbtilist[0];
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  Widget buildBody(SignUpState signupState) {
    if (signupState.registering) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Form(
        key: _registerMGFormKey,
        child: _globalWidget.createBackground(context, formListview(context, signupState))
    );
  }

  ListView formListview(BuildContext context, SignUpState signupState) {
    return ListView(
      children: <Widget>[

        // create form login
        _globalWidget.createCard(context, urmysignup_nbgtWidget(signupState)),
        const SizedBox(
          height: 50,
        ),
        // create sign up link
      ],
    );
  }

  Widget urmysignup_nbgtWidget(SignUpState signupState) {
    return Column(

      children: <Widget>[
        const SizedBox(
          height: urmyTitlePadding,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: const Text(
                'signup.mg.title',
                style: TextStyle(
                    color: urmyMainColor,
                    fontSize: urmyTitleFontSize,
                    fontWeight: urmyTitleFontWeight),
              ).tr(),
            ),
            _globalWidget.customIndex(context, maxindex,currentindex),
          ],
        ),

        const SizedBox(
          height: urmyTitlePadding,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                'signup.mg.gsubtitle',
                style: TextStyle(
                    color: urmyLabelColor, fontSize: urmysubTitleFontSize,
                    fontWeight: urmysubTitleFontWeight),
              ).tr(),
            ),
            IconButton(
              icon: const Icon(
                Icons.help,
                color: urmyIconColor,
              ),
              onPressed: () {
                showTutorial();
              },
            ),
          ],
        ),
        const SizedBox(
          height: urmyDefaultPadding,
        ),
        Column(
          key: mgIntrokey,
          children: [
            ToggleButtons(
            color: Colors.black.withOpacity(0.60),
            selectedColor: urmyUnderlineActiveColor,
            selectedBorderColor: urmyUnderlineActiveColor,
            fillColor: urmyUnderlineActiveColor.withOpacity(0.08),
            splashColor: urmyUnderlineActiveColor.withOpacity(0.12),
            hoverColor: urmyUnderlineActiveColor.withOpacity(0.04),
            borderRadius: BorderRadius.circular(4.0),
            constraints: const BoxConstraints(minHeight: 36.0),
            isSelected: isSelected,
            onPressed: (index) {
              // Respond to button selection
              setState(() {
                isSelected[index] = !isSelected[index];
                if (index == 0) {
                  if (isSelected[1]) {
                    isSelected[1] = !isSelected[1];
                  }
                  gender = true;
                } else {
                  if (isSelected[0]) {
                    isSelected[0] = !isSelected[0];
                  }
                  gender = false;
                }
              });
            },
            children: [
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16.0),
                child: const Text('signup.mg.gmale', style: TextStyle(
                    fontSize: urmyContentFontSize,
                    fontWeight: urmyContentFontWeight,
                    color: urmyTextColor
                )
                ).tr(),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16.0),
                child: const Text('signup.mg.gfemale', style: TextStyle(
                    fontSize: urmyContentFontSize,
                    fontWeight: urmyContentFontWeight,
                    color: urmyTextColor)
                ).tr(),
              )
            ],
          ),
            const SizedBox(
              height: urmyDefaultPadding,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                'signup.mg.gwarningmsg',
                style: TextStyle(
                    fontWeight: urmyContentFontWeight,
                    fontSize: urmyWarningFontSize ,
                    color: urmyTextColor),
              ).tr(),
            ),
          ],
        ),

        const SizedBox(
          height: urmyDefaultPadding,
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: const Text(
            'signup.mg.msubtitle',
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
        DropdownButton<String>(
          value: dropdownValue,
          icon: const Icon(Icons.arrow_downward),
          iconSize: urmyIconSize,
          elevation: 16,
          style: const TextStyle(color: urmyTextColor),
          underline: Container(
            height: 2,
            color: urmyLabelColor,
          ),
          onChanged: (newValue) {
            setState(() {
              dropdownValue = newValue!;
            });
          },
          items:
          mbtilist.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        const SizedBox(
          height: urmyParagraphPadding,
        ),

        SizedBox(
          width: double.maxFinite,
          child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty
                    .resolveWith<Color>(
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
                final form = _registerMGFormKey.currentState;
                if (form!.validate()) {
                  form.save();
                }
                if ((!isSelected[0] && !isSelected[1]) ||  dropdownValue.isEmpty) {
                  _globalWidget.showNormalDialog(context, "signup.mg.dialogtitle".tr(), "signup.mg.dialogmsg".tr());
                } else {
                    _registerMG();
                }
              },
              child:  Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: signupState.registering == true ? const CircularProgressIndicator() : const Text(
                  'signup.createbutton',
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

  void _registerMG() async {
    //setState(() => _autovalidateMode = AutovalidateMode.always);
    final form = _registerMGFormKey.currentState;
    if (!form!.validate()) {
      return;
    }
    form.save();
    ref.read(signupProvider.notifier).SignUpMG(gender, dropdownValue);
  }

  @override
  Widget build(BuildContext context) {
    final signupWatch = ref.watch(signupStateProvider);

    ref.listen(signupStateProvider, (SignUpState? previous, SignUpState? next) {
      if(ref.read(appConfigProvider.notifier).state.buildFlavor == 'dev') {
        print("Registering: ${signupWatch.registering}");
        print("Registered: ${signupWatch.registered}");
        print("Registerfailed: ${signupWatch.registerfailed}");
        print("Need Profile Update: ${ref.read(signinProvider.notifier).state.needprofileupdate}");
      }

      if(next!.registerfailed) {
        ref.read(signinProvider.notifier).setneedprofileupdate(20);
        Navigator.pushNamedAndRemoveUntil(context, UrMyTalkSignInPage.routeName, (Route<dynamic> route) => false);
      }
      if(next!.registered){
        ref.read(signinProvider.notifier).setneedprofileupdate(0);
        Navigator.pushNamedAndRemoveUntil(context, UrMyTalkSignInPage.routeName, (Route<dynamic> route) => false);
      }
    });

    return Scaffold(
      appBar: _globalWidget.customAppBar(context),
      body: _globalWidget.customConsumerWidget(
          buildBody(ref.watch(signupStateProvider))
      ),
    );
  }

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: urmyTutorialFocusColor,
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        //print("finish");
      },
      onClickTarget: (target) {
        //print('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        //print("target: $target");
        //print("clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        //print('onClickOverlay: $target');
      },
      onSkip: () {
        //print("skip");
      },
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(TargetFocus(
      identify: "Target Gender",
      keyTarget: mgIntrokey,
      targetPosition: TargetPosition(const Size(100,100), const Offset(50, 50)),
      contents: [
        TargetContent(
          align: ContentAlign.top,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              const Text(
                "signup.mg.dialogmsg",
                style: TextStyle(color: Colors.white),
              ).tr(),
            ],
          ),
        ),
        /*
        TargetContent(
            align: ContentAlign.bottom,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    "Multiples contents",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                ),
                Container(
                  child: Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ))

         */
      ],
      shape: ShapeLightFocus.Circle,
    ));

    return targets;
  }

}
