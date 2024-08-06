import 'dart:math';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/provider/providers.dart';
import 'package:urmytalk/widgets/wigets.dart';

class UrMyTalkUpdateBirthdateProfilePage extends ConsumerStatefulWidget {
  static const String routeName = '/urmyupdatebirthdateprofilepage';

  const UrMyTalkUpdateBirthdateProfilePage({Key? key}) : super(key: key);
  //const UrMyRegisterPage({Key key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<UrMyTalkUpdateBirthdateProfilePage> createState() => _UrMyTalkUpdateBirthdateProfilePageState();
}

class _UrMyTalkUpdateBirthdateProfilePageState extends ConsumerState<UrMyTalkUpdateBirthdateProfilePage> {

  late String timeBirth ='', birthdate='';
  TextEditingController timeController = TextEditingController();
  bool _isChecked = false;

  final GlobalKey<FormState> _updateUrDataFormkey = GlobalKey<FormState>();
  final _globalWidget = GlobalWidget();

  timePicker() async {
    String hour, min;
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 0, minute: 0),
      initialEntryMode: TimePickerEntryMode.input,
      useRootNavigator: false,
      confirmText: "profile.update.birthdate.confirmtext".tr(),
      cancelText: "profile.update.birthdate.canceltext".tr(),
      helpText: "profile.update.birthdate.helptext".tr(),
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    timeController.dispose();
    super.dispose();
  }

  submit(String birthdate) {
    ref.read(signinProvider.notifier).updateProfile("birthdate", birthdate);
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
        _globalWidget.createCard(context, urmyupdate_birthdateWidget(signInState)),
       ],
    );
  }

  // ignore: non_constant_identifier_names
  Widget urmyupdate_birthdateWidget(SignInState signInState) {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: urmyTitlePadding,
        ),
        Center(
          child: const Text(
            'profile.update.birthdate.title',
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
            'profile.update.birthdate.subtitle',
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
                labelText: 'profile.update.birthdate.birthtime'.tr(),
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
                if (val == null || val.isEmpty) {
                  return 'profile.update.birthdate.birthtimeneccessary'.tr();
                }
                return null;
              },
            ),
          ),
        ),
        const SizedBox(
          height: urmyParagraphPadding,
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: const Text(
            'profile.update.birthdate.birthtimeneccessary',
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
                final form = _updateUrDataFormkey.currentState;
                if (!form!.validate()) return;
                form.save();

                if (timeBirth.isEmpty) {
                  _globalWidget.showNormalDialog(context, "profile.update.birthdate.dialogtitle".tr(), "profile.update.birthdate.dialogmsg".tr());
                }

                birthdate = "${signInState.birthdate.replaceAll(".", "-")} $timeBirth:00";
                submit(birthdate);
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: const Text(
                  'profile.update.birthdate.submitbutton',
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
    final signinWatch = ref.watch(signinStateProvider);
    if (signinWatch.profileupdateerr.isNotEmpty) {
      _globalWidget.showDialogWithFunc(context, 'profile.update.birthdate.toomanyerr'.tr(), ref.read(signinProvider.notifier).setErrorEmpty());
    } else if (signinWatch.error.isNotEmpty) {
      _globalWidget.showDialogWithFunc(context, 'profile.update.birthdate.err'.tr(), ref.read(signinProvider.notifier).setErrorEmpty());
    }
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