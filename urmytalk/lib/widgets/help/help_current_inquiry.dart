import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/widgets/wigets.dart';
import 'package:urmytalk/provider/providers.dart';



class UrMyTalkHelpCurrentInquiryPage extends ConsumerStatefulWidget {
  static const String routeName = '/urmyhelpcurrentinquiry';

  const UrMyTalkHelpCurrentInquiryPage({Key? key}) : super(key: key);
  //const UrMyRegisterPage({Key key}) : super(key: key);

  @override
  ConsumerState<UrMyTalkHelpCurrentInquiryPage> createState() => _UrMyTalkHelpCurrentInquiryPageState();
}

class _UrMyTalkHelpCurrentInquiryPageState extends ConsumerState<UrMyTalkHelpCurrentInquiryPage> {

  final _globalWidget = GlobalWidget();
  String contents = "";
  TextEditingController contentsController = TextEditingController();

  final GlobalKey<FormState> _helpFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    contentsController.addListener(() { });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    contentsController.dispose();
  }

  Widget buildBody(SignInState signInState) {
    return Form(
        key: _helpFormKey,
        child: _globalWidget.createBackground(context, formListview(context, signInState))
    );
  }

  ListView formListview(BuildContext context, SignInState signInState) {
    return ListView(
      children: <Widget>[
        // create form login

        _globalWidget.createCard(context, urmy_inquiry(signInState)),

      ],
    );
  }

  Widget urmy_inquiry(SignInState signInState) {
    Size size = MediaQuery.of(context).size;
    if (signInState.inquirycontentlist == null) {
      return Container();
    } else {
      return Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Center(
            child: Text(
              "${signInState.currentInquiry!.title}",
              style: const TextStyle(
                  color: urmyMainColor,
                  fontSize: urmyTitleFontSize,
                  fontWeight: urmyTitleFontWeight),
            ),
          ),
          const SizedBox(
            height: urmyTitlePadding,
          ),
          SizedBox(
            height: size.height/5,
            child: ListView.builder(
              itemCount: signInState.inquirycontentlist!.inquirycontentlist!.length,
              itemBuilder: (context, index) {
                return signInState.inquirycontentlist!.inquirycontentlist![index].managerid == signInState.uuid ?
                ListTile(
                  title: Text(
                    "${signInState.inquirycontentlist!.inquirycontentlist![index].contents}",
                    style: const TextStyle(
                        color: urmyTextColor,
                        fontSize: urmyContentFontSize,
                        fontWeight: urmyContentFontWeight
                    ),
                  ),
                  trailing:   Text("${signInState.inquirycontentlist!.inquirycontentlist![index].registereddate!.toString().substring(5,7)}/${signInState.inquirycontentlist!.inquirycontentlist![index].registereddate!.toString().substring(8,10)}/${signInState.inquirycontentlist!.inquirycontentlist![index].registereddate!.toString().substring(0,4)}\n${signInState.inquirycontentlist!.inquirycontentlist![index].registereddate!.toString().substring(11,13)}:${signInState.inquirycontentlist!.inquirycontentlist![index].registereddate!.toString().substring(14,16)}",
                    style: const TextStyle(
                        color: urmyTextColor,
                        fontSize: urmyTimeFontIze,
                        fontWeight: urmyContentFontWeight
                    ),
                  ),
                ) :
                ListTile(
                  title: Text(
                      "${signInState.inquirycontentlist!.inquirycontentlist![index].contents}",
                    style: const TextStyle(
                        color: urmySubTextTitleColor,
                        fontSize: urmyContentFontSize,
                        fontWeight: urmyContentFontWeight
                    ),
                  ),
                  trailing:   Text("${signInState.inquirycontentlist!.inquirycontentlist![index].registereddate!.toString().substring(5,7)}/${signInState.inquirycontentlist!.inquirycontentlist![index].registereddate!.toString().substring(8,10)}/${signInState.inquirycontentlist!.inquirycontentlist![index].registereddate!.toString().substring(0,4)}\n${signInState.inquirycontentlist!.inquirycontentlist![index].registereddate!.toString().substring(11,13)}:${signInState.inquirycontentlist!.inquirycontentlist![index].registereddate!.toString().substring(14,16)}",
                    style: const TextStyle(
                        color: urmySubTextTitleColor,
                        fontSize: urmyTimeFontIze,
                        fontWeight: urmyContentFontWeight
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: urmyParagraphPadding,
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              'help.currentinquiry.reply',
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
          Column(
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
                validator: (val) {
                  if (val == null || contentsController.text.isEmpty) {
                    return 'help.currentinquiry.needcontent'.tr();
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
                  final form = _helpFormKey.currentState;
                  if (form!.validate()) {
                    form.save();
                  }

                  if (contents != "") {
                    ref.read(signinProvider.notifier).sendInquiryContent(signInState.currentInquiry!.caseid!, base64.encode(utf8.encode(contents)));
                    Navigator.pop(context);
                  }

                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: const Text(
                    'help.currentinquiry.submit',
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

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _globalWidget.customConsumerWidget(
          buildBody(ref.watch(signinStateProvider))
      ),
    );
  }
}
