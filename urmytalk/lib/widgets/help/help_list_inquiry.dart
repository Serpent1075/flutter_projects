import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/widgets/help/help_current_inquiry.dart';
import 'package:urmytalk/widgets/wigets.dart';
import 'package:urmytalk/provider/providers.dart';



class UrMyTalkHelpInquiryListPage extends ConsumerStatefulWidget {
  static const String routeName = '/urmyhelpinquirylist';

  const UrMyTalkHelpInquiryListPage({Key? key}) : super(key: key);
  //const UrMyRegisterPage({Key key}) : super(key: key);

  @override
  ConsumerState<UrMyTalkHelpInquiryListPage> createState() => _UrMyTalkHelpInquiryListPageState();
}


class _UrMyTalkHelpInquiryListPageState extends ConsumerState<UrMyTalkHelpInquiryListPage> {
  final _globalWidget = GlobalWidget();

  @override
  void initState() {
    ref.read(signinProvider.notifier).getInquirylist();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildBody(SignInState signinState) {
    return getInquiryList(context, signinState);
  }

  Widget getInquiryList(BuildContext context, SignInState signinState) {
    if (signinState.inquirylist == null) {
      return Center(child: const Text('help.inquiry.noinquiry').tr());
    } else if (signinState.inquirylist!.inquirylist!.isEmpty) {
      return Center(child: const Text('help.inquiry.noinquiry').tr());
    } else {
      return ListView.builder(
        itemCount: signinState.inquirylist!.inquirylist!.length,
        itemBuilder: (context, index) {
          try{
            return GestureDetector(
              child: ListTile(
                title: Text("${signinState.inquirylist!.inquirylist![index].title}"),
                trailing:   Text("${signinState.inquirylist!.inquirylist![index].inquirystate}"),
                onTap: () {
                  ref.read(signinProvider.notifier).setCurrentInquiry(signinState.inquirylist!.inquirylist![index]);
                  ref.read(signinProvider.notifier).getInquiryContentlist(signinState.inquirylist!.inquirylist![index].caseid!);
                  Navigator.pushNamed(context, UrMyTalkHelpCurrentInquiryPage.routeName);
                },
              ),
            );
          } catch (e) {
            return Container();
          }

        },
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _globalWidget.globalAppBar("help.main.title".tr()),
      backgroundColor: Colors.white,
      body: _globalWidget.customConsumerWidget(
          buildBody(ref.watch(signinStateProvider))
      ),
    );
  }

}