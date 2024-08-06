import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:universal_io/io.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/widgets/wigets.dart';
import 'package:urmytalk/provider/providers.dart';



class UrMyTalkSignUpAgreementPage extends ConsumerStatefulWidget {
  static const String routeName = '/urmyregisteragreement';

  const UrMyTalkSignUpAgreementPage({Key? key}) : super(key: key);
  //const UrMyRegisterPage({Key key}) : super(key: key);

  @override
  ConsumerState<UrMyTalkSignUpAgreementPage> createState() => _UrMyTalkSignUpAgreementPageState();
}

class _UrMyTalkSignUpAgreementPageState extends ConsumerState<UrMyTalkSignUpAgreementPage> {


  static const int maxindex=6;
  static const int currentindex=2;
  final _globalWidget = GlobalWidget();


  final allowNotifications = AgreementNotificationSetting();
  final notifications = [
    AgreementNotificationSetting(value: false),
    AgreementNotificationSetting(value: false),
    AgreementNotificationSetting(value: false),
    AgreementNotificationSetting(value: false),
  ];
  double titleFontSize = 10;

  final List<bool> _isOpen = [false, false, false,false];
  final GlobalKey<FormState> _registerAgreementFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildBody(SignUpState signupState) {
    return Form(
            key: _registerAgreementFormKey,
            child: _globalWidget.createBackground(context, formListview(context, signupState))
    );
  }

  ListView formListview(BuildContext context, SignUpState signupState) {
    return ListView(
      children: <Widget>[
        // create form login

        _globalWidget.createCard(context, urmysignup_agreementWidget(signupState)),

      ],
    );
  }

