import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/provider/providers.dart';
import 'package:urmytalk/widgets/wigets.dart';
import 'dart:io';

class UrMyTalkUpdateMBTIProfilePage extends ConsumerStatefulWidget {
  static const String routeName = '/urmyupdatembtiprofilepage';

  const UrMyTalkUpdateMBTIProfilePage({Key? key}) : super(key: key);
  //const UrMyRegisterPage({Key key}) : super(key: key);

  @override
  ConsumerState<UrMyTalkUpdateMBTIProfilePage> createState() => _UrMyTalkUpdateMBTIProfilePageState();
}

class _UrMyTalkUpdateMBTIProfilePageState extends ConsumerState<UrMyTalkUpdateMBTIProfilePage> {

  final GlobalKey<FormState> _updateMBTIFormkey = GlobalKey<FormState>();
  final _globalWidget = GlobalWidget();
  String dropdownValue = 'ENTJ';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void submit() {
    final form1 = _updateMBTIFormkey.currentState;
    if (!form1!.validate()) return;
    form1.save();
    ref.read(signinProvider.notifier).updateProfile("mbti", dropdownValue);
  }

  Widget buildBody(SignInState signInState) {
    return Form(
        key: _updateMBTIFormkey,
        child: _globalWidget.createBackground(context, formListview(context, signInState))
    );
  }

  ListView formListview(BuildContext context, SignInState signInState) {
    return ListView(
      children: <Widget>[
        // create form login
        _globalWidget.createCard(context, urmyupdate_mbtiWidget(signInState)),
        const SizedBox(
          height: 50,
        ),
        // create sign up link

      ],
    );
  }

  Widget urmyupdate_mbtiWidget(SignInState signInState){
    return Column(
      children: <Widget>[
        const SizedBox(
          height: urmyTitlePadding,
        ),
        Center(
          child: const Text(
            'profile.update.mbti.title',
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
            'profile.update.mbti.mbtiinput',
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
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(   fontSize: urmyContentFontSize,
              fontWeight: urmyContentFontWeight,
              color: urmyTextColor),
          underline: Container(
            height: 2,
            color: urmyLabelColor,
          ),
          onChanged: (newValue) {
            dropdownValue = newValue!;
          },
          items: <String>['ENTJ', 'ENTP', 'ENFJ', 'ENFP', 'ESTJ','ESTP', 'ESFJ', 'ESFP', 'INTJ', 'INTP', 'INFJ', 'INFP', 'ISTJ','ISTP', 'ISFJ', 'ISFP']
              .map<DropdownMenuItem<String>>((String value) {
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
          child: ElevatedButton(
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
              child:  Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: const Text(
                  'profile.update.mbti.submitbutton',
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
      )
      ),
    );
  }

}