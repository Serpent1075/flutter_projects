import 'dart:math';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/provider/providers.dart';
import 'package:urmytalk/widgets/wigets.dart';

class UrMyTalkProfileSajuPage extends ConsumerStatefulWidget {
  static const String routeName = '/urmyprofilesajupage';

  const UrMyTalkProfileSajuPage({Key? key}) : super(key: key);
  //const UrMyRegisterPage({Key key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<UrMyTalkProfileSajuPage> createState() => _UrMyTalkProfileSajuPageState();
}

class _UrMyTalkProfileSajuPageState extends ConsumerState<UrMyTalkProfileSajuPage> {

  final GlobalKey<FormState> _updateUrDataFormkey = GlobalKey<FormState>();
  final _globalWidget = GlobalWidget();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
        _globalWidget.createCard(context, urmyprofile_sajuWidget(signInState)),
      ],
    );
  }

  // ignore: non_constant_identifier_names
  Widget urmyprofile_sajuWidget(SignInState signInState) {
    return Column(
      children: <Widget>[

      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    ref.listen(signinStateProvider, (SignInState? previous, SignInState? next) {

    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: _globalWidget.customConsumerWidget(
          buildBody(ref.watch(signinStateProvider))
      ),
    );
  }

}