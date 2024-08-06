import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/widgets/wigets.dart';
import 'package:urmytalk/provider/providers.dart';



class UrMyTalkHelpInquiryPage extends ConsumerStatefulWidget {
  static const String routeName = '/urmyhelpinquiry';

  const UrMyTalkHelpInquiryPage({Key? key}) : super(key: key);
  //const UrMyRegisterPage({Key key}) : super(key: key);

  @override
  ConsumerState<UrMyTalkHelpInquiryPage> createState() => _UrMyTalkHelpInquiryPageState();
}

class _UrMyTalkHelpInquiryPageState extends ConsumerState<UrMyTalkHelpInquiryPage> {

  final _globalWidget = GlobalWidget();
  String title = "", contents = "";
  List<String> inquirytype = ["uncomfortable", "billing", "tech", "etc"];
  String dropdownValue = "uncomfortable";
  TextEditingController titleController = TextEditingController();
  TextEditingController contentsController = TextEditingController();

  final GlobalKey<FormState> _helpFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
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
    return Column(
      children: [
        const SizedBox(
          height: 40,
        ),
        Center(
          child: const Text(
            'help.inquiry.title',
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
            'help.inquiry.inquirytype',
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
          isExpanded: true,
          value: dropdownValue,
          icon: const Padding(
              padding: EdgeInsets.all(2),
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
            return inquirytype.map<Widget>((e){
              switch (dropdownValue) {
                case "uncomfortable":
                  return SafeArea(
                      left: true,
                      right: true,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(urmyParagraphPadding,15.0,0.0,0.0),
                        child: Column(children: [
                          const Text("help.inquiry.uncomfortable", style: TextStyle(color: urmyLabelColor,
                              fontSize: urmyMenuTitleFontSize,
                              fontWeight: urmysubTitleFontWeight),
                          ).tr()
                        ],),
                      ));
                case "billing":
                  return SafeArea(
                      left: true,
                      right: true,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(urmyParagraphPadding,15.0,0.0,0.0),
                        child: Column(children: [
                          const Text("help.inquiry.billing", style: TextStyle(color: urmyLabelColor,
                              fontSize: urmyMenuTitleFontSize,
                              fontWeight: urmysubTitleFontWeight),
                          ).tr()
                        ],),
                      ));
                case "tech":
                  return SafeArea(
                      left: true,
                      right: true,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(urmyParagraphPadding,15.0,0.0,0.0),
                        child: Column(children: [
                          const Text("help.inquiry.tech", style: TextStyle(color: urmyLabelColor,
                              fontSize: urmyMenuTitleFontSize,
                              fontWeight: urmysubTitleFontWeight),
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
                          const Text("help.inquiry.etc", style: TextStyle(color: urmyLabelColor,
                              fontSize: urmyMenuTitleFontSize,
                              fontWeight: urmysubTitleFontWeight),
                          ).tr()
                        ],),
                      ));
              }
            }).toList();
          },
          items:
          inquirytype.map<DropdownMenuItem<String>>((String value) {
            switch (value) {
              case "uncomfortable":
                return DropdownMenuItem<String>(
                  value: value,
                  child: const Text("help.inquiry.uncomfortable").tr(),
                );
              case "billing":
                return DropdownMenuItem<String>(
                  value: value,
                  child: const Text("help.inquiry.billing").tr(),
                );
              case "tech":
                return DropdownMenuItem<String>(
                  value: value,
                  child: const Text("help.inquiry.tech").tr(),
                );
              default:
                return DropdownMenuItem<String>(
                  value: value,
                  child: const Text("help.inquiry.etc").tr(),
                );
            }

          }).toList(),
        ),
        const SizedBox(
          height: urmyParagraphPadding,
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: const Text(
            'help.inquiry.inquirytitle',
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
        TextFormField(
          cursorColor: urmyLabelColor,
          keyboardType: TextInputType.name,
          controller: titleController,
          decoration: const InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: urmyUnderlineInActiveColor)),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: urmyUnderlineActiveColor),
            ),
          ),
          onSaved: (val) {
            title = titleController.text;
          },
          validator: (val) {
            if (val == null || contentsController.text.isEmpty) {
              return 'help.inquiry.needtitle'.tr();
            }
          },
        ),

        const SizedBox(
          height: urmyParagraphPadding,
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: const Text(
            'help.inquiry.inquirycontent',
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

                if (title != "" && contents != "") {
                  ref.read(signinProvider.notifier).sendInquiry(dropdownValue, base64.encode(utf8.encode(title)), base64.encode(utf8.encode(contents)));
                  Navigator.pop(context);
                }

              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: const Text(
                  'help.inquiry.submit',
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
    return Scaffold(
      appBar: _globalWidget.globalCustomAppBar(context),
      body: _globalWidget.customConsumerWidget(
          buildBody(ref.watch(signinStateProvider))
      ),
    );
  }
}