  Widget urmysignup_agreementWidget(SignUpState signupState) {
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
                'signup.agree.title',
                style: TextStyle(
                    color: urmyMainColor,
                    fontSize: urmyTitleFontSize ,
                    fontWeight: urmyTitleFontWeight),
              ).tr(),
            ),
            _globalWidget.customIndex(context, maxindex,currentindex),
          ],
        ),

        const SizedBox(
          height: urmyTitlePadding,
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: const Text(
            'signup.agree.subtitle',
            style: TextStyle(
                color: urmyLabelColor,
                fontSize: urmysubTitleFontSize,
                fontWeight: urmysubTitleFontWeight
            ),
          ).tr(),
        ),
        const SizedBox(
          height: urmyParagraphPadding,
        ),
        Row(
          children: [
            buildToogleRoundCheckbox(allowNotifications),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: const Text("signup.agree.menutitle.agreeall"
                ,style: TextStyle(
                    color: urmyLabelColor,
                    fontSize: urmysubTitleFontSize ,
                    fontWeight: urmysubTitleFontWeight),
              ).tr(),
            )
          ],
        ),
        Row(
          children: [
            notifications.map(buildSingleRoundCheckbox).elementAt(0),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: const Text("signup.agree.menutitle.overage"
                ,style: TextStyle(
                    color: urmyLabelColor,
                    fontSize: urmyPolicyTitleFontSize,
                    fontWeight: urmysubTitleFontWeight),
              ).tr(),
            )
          ],
        ),

        Row(
          children: [
            notifications.map(buildSingleRoundCheckbox).elementAt(1),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: const Text("signup.agree.menutitle.privacy",style: TextStyle(
                  color: urmyLabelColor,
                  fontSize: urmyPolicyTitleFontSize,
                  fontWeight: urmysubTitleFontWeight),
              ).tr(),
            ),
            const Spacer(),
            GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: const Icon(
                    Icons.arrow_forward_ios,
                  color: urmyLabelColor,
                  size: urmyMenuTitleFontSize,
                ),
                onTap: (){
                  Navigator.pushNamed(context, UrMyTalkInformationDataPolicyPage.routeName);
                },
            )
          ],
        ),
        Row(
          children: [
            notifications.map(buildSingleRoundCheckbox).elementAt(2),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: const Text("signup.agree.menutitle.service"
                ,style: TextStyle(color: urmyLabelColor,
                    fontSize: urmyPolicyTitleFontSize ,
                    fontWeight: urmysubTitleFontWeight),
              ).tr(),
            ),
            const Spacer(),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: const Icon(
                Icons.arrow_forward_ios,
                color: urmyLabelColor,
                size: urmyMenuTitleFontSize,
              ),
              onTap: (){
                Navigator.pushNamed(context, UrMyTalkInformationServicePolicyPage.routeName);
              },
            )
          ],
        ),
        Row(
          children: [
            notifications.map(buildSingleRoundCheckbox).elementAt(3),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: const Text("signup.agree.menutitle.illigal"
                ,style: TextStyle(color: urmyLabelColor,
                    fontSize: urmyPolicyTitleFontSize,
                    fontWeight: urmysubTitleFontWeight),
              ).tr(),
            ),
            const Spacer(),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: const Icon(
                Icons.arrow_forward_ios,
                color: urmyLabelColor,
                size: urmyMenuTitleFontSize,
              ),
              onTap: (){
                Navigator.pushNamed(context, UrMyTalkInformationIllegalPolicyPage.routeName);
              },
            )
          ],
        ),
        /*
        ExpansionPanelList(
          children: [
            ExpansionPanel(
              isExpanded: _isOpen[0],
              headerBuilder: (context, isOpen){
                return Row(
                  children: [
                    notifications.map(buildSingleRoundCheckbox).elementAt(0),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: const Text("signup.agree.menutitle.overage"
                        ,style: TextStyle(
                            color: urmyLabelColor,
                            fontSize: urmyMenuTitleFontSize,
                            fontWeight: urmysubTitleFontWeight),
                      ).tr(),
                    )
                  ],
                );
              },
              body: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4.0,0,0,0),
                  child: const Text("signup.agree.content.overage"
                    ,style: TextStyle(
                        color: urmyAgreementFontColor,
                        fontSize: urmyContentFontSize ,
                        fontWeight: urmyContentFontWeight),
                  ).tr(),
                ),
              ),
            ),

            ExpansionPanel(
              isExpanded: _isOpen[1],
              headerBuilder: (context, isOpen){
                return Row(
                  children: [
                    notifications.map(buildSingleRoundCheckbox).elementAt(1),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: const Text("signup.agree.menutitle.privacy",style: TextStyle(
                            color: urmyLabelColor,
                            fontSize: urmyMenuTitleFontSize,
                            fontWeight: urmysubTitleFontWeight),
                      ).tr(),
                    )
                  ],
                );
              },
              body: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, UrMyTalkInformationDataPolicyPage.routeName);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4.0,0,0,0),
                    child: const Text("signup.agree.content.privacy",style: TextStyle(
                          color: urmyAgreementFontColor,
                          fontSize: urmyContentFontSize,
                          fontWeight: urmyContentFontWeight)
                      ,
                    ).tr(),
                  ),
                ),
              ),
            ),

            ExpansionPanel(
              isExpanded: _isOpen[2],
              headerBuilder: (context, isOpen){
                return Row(
                  children: [
                    notifications.map(buildSingleRoundCheckbox).elementAt(2),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: const Text("signup.agree.menutitle.service"
                        ,style: TextStyle(color: urmyLabelColor,
                            fontSize: urmyMenuTitleFontSize ,
                            fontWeight: urmysubTitleFontWeight),
                      ).tr(),
                    )
                  ],
                );
              },
              body: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, UrMyTalkInformationServicePolicyPage.routeName);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4.0,0,0,0),
                    child: const Text("signup.agree.content.service"
                      ,style: TextStyle(color: urmyAgreementFontColor,
                          fontSize: urmyContentFontSize,
                          fontWeight: urmyContentFontWeight),
                    ).tr(),
                  ),
                ),
              ),
            ),

            ExpansionPanel(
              isExpanded: _isOpen[3],
              headerBuilder: (context, isOpen){
                return Row(
                  children: [
                    notifications.map(buildSingleRoundCheckbox).elementAt(3),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: const Text("signup.agree.menutitle.illigal"
                        ,style: TextStyle(color: urmyLabelColor,
                            fontSize: urmyMenuTitleFontSize,
                            fontWeight: urmysubTitleFontWeight),
                      ).tr(),
                    )
                  ],
                );
              },
              body: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, UrMyTalkInformationIllegalPolicyPage.routeName);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4.0,0,0,0),
                    child: const Text("signup.agree.content.illigal"
                      ,style: TextStyle(color: urmyAgreementFontColor,
                          fontSize: urmyContentFontSize,
                          fontWeight: urmyContentFontWeight),
                    ).tr(),
                  ),
                ),
              ),
            ),

          ],
          expansionCallback: (i, isOpen) =>
              setState(() =>
              _isOpen[i] = !isOpen
              ),
        ),
         */
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
                final form = _registerAgreementFormKey.currentState;
                if (form!.validate()) {
                  form.save();
                }

                if ( !notifications[0].value || !notifications[1].value || !notifications[2].value || !notifications[3].value) {

                  _globalWidget.showNormalDialog(context, "signup.agree.dialogtitle".tr(), "signup.agree.dialogmsg".tr());

                } else {
                  _registerAgreement();
                  Navigator.pushNamed(context, UrMyTalkSignUpProfilePage.routeName);
                }

              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: const Text(
                  'signup.agree.agreebutton',
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

  Widget buildToogleRoundCheckbox(AgreementNotificationSetting notification) => buildRoundCheckbox(
      notification: notification,
      onClicked: () {
        final newValue = !notification.value;

        setState(() {
          allowNotifications.value = newValue;
          notifications.forEach((notification) {
            notification.value = newValue;
          });
        });
      }
  );

  Widget buildSingleRoundCheckbox(AgreementNotificationSetting notification) => buildRoundCheckbox(
      notification: notification,
      onClicked: () {
        setState(() {
          final newValue = !notification.value;
          notification.value = newValue;

          if (!newValue) {
            allowNotifications.value = false;
          } else {
            final allow =
            notifications.every((notification) => notification.value);
            allowNotifications.value = allow;
          }
        });
      }
  );

  Widget buildRoundCheckbox({
    required AgreementNotificationSetting notification,
    required VoidCallback onClicked,
  }) =>
      Checkbox(
        activeColor: urmyLabelColor,
        checkColor: urmyLogoColor,
        value: notification.value,
        onChanged: (value) => onClicked(),
      );



  void _registerAgreement() {
    //setState(() => _autovalidateMode = AutovalidateMode.always);
    final form = _registerAgreementFormKey.currentState;
    if (!form!.validate()) return;

    form.save();

    ref.read(signupProvider.notifier).signupAgreement(notifications[0].value, notifications[1].value, notifications[2].value, notifications[3].value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _globalWidget.customAppBar(context),
      body: _globalWidget.customConsumerWidget(
          buildBody(ref.watch(signupStateProvider))
      ),
    );
  }
}

class AgreementNotificationSetting {
  bool value;

  AgreementNotificationSetting({
    this.value = false,
  });
}