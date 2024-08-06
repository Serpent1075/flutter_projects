import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:universal_io/io.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:urmytalk/models/models.dart';
import 'package:urmytalk/provider/providers.dart';
import 'package:urmytalk/widgets/wigets.dart';

class UrMyTalkSignUpCountryPage extends ConsumerStatefulWidget {
  static const String routeName = '/urmyregisternbg';

  const UrMyTalkSignUpCountryPage({Key? key}) : super(key: key);

  @override
  ConsumerState<UrMyTalkSignUpCountryPage> createState() => _UrMyTalkSignUpCountryPageState();
}

class _UrMyTalkSignUpCountryPageState extends ConsumerState<UrMyTalkSignUpCountryPage> {
  final _globalWidget = GlobalWidget();
  final GlobalKey<FormState> _registerCountryFormKey = GlobalKey<FormState>();
  final GlobalKey countryIntrokey = GlobalKey();
  late TutorialCoachMark tutorialCoachMark;
  final ScrollController _countryscrollController = ScrollController();
  final ScrollController _cityscrollController = ScrollController();
  final TextEditingController _countrytextController = TextEditingController();
  final TextEditingController _citytextController = TextEditingController();
  final _countryDropDownProgKey = GlobalKey<DropdownSearchState<Country>>();
  final _cityDropDownProgKey = GlobalKey<DropdownSearchState<City>>();
  Country? _country;
  List<City>? _listcity= [];
  City? _city;
  bool _countryselected = false;
  static const int maxindex=6;
  static const int currentindex=5;

  @override
  void initState() {
    ref.read(signupProvider.notifier).readCountryJson();
    createTutorial();
    _countryscrollController.addListener(() { });
    _cityscrollController.addListener(() { });
    _countrytextController.addListener(() { });
    _citytextController.addListener(() { });
    super.initState();

  }

  @override
  void dispose() {
    _countryscrollController.dispose();
    _cityscrollController.dispose();
    _countrytextController.dispose();
    _citytextController.dispose();
    super.dispose();
  }

  Widget buildBody(SignUpState signupState) {

    return Form(
        key: _registerCountryFormKey,
        child: _globalWidget.createBackground(
            context, formListview(context, signupState)));
  }

  ListView formListview(BuildContext context, SignUpState signupState) {
    return ListView(
      children: <Widget>[

        _globalWidget.createCard(context, urmysignup_countryWidget(signupState)),
        // create sign up link
      ],
    );
  }

