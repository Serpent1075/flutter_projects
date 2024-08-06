import 'package:csc_picker/csc_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/provider/providers.dart';
import 'package:urmytalk/widgets/wigets.dart';
import 'dart:io';

class UrMyTalkUpdateResidenceProfilePage extends ConsumerStatefulWidget {
  static const String routeName = '/urmyupdateresidenceprofilepage';

  const UrMyTalkUpdateResidenceProfilePage({Key? key}) : super(key: key);
  //const UrMyRegisterPage({Key key}) : super(key: key);

  @override
  ConsumerState<UrMyTalkUpdateResidenceProfilePage> createState() => _UrMyTalkUpdateResidenceProfilePageState();
}

class _UrMyTalkUpdateResidenceProfilePageState extends ConsumerState<UrMyTalkUpdateResidenceProfilePage> {
  late String countryValue = "";
  late String stateValue = "";
  late String cityValue = "";


  final GlobalKey<FormState> _updateCountryFormkey = GlobalKey<FormState>();
  final _globalWidget = GlobalWidget();
  GlobalKey<CSCPickerState> _cscPickerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void submit() {

    ref.read(signinProvider.notifier).updateProfile("country", countryValue +","+stateValue+","+cityValue);
  }

  Widget buildBody(SignInState signInState) {
    return Form(
        key: _updateCountryFormkey,
        child: _globalWidget.createBackground(context, formListview(context, signInState))
    );
  }

  ListView formListview(BuildContext context, SignInState signInState) {
    return ListView(
      children: <Widget>[
        // create form login
        _globalWidget.createCard(context, urmyupdate_residenceWidget(signInState)),
        // create sign up link
      ],
    );
  }

  Widget urmyupdate_residenceWidget(SignInState signInState) {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: urmyTitlePadding,
        ),
        Center(
          child: const Text(
            'profile.update.residence.title',
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
            'profile.update.residence.residenceinput',
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
        CSCPicker(
          key: _cscPickerKey,
          ///Enable disable state dropdown [OPTIONAL PARAMETER]
          showStates: true,

          /// Enable disable city drop down [OPTIONAL PARAMETER]
          showCities: true,

          ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
          flagState: CountryFlag.ENABLE,

          ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
          dropdownDecoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Colors.white,
              border:
              Border.all(color: urmyUnderlineActiveColor, width: 1)),

          ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
          disabledDropdownDecoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Colors.grey.shade300,
              border:
              Border.all(color: urmyUnderlineInActiveColor, width: 1)),

          ///placeholders for dropdown search field
          countrySearchPlaceholder: "Country",
          stateSearchPlaceholder: "State",
          citySearchPlaceholder: "City",

          ///labels for dropdown
          countryDropdownLabel: "*Country",
          stateDropdownLabel: "*State",
          cityDropdownLabel: "*City",

          ///Default Country
          //defaultCountry: DefaultCountry.India,

          ///Disable country dropdown (Note: use it with default country)
          //disableCountry: true,

          ///selected item style [OPTIONAL PARAMETER]
          selectedItemStyle: const TextStyle(
            fontSize: urmyContentFontSize,
            fontWeight: urmyContentFontWeight,
            color: urmyTextColor,
          ),

          ///DropdownDialog Heading style [OPTIONAL PARAMETER]
          dropdownHeadingStyle: const TextStyle(
              fontSize: urmyContentFontSize,
              fontWeight: urmyContentFontWeight,
              color: urmyTextColor),

          ///DropdownDialog Item style [OPTIONAL PARAMETER]
          dropdownItemStyle: const TextStyle(
              fontSize: urmyContentFontSize,
              fontWeight: urmyContentFontWeight,
              color: urmyTextColor
          ),

          ///Dialog box radius [OPTIONAL PARAMETER]
          dropdownDialogRadius: 10.0,

          ///Search bar radius [OPTIONAL PARAMETER]
          searchBarRadius: 10.0,

          ///triggers once country selected in dropdown
          onCountryChanged: (value) {
            setState(() {
              ///store value in country variable
              countryValue = value.toString().substring(6).trim();
            });
          },

          ///triggers once state selected in dropdown
          onStateChanged: (value) {
            setState(() {
              ///store value in state variable
              if (value != null){
                stateValue = value;
              }

            });
          },

          ///triggers once city selected in dropdown
          onCityChanged: (value) {
            setState(() {
              ///store value in city variable
              if (value != null) {
                cityValue = value;
              }

            });
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
                final form = _updateCountryFormkey.currentState;
                if (!form!.validate()) return;
                form.save();
                if (countryValue.isEmpty) {
                  countryValue = "none";
                }
                if (stateValue.isEmpty) {
                  stateValue = "none";
                }
                if (cityValue.isEmpty) {
                  cityValue = "none";
                }
                submit();
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: const Text(
                  'profile.update.residence.submitbutton',
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
    return  AnnotatedRegion<SystemUiOverlayStyle>(
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