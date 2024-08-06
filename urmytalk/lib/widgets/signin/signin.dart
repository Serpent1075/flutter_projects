import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'dart:io';
import 'package:universal_io/io.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/widgets/wigets.dart';
import 'package:urmytalk/provider/providers.dart';
import 'package:urmytalk/classes/urmytalk_classes.dart';


class UrMyTalkSignInPage extends ConsumerStatefulWidget {
  static const String routeName = '/login';

  const UrMyTalkSignInPage({Key? key}) : super(key: key);

  @override
  ConsumerState<UrMyTalkSignInPage> createState() => _UrMyTalkSignInPageState();
}

class _UrMyTalkSignInPageState extends ConsumerState<UrMyTalkSignInPage> {
  final formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _textenabled = true;
  IconData _iconVisible = Icons.visibility_off;
  List<String> reporttype = <String>["credential","illegal","hacking", "etc"];
  TextEditingController contentsController = TextEditingController();
  String dropdownValue = "credential";
  String contents = "";
  bool _normalinputenabled =false;
  int _normalinputcount = 0;
  final _globalWidget = GlobalWidget();
  late String _email;
  late String _password;
  final UrMyTalkAdManager urmytalkAdmanager = UrMyTalkAdManager();


  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
      if (_obscureText == true) {
        _iconVisible = Icons.visibility_off;
      } else {
        _iconVisible = Icons.visibility;
      }
    });
  }

  @override
  void initState() {
    ref.read(signinProvider.notifier).getCFurl();
    ref.read(signinProvider.notifier).checkAutologin();
    super.initState();
    try {
      urmytalkAdmanager.loadFullScreenAd();
    } catch (e) {

    }
  }

  @override
  void dispose() {
    urmytalkAdmanager.dispose();
    contentsController.dispose();
    super.dispose();
  }



  submit() {
    _textenabled = false;
    final form = formKey.currentState;
    if (!form!.validate()) return false;
    form.save();

    ref.read(signinProvider.notifier).normalsignin(_email, _password);
  }

  Widget buildBody(SignInState signinState) {

    return Form(
      key: formKey,
      child: _globalWidget.createBackground(context, formListview(context, signinState)),
    );
  }

  ListView formListview(BuildContext context, SignInState signinState) {
    return ListView(
      children: <Widget>[
        // create form login
        _globalWidget.createCard(context, urmyloginWidget(signinState)),
        const SizedBox(
          height: 50,
        ),
        // create sign up link
        outsideCard(),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget urmyssoWidget(SignInState signinState) {

      return  Column(
        children: [
          Platform.isIOS ? ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 50),
            ),
            icon: const FaIcon(FontAwesomeIcons.apple, color: Colors.white),
            label: ref.read(signinProvider.notifier).state.loggingIn ? const CircularProgressIndicator(): const Text("Apple Login", style: TextStyle(
                fontSize: urmysignInFontSize,
                fontWeight: urmysignInFontWeight),),
            onPressed: () async {
              ref.read(signinProvider.notifier).applesignin();
            },
          ) : ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.red,
              minimumSize: const Size(double.infinity, 50),
            ),
            icon: const FaIcon(FontAwesomeIcons.google, color: Colors.white),
            label: ref.read(signinProvider.notifier).state.loggingIn ? const CircularProgressIndicator(): const Text("Google Login"),
            onPressed: () async {
              ref.read(signinProvider.notifier).googlesignin();
            },
          ),
          const SizedBox(
            height: urmyParagraphPadding,
          ),

        ],
      );

  }

  Widget urmyloginWidget(SignInState signinState) {

    return Column(
      children: <Widget>[
        const SizedBox(
          height: 40,
        ),
        GestureDetector(
          child: Center(
            child: const Text(
              'signin.title',
              style: TextStyle(
                  color: urmyMainColor,
                  fontSize: urmyTitleFontSize,
                  fontWeight: urmyTitleFontWeight),
            ).tr(),
          ),
          onTap: () {
            if (_normalinputcount < 6) {
              _normalinputcount++;
            }
          },
          onLongPress: () {
            setState(() {
              _normalinputenabled = !_normalinputenabled;
            });
          },
        ),

        const SizedBox(
          height: urmyTitlePadding,
        ),
        urmyssoWidget(signinState),

        const SizedBox(
          height: urmyDefaultPadding,
        ),
        //Platform.isAndroid && _normalinputenabled && _normalinputcount == 6 ? commonLoginInput(signinState) : Container(),
        _normalinputenabled && _normalinputcount == 6 ? commonLoginInput(signinState) : Container(),
        //commonLoginInput(signinState)
      ],
    );
  }

  Widget commonLoginInput(SignInState signinState) {
    return Column(
      children: [
        TextFormField(
          enabled: _textenabled,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              focusedBorder: const UnderlineInputBorder(
                  borderSide:
                  BorderSide(color: urmyUnderlineInActiveColor)),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: urmyUnderlineActiveColor),
              ),
              labelText: 'signin.emailInput'.tr(),
              labelStyle: const TextStyle(color: urmyLabelColor)),
          onSaved: (value) => _email = value!,
        ),
        const SizedBox(
          height: urmyDefaultPadding,
        ),
        TextFormField(
          enabled: _textenabled,
          obscureText: _obscureText,
          decoration: InputDecoration(
            focusedBorder: const UnderlineInputBorder(
                borderSide:
                BorderSide(color: urmyUnderlineInActiveColor)),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: urmyUnderlineActiveColor),
            ),
            labelText: 'signin.passwordInput'.tr(),
            labelStyle: const TextStyle(color: urmyLabelColor),
            suffixIcon: IconButton(
                icon: Icon(_iconVisible, color: urmyIconColor, size: urmyIconSize),
                onPressed: () {
                  _toggleObscureText();
                }),
          ),
          onSaved: (value) => _password = value!,
        ),
        const SizedBox(
          height: urmyDefaultPadding,
        ),

        SizedBox(
          width: double.maxFinite,
          child: TextButton(
              style: _globalWidget.urmyButtonStyle(),
              onPressed: () async {
                submit();
              },
              child: Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 5),
                child: signinState
                    .loggingIn
                    ? _globalWidget.urmyButtonLoading()
                    : _globalWidget.urmyButtonText('signin.loginbutton'.tr()),
              )),
        ),
      ],
    );
  }

  Widget outsideCard() {
    return Column(
      children: [
        Center(
          child: Wrap(
            children: <Widget>[
              const Text('signin.forgotdesc',
                  style: TextStyle(
                      color: urmySubTextTitleColor,
                      fontWeight: urmySubTextTitleFontWeight,
                      fontSize: urmySubTextTitleFontSize
                  ),
              ).tr(),
              GestureDetector(
                onTap: () {
                  Fluttertoast.showToast(
                      msg: 'signin.forgtmsg',
                      toastLength: Toast.LENGTH_SHORT);
                  Navigator.pushNamed(
                      context, UrMyTalkForgotPasswordPage.routeName);
                },
                child: const Text(
                  'signin.forgotbutton',
                  style: TextStyle(
                      color: urmySubTextColor,
                      fontWeight: urmySubTextFontWeight,
                      fontSize: urmySubTextFontSize
                  ),
                ).tr(),
              )
            ],
          ),
        ),

        const SizedBox(
          height: urmyDefaultPadding,
        ),
        Center(
          child: Wrap(
            children: <Widget>[
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                child:  const Text('signin.datapolicy',
                  style: TextStyle(
                      color: urmySubTextTitleColor,
                      fontWeight: urmySubTextTitleFontWeight,
                      fontSize: urmySubTextTitleFontSize
                  ),
                ).tr(),
                onTap: (){
                  Navigator.pushNamed(context, UrMyTalkInformationDataPolicyPage.routeName);
                },
              )
            ],
          ),
        ),
        const SizedBox(
          height: urmyDefaultPadding,
        ),
        Center(
          child: Wrap(
            children: <Widget>[
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                child:  const Text('signin.servicepolicy',
                  style: TextStyle(
                      color: urmySubTextTitleColor,
                      fontWeight: urmySubTextTitleFontWeight,
                      fontSize: urmySubTextTitleFontSize
                  ),
                ).tr(),
                onTap: (){
                  Navigator.pushNamed(context, UrMyTalkInformationServicePolicyPage.routeName);
                },
              )
            ],
          ),
        ),
        const SizedBox(
          height: urmyDefaultPadding,
        ),
        Center(
          child: Wrap(
            children: <Widget>[
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                child:  const Text('signin.illegalpolicy',
                  style: TextStyle(
                      color: urmySubTextTitleColor,
                      fontWeight: urmySubTextTitleFontWeight,
                      fontSize: urmySubTextTitleFontSize
                  ),
                ).tr(),
                onTap: (){
                  Navigator.pushNamed(context, UrMyTalkInformationIllegalPolicyPage.routeName);
                },
              )
            ],
          ),
        ),
        const SizedBox(
          height: urmyDefaultPadding,
        ),
        Center(
          child: Wrap(
            children: <Widget>[
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                child:  const Text('signin.homepage',
                  style: TextStyle(
                      color: urmySubTextTitleColor,
                      fontWeight: urmySubTextTitleFontWeight,
                      fontSize: urmySubTextTitleFontSize
                  ),
                ).tr(),
                onTap: (){
                  Navigator.pushNamed(context, UrMyTalkInformationHomePage.routeName);
                },
              )
            ],
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {

    //final autologin = ref.watch(userautoLoginProvider);
    TargetPlatform os = Theme.of(context).platform;



    if(ref.read(appConfigProvider.notifier).state.buildFlavor == 'dev') {

    }

    ref.listen(signinStateProvider, (SignInState? previous, SignInState? next) {

      if(next!.needprofileupdate == 10 && next!.authenticated){
        try {
          urmytalkAdmanager.adManagerInterstitialAd!.show();
        } catch (e) {

        }
        Navigator.popAndPushNamed(context, UrMyTalkMainPage.routeName);
      } else if (next!.needprofileupdate == 20 && next!.authenticated) {
        Navigator.pushNamed(context, UrMyTalkSignUpAgreementPage.routeName);
      }

      if(next.error.isNotEmpty) {
        if (next.error == "wrongpassword") {

          _globalWidget.showDialogWithFunc(context, 'signin.wrongpass'.tr(), ref.read(signinProvider.notifier).setErrorEmpty());
        } else if (next.error == "toomanyattempt"){
          _globalWidget.showDialogWithFunc(context, 'signin.toomanyattempt'.tr(), ref.read(signinProvider.notifier).setErrorEmpty());
        }else {
          _globalWidget.showDialogWithFunc(context, next.error, ref.read(signinProvider.notifier).setErrorEmpty());
        }
        _textenabled = true;
      }

      if(next.pmerr == "pm-time") {
        Navigator.pushReplacementNamed(context, UrMyTalkErrorPage.routeName);
      }
    });

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: Platform.isIOS
            ? SystemUiOverlayStyle.light
            : const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light),
            child: buildBody(ref.watch(signinStateProvider)),/*autologin.when(
                data: ((data){
                  if (data) {
                    return const UrMyTalkMainPage();
                  } else {
                    return
                  }
                }),
                error: ((error, stackTrace) {
                  _globalWidget.showNormalDialog(context, "error", error.toString());
                  return buildBody(ref.watch(signinStateProvider));
                }),
                loading: ((){
                  return  const Center(child: CircularProgressIndicator(),);
                }))*/
        //buildBody(ref.watch(signinStateProvider)),
      ),
    );
  }
/*
  void _showPopup() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text("chatboard.report.reporttitle", style: TextStyle(color: urmyTextColor),).tr(),
            children: [
              DropdownButton<String>(
                isExpanded: true,
                value: dropdownValue,
                icon: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.arrow_downward)),
                iconEnabledColor: urmyIconColor,
                iconSize: urmyIconSize,
                elevation: 16,
                style: const TextStyle(color: urmyTextColor),
                underline: Container(
                  height: 0,
                ),
                onChanged: (newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                selectedItemBuilder: (context){
                  return reporttype.map<Widget>((e){
                    switch (dropdownValue) {
                      case "credential":
                        return SafeArea(
                            left: true,
                            right: true,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(urmyParagraphPadding,15.0,0.0,0.0),
                              child: Column(children: [
                                const Text("chatboard.report.reportcredential", style: TextStyle(color: urmyLabelColor,
                                    fontSize: urmyContentFontSize,
                                    fontWeight: urmyContentFontWeight),
                                ).tr()
                              ],),
                            ));
                      case "illegal":
                        return SafeArea(
                            left: true,
                            right: true,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(urmyParagraphPadding,15.0,0.0,0.0),
                              child: Column(children: [
                                const Text("chatboard.report.reportillegalfirm", style: TextStyle(color: urmyLabelColor,
                                    fontSize: urmyContentFontSize,
                                    fontWeight: urmyContentFontWeight),
                                ).tr()
                              ],),
                            ));

                      case "hacking":
                        return SafeArea(
                            left: true,
                            right: true,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(urmyParagraphPadding,15.0,0.0,0.0),
                              child: Column(children: [
                                const Text("chatboard.report.reporthacking", style: TextStyle(color: urmyLabelColor,
                                    fontSize: urmyContentFontSize,
                                    fontWeight: urmyContentFontWeight),
                                ).tr()
                              ],),
                            ));
                      default:
                        return SafeArea(
                            left: true,
                            right: true,

                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(urmyParagraphPadding,15.0,0.0,0.0),
                              child: Column(children: [
                                const Text("chatboard.report.reportetc", style: TextStyle(color: urmyLabelColor,
                                    fontSize: urmyContentFontSize,
                                    fontWeight: urmyContentFontWeight),
                                ).tr()
                              ],),
                            ));
                    }

                  }).toList();
                },
                items:
                reporttype.map<DropdownMenuItem<String>>((String value) {
                  switch (value) {
                    case "credential":
                      return DropdownMenuItem<String>(
                        value: value,
                        child: const Text("chatboard.report.reportcredential").tr(),
                      );
                    case "illegal":
                      return DropdownMenuItem<String>(
                        value: value,
                        child: const Text("chatboard.report.reportillegalfirm").tr(),
                      );
                    case "hacking":
                      return DropdownMenuItem<String>(
                        value: value,
                        child: const Text("chatboard.report.reporthacking").tr(),
                      );
                    default:
                      return DropdownMenuItem<String>(
                        value: value,
                        child: const Text("chatboard.report.reportetc").tr(),
                      );
                  }


                }).toList(),
              ),
              const SizedBox(
                height: urmyDialogPadding,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextFormField(
                      maxLines: 5,
                      cursorColor: urmyLabelColor,
                      keyboardType: TextInputType.name,
                      controller: contentsController,
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: urmyUnderlineInActiveColor)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: urmyUnderlineActiveColor),
                        ),
                      ),
                      onSaved: (val) {
                        contents = contentsController.text;
                      },
                      onChanged: (val) {
                        contents = contentsController.text;
                      },
                      validator: (val) {
                        if (val == null || contentsController.text.isEmpty) {
                          return 'help.inquiry.needcontent'.tr();
                        }
                        if (val.length > 150) {
                          return val.substring(0,150);
                        }
                      },
                    ),
                    Text("${contentsController.text.length}/150",
                      style: const TextStyle(
                          color: urmySubTextColor,
                          fontSize: urmySubTextFontSize,
                          fontWeight: urmySubTextFontWeight
                      ),)
                  ],
                ),
              ),
              const SizedBox(
                height: urmyDialogPadding,
              ),
              SimpleDialogOption(
                onPressed: () {
                  ref.read(signinProvider.notifier).sendchatreport(
                      base64.encode(utf8.encode(message)),
                      time,
                      dropdownValue,
                      base64.encode(utf8.encode(contentsController.text))
                  );
                  contentsController.clear();
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text('chatboard.reportsubmit',style: TextStyle(color: urmyLabelColor,
                          fontSize: urmyMenuTitleFontSize,
                          fontWeight: urmysubTitleFontWeight),).tr(),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
*/
}