  Widget urmysignup_countryWidget(SignUpState signupState) {
    if (signupState.listcountry == null) {
      return const Center( child: CircularProgressIndicator());
    }
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
                'signup.country.title',
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
                'signup.country.subtitle',
                style: TextStyle(
                    color: urmyLabelColor,
                    fontWeight: urmysubTitleFontWeight,
                    fontSize: urmysubTitleFontSize
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
          key: countryIntrokey,
          children: [
            DropdownSearch<Country>(
              key: _countryDropDownProgKey,
              popupProps: PopupProps.menu(
                  showSearchBox: true,
                  searchFieldProps: TextFieldProps(
                    enabled: true,
                    showCursor: true,
                    controller: _countrytextController,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(
                        fontWeight: urmyContentFontWeight,
                        fontSize: urmyContentFontSize,
                        color: urmyTextColor,
                      ),
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: urmyUnderlineInActiveColor)),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: urmyUnderlineActiveColor),
                      ),

                      hintText: "signup.country.countrysearchdescription".tr(),
                    ),
                  ),
                  listViewProps: ListViewProps(
                    reverse: false,
                    scrollDirection: Axis.vertical,
                    controller: _countryscrollController,
                  ),
                  fit: FlexFit.tight
              ),
              items: signupState.listcountry!.map((Country country) {
                return country;
              }).toList(),
              enabled: true,
              dropdownButtonProps: const DropdownButtonProps(
                icon: Icon(Icons.arrow_drop_down, color: urmyIconColor, size: urmyIconSize),
                isVisible: true,
              ),
              clearButtonProps: const ClearButtonProps(
                isVisible: false,
              ),
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelStyle: const TextStyle(
                    fontWeight: urmyContentFontWeight,
                    fontSize: urmyContentFontSize,
                    color: urmyTextColor,
                  ),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: urmyUnderlineInActiveColor)),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: urmyUnderlineActiveColor),
                  ),
                  labelText: "signup.country.countrysearch".tr(),
                ),
                baseStyle : const TextStyle(fontSize: urmyContentFontSize, fontWeight: urmyContentFontWeight, color: urmyTextColor),
                textAlign : TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
              ),
              filterFn: (Country? country,String? filter) => country!.countryFilterByName(filter)!,
              //onFind: (String? filter) => getCountryData(filter, signupState),
              itemAsString: (Country? country) => country!.countryAsString(),
              onChanged: (Country? data) {
                setState(() {
                  if(_countrytextController.text != "") {
                    _countrytextController.text[0].toUpperCase();
                    if(_countrytextController.text.indexOf(" ")+1 != _countrytextController.text.length) {
                      _countrytextController.text[_countrytextController.text.indexOf(" ")+1].toUpperCase();
                    }
                  }
                  _country = data;
                  _listcity = data!.city;
                  _city = null;
                  _citytextController.clear();
                  _countryselected = true;
                });
              },
            ),
            const SizedBox(
              height: urmyDefaultPadding,
            ),
            DropdownSearch<City>(
              key: _cityDropDownProgKey,
              popupProps: PopupProps.menu(
                  showSearchBox: _countryselected,
                  searchFieldProps: TextFieldProps(
                    enabled: _countryselected,
                    showCursor: _countryselected,
                    controller: _citytextController,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelStyle: const TextStyle(
                          fontSize: urmyContentFontSize,
                          fontWeight: urmyContentFontWeight,
                          color: urmyTextColor,
                        ),
                        focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: urmyUnderlineInActiveColor)),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: urmyUnderlineActiveColor),
                        ),

                        hintText: "signup.country.citysearchdescription".tr(),
                        suffixIcon: const Icon(Icons.arrow_drop_down, color: urmyIconColor, size: urmyIconSize)
                    ),
                  ),
                  listViewProps: ListViewProps(
                    controller: _cityscrollController,
                    shrinkWrap: true,
                    dragStartBehavior: DragStartBehavior.start,
                  ),
                  fit: FlexFit.tight
              ),
              items: _listcity!,
              enabled: _countryselected,
              dropdownButtonProps: const DropdownButtonProps(
                icon: Icon(Icons.arrow_drop_down, color: urmyIconColor, size: urmyIconSize),
                isVisible: true,
              ),
              clearButtonProps: const ClearButtonProps(
                isVisible: false,
              ),
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelStyle: const TextStyle(
                    fontWeight: urmyContentFontWeight,
                    fontSize: urmyContentFontSize,
                    color: urmyTextColor,
                  ),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: urmyUnderlineInActiveColor)),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: urmyUnderlineActiveColor),
                  ),
                  labelText: "signup.country.citysearch".tr(),
                ),
                baseStyle : const TextStyle(fontSize: urmyContentFontSize, fontWeight: urmyContentFontWeight, color: urmyTextColor),
                textAlign : TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
              ),
              filterFn: (City? city,String? filter) => city!.cityFilterByName(filter),
              //onFind: (String? filter) => getCityData(filter),
              itemAsString: (City? city) => "${city!.cityAsString()}  ${city.gmt!}",
              onChanged: (City? data) {
                setState(() {
                  _city = data;
                });
              },
            ),
          ],
        ),

        const SizedBox(
          height: urmyDefaultPadding,
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: const Text(
            'signup.country.cwarningmsg',
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
                final form = _registerCountryFormKey.currentState;
                if (form!.validate()) {
                  form.save();
                }
                if (_country == null || _city == null) {
                  _globalWidget.showNormalDialog(context, "signup.country.dialogtitle".tr(), "signup.country.dialogmsg".tr());
                } else {
                  _registerCountry();
                  Navigator.pushNamed(
                      context,
                      UrMyTalkSignUpMGPage.routeName);
                }

              },
              child:  Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: const Text(
                  'signup.nextbutton',
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


  Future showActionDialog(BuildContext context, String title, String content){
    return showDialog(context: context, builder: (BuildContext context) {
      return  AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: const Text('global.confirm').tr(),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    });
  }


  void _registerCountry() {
    //setState(() => _autovalidateMode = AutovalidateMode.always);
    final form = _registerCountryFormKey.currentState;
    if (!form!.validate()) {
      return;
    }
    form.save();
    if(ref.read(appConfigProvider.notifier).state.buildFlavor == 'dev') {
        print("Country: ${ref.read(signupProvider.notifier).state.country}");
        print("City: ${ref.read(signupProvider.notifier).state.city}");
    }
    ref
        .read(signupProvider.notifier)
        .SignUpCountry(_country!.countryname!, _city!.cityname!);
  }



  Widget build(BuildContext context) {

    if(ref.read(appConfigProvider.notifier).state.buildFlavor == 'dev') {

    }
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
      identify: "Target Country",
      keyTarget: countryIntrokey,
      targetPosition: TargetPosition(const Size(100,100), const Offset(50, 50)),
      contents: [
        TargetContent(
          align: ContentAlign.top,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              const Text(
                "signup.country.dialogmsg",
                style: TextStyle(color: Colors.white),
              ).tr(),
            ],
          ),
        ),
        TargetContent(
            align: ContentAlign.bottom,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  "signup.country.dialogmsgbottom",
                  style: TextStyle(color: Colors.white),
                ).tr(),
              ],
            ))

      ],
      shape: ShapeLightFocus.Circle,
    ));

    return targets;
  }

/*
  Future<List<Country>> getCountryData(String? filter, SignUpState signupState) async {
    var filteredList = signupState.listcountry!
        .where(
            (country) => country!.countryname!.toLowerCase().contains(filter!.toLowerCase()))
        .toList();
    if (filteredList.isEmpty) {
      return signupState.listcountry!;
    } else {
      return filteredList;
    }
  }


  Future<List<City>> getCityData(String? filter) async {
    var filteredList = _listcity!
        .where(
            (city) => city!.cityname!.toLowerCase().contains(filter!.toLowerCase()))
        .toList();
    if (filteredList.isEmpty) {
      return _listcity!;
    } else {
      return filteredList;
    }
  }

  Widget CountryDropBox(SignUpState signupState){
    return DropdownButton(
      hint: const Text("Country"),
      items: signupState.listcountry!.map(
            (Country item) => DropdownMenuItem(
          child: Text(item.countryname!),
          value: item,
        ),
      ).toList(),
      onChanged: (Country? value) => setState(() {
        _country = value!;
        _countryselected = true;
      }),
      value: _country,
    );
  }

  Widget CityDropBox(SignUpState signupState){
    return DropdownButton(
      hint: const Text("City"),
      items: signupState.listcountry![signupState.listcountry!.indexOf(_country!)].city?.map(
            (City item) => DropdownMenuItem(
          child: Text(item.cityname!),
          value: item,
        ),
      ).toList(),
      onChanged: (City? value) => setState(() {
        _city = value!;
      }),
      value: _city,
    );
  }

*/
}
