import 'dart:math';


import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:universal_io/io.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'package:urmytalk/provider/providers.dart';
import 'package:urmytalk/widgets/wigets.dart';

import '../../utils/utils.dart';

class UrMyTalkSignUpBirthDatePage extends ConsumerStatefulWidget {
  static const String routeName = '/urmyregisterbirthdate';

  const UrMyTalkSignUpBirthDatePage({Key? key}) : super(key: key);

  @override
  ConsumerState<UrMyTalkSignUpBirthDatePage> createState() => _UrMyTalkSignUpBirthdatePageState();
}

class _UrMyTalkSignUpBirthdatePageState extends ConsumerState<UrMyTalkSignUpBirthDatePage> {
  String yearMonthDay = '', timeBirth = '', birthdate = '';
  TextEditingController ymdController = TextEditingController();
  TextEditingController timeController = TextEditingController();


  static const int maxindex=6;
  static const int currentindex=4;
  final GlobalKey<FormState> _registerBirthdateFormKey = GlobalKey<FormState>();
  final GlobalKey birthdateIntrokey = GlobalKey();
  late TutorialCoachMark tutorialCoachMark;
  final _globalWidget = GlobalWidget();
  final bool _isChecked = false;

  @override
  void initState() {
    createTutorial();
    //Future.delayed(Duration.zero, showTutorial);
    super.initState();
  }

  @override
  void dispose() {
    ymdController.dispose();
    timeController.dispose();
    super.dispose();
  }

  yearMonthDayPicker() async {
    const year = 1951;

    final DateTime? dateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(year),
      lastDate: DateTime(DateTime.now().year + 1),
      initialDatePickerMode: DatePickerMode.year,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: urmyMainColor, // header background color
              onPrimary: urmyCardColor, // header text color
              onSurface: urmyLabelColor, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: urmyLabelColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (dateTime != null) {
      ymdController.text = dateTime.toString().split(' ')[0];
    }
  }

  timePicker() async {
    String hour, min;
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 0, minute: 0),
      initialEntryMode: TimePickerEntryMode.input,
      useRootNavigator: false,
      confirmText: "signup.birthdate.birthtimeconfirm".tr(),
      cancelText: "signup.birthdate.birthtimenotnow".tr(),
      helpText: "signup.birthdate.birthtimehelptext".tr(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
                primary: urmyMainColor, // header background color
                onPrimary: urmyCardColor, // header text color
                onSurface: urmyLabelColor,  // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: urmyMainColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      if (pickedTime.hour < 10) {
        hour = '0${pickedTime.hour}';
      } else {
        hour = pickedTime.hour.toString();
      }

      if (pickedTime.minute < 10) {
        min = '0${pickedTime.minute}';
      } else {
        min = pickedTime.minute.toString();
      }
      timeController.text = '$hour:$min';
    }
  }

  Widget buildBody(SignUpState signupState) {
    return Form(
        key: _registerBirthdateFormKey,
        child: _globalWidget.createBackground(context, formListview(context, signupState))
    );
  }

  ListView formListview(BuildContext context, SignUpState signupState) {
    return ListView(
      children: <Widget>[

        _globalWidget.createCard(context, urmysignup_birthdateWidget(signupState)),

        // create sign up link
      ],
    );
  }

  Widget urmysignup_birthdateWidget(SignUpState signupState) {
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
                'signup.birthdate.title',
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
                'signup.birthdate.subtitle',
                style: TextStyle(
                    color: urmyLabelColor,
                    fontSize: urmysubTitleFontSize,
                    fontWeight: urmysubTitleFontWeight
                ),
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
          key: birthdateIntrokey,
          children: [
            GestureDetector(
              onTap: yearMonthDayPicker,
              child: AbsorbPointer(
                child: TextFormField(
                  cursorColor: urmyLabelColor,
                  keyboardType: TextInputType.datetime,
                  controller: ymdController,
                  decoration: InputDecoration(
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: urmyUnderlineActiveColor)),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: urmyUnderlineActiveColor),
                    ),
                    labelText: 'signup.birthdate.birthday'.tr(),
                    labelStyle: const TextStyle(
                        fontWeight: urmyContentFontWeight,
                        fontSize: urmyContentFontSize ,
                        color: urmyTextColor),
                    border: const OutlineInputBorder(),
                    filled: true,
                  ),
                  onSaved: (val) {
                    yearMonthDay = ymdController.text;
                  },
                  validator: (val) {
                    if (val == null || ymdController.text.isEmpty) {
                      return 'signup.birthdate.birthdayneccessary'.tr();
                    }

                    if (int.parse(ymdController.text.substring(0,4)) < 1951) {
                      return 'signup.birthdate.birthdayoverage'.tr();
                    }

                    if (int.parse(ymdController.text.substring(0,4)) > DateTime.now().year - 19) {
                      return 'signup.birthdate.birthdayunderage'.tr();
                    }
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(
              height: urmyDefaultPadding,
            ),

            GestureDetector(
              onTap: timePicker,
              child: AbsorbPointer(
                child: TextFormField(
                  cursorColor: urmyLabelColor,
                  controller: timeController,
                  decoration: InputDecoration(
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: urmyUnderlineInActiveColor)),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: urmyUnderlineActiveColor),
                    ),
                    labelText: 'signup.birthdate.birthtime'.tr(),
                    labelStyle: const TextStyle(
                        fontWeight: urmysubTitleFontWeight,
                        fontSize: urmyContentFontSize ,
                        color: urmyTextColor),
                    border: const OutlineInputBorder(),
                    filled: true,
                  ),
                  onSaved: (val) {
                    timeBirth = timeController.text;
                  },
                  validator: (val) {
                    if ((val == null || val.isEmpty) && _isChecked == false) {
                      return 'signup.birthdate.birthtimeneccessary'.tr();
                    }
                    return null;
                  },
                ),
              ),
            ),
          ],
        ),

        const SizedBox(
          height: urmyDefaultPadding,
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: const Text(
            'signup.birthdate.bwarningmsg',
            style: TextStyle(
                fontWeight: urmyContentFontWeight,
                fontSize: urmyWarningFontSize ,
                color: urmyTextColor),
          ).tr(),
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
                final form = _registerBirthdateFormKey.currentState;
                if (form!.validate()) {
                  form.save();
                }

                if (yearMonthDay.isEmpty || (timeBirth.isEmpty && !_isChecked)) {
                 _globalWidget.showNormalDialog(context, "signup.birthdate.dialogtitle".tr(), "signup.birthdate.dialogmsg".tr());
                } else if (int.parse(yearMonthDay.substring(0,4)) < 1951) {
                  _globalWidget.showNormalDialog(context, "signup.birthdate.dialogtitle".tr(), "signup.birthdate.birthdayoverage".tr());
                } else if (int.parse(yearMonthDay.substring(0,4)) > DateTime.now().year - 19) {
                  _globalWidget.showNormalDialog(context, "signup.birthdate.dialogtitle".tr(), "signup.birthdate.birthdayunderage".tr());
                } else {
                  _registerBirthdate();
                  Navigator.pushNamed(context, UrMyTalkSignUpCountryPage.routeName);
                }
              },
              child:  Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: const Text(
                  'signup.nextbutton',
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

  void _registerBirthdate() async {
    if (_isChecked) {
      int maxhour = 23;
      int maxmin = 59;
      int rndhour = Random().nextInt(maxhour);
      int rndmin = Random().nextInt(maxmin);
      String tmpbirthtime;
      if (rndhour < 10) {
        tmpbirthtime = "0$rndhour:";
      } else {
        tmpbirthtime = "$rndhour:";
      }

      if (rndmin < 10) {
        tmpbirthtime += "0$rndmin:00";
      } else {
        tmpbirthtime += "$rndmin:00";
      }

      birthdate = "$yearMonthDay $tmpbirthtime";
    } else {
      birthdate = "$yearMonthDay $timeBirth:00";
    }
    ref.read(signupProvider.notifier).SignUpBirthdate(birthdate);
  }

  Widget build(BuildContext context) {
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
      identify: "Target Birthdate",
      keyTarget: birthdateIntrokey,
      targetPosition: TargetPosition(const Size(100,100), const Offset(50, 50)),
      contents: [
        TargetContent(
          align: ContentAlign.top,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                "signup.birthdate.dialogmsg",
                style: TextStyle(color: Colors.white),
              ).tr(),
            ],
          ),
        ),
      ],
      shape: ShapeLightFocus.Circle,
    ));

    return targets;
  }
}
