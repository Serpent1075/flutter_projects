import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_io/io.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'package:urmytalk/provider/providers.dart';
import 'package:urmytalk/widgets/wigets.dart';

class UrMyTalkSettingAgeFilterPage extends ConsumerStatefulWidget {
  static const String routeName = '/urmysettingsaveuserdatapage';

  const UrMyTalkSettingAgeFilterPage({Key? key}) : super(key: key);
  //const UrMyRegisterPage({Key key}) : super(key: key);

  @override
  ConsumerState<UrMyTalkSettingAgeFilterPage> createState() => _UrMyTalkSettingAgeFilterPageState();
}

class _UrMyTalkSettingAgeFilterPageState extends ConsumerState<UrMyTalkSettingAgeFilterPage> {

  final _globalWidget = GlobalWidget();

  SfRangeValues? _values;
  double? _minage;
  double? _maxage;
  final GlobalKey<FormState> _settingAgeFilterFormkey = GlobalKey<FormState>();

  @override
  void initState(){
    var birthyear = DateTime.now().year-int.parse(ref.read(signinProvider.notifier).state.birthdate.substring(0,4));
    _minage = birthyear - 12;
    _maxage = birthyear + 12;
    _values = SfRangeValues(ref.read(signinProvider.notifier).state.settings!.min.toDouble(), ref.read(signinProvider.notifier).state.settings!.max.toDouble());
    super.initState();
  }

  Widget buildBody(SignInState signInState) {

    return Form(
        key: _settingAgeFilterFormkey,
        child: _globalWidget.createBackground(context, formListview(context, signInState))
    );
  }


  ListView formListview(BuildContext context, SignInState signInState) {
    return ListView(
      children: <Widget>[
        // create form login
        _globalWidget.createCard(context, urmysetting_agefilterWidget(signInState)),
        const SizedBox(
          height: 50,
        ),
        // create sign up link
      ],
    );
  }

  Widget urmysetting_agefilterWidget(SignInState signInState) {


    return Column(
      children: [
        const SizedBox(
          height: 40,
        ),

        SfRangeSlider(
          activeColor: urmyAgeFilterBarColor,
          inactiveColor: urmyAgeFilterInActiveBarColor,
          min: _minage,
          max: _maxage,
          values: _values!,
          interval: 2,
          showTicks: true,
          showLabels: true,
          enableTooltip: true,
          tooltipTextFormatterCallback:
              (dynamic actualValue, String formattedText) {
            return actualValue.toStringAsFixed(0);
          },
          minorTicksPerInterval: 1,
          onChanged: (SfRangeValues values){
            setState(() {
              _values = values;
            });
          },
        ),
        const SizedBox(
          height: 100,
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
                double minage = _values!.start;
                double maxage = _values!.end;
                ref.read(signinProvider.notifier).updateAgeFilter(minage.toInt(), maxage.toInt());
                ref.read(candidateProvider.notifier).agefilter();
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ref.read(signinProvider.notifier).state.loggingIn
                    ? const SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                )
                    : const Text(
                  'setting.agefilter.submitbutton',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white
                  ),
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