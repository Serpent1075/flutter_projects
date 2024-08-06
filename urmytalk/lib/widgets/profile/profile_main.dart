import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:urmytalk/provider/providers.dart';
import 'package:urmytalk/widgets/wigets.dart';
import 'dart:io';

import '../../utils/utils.dart';

class UrMyTalkMainProfilePage extends ConsumerStatefulWidget {
  static const String routeName = '/urmymainprofilepage';

  const UrMyTalkMainProfilePage({Key? key}) : super(key: key);
  //const UrMyRegisterPage({Key key}) : super(key: key);

  @override
  ConsumerState<UrMyTalkMainProfilePage> createState() => _UrMyTalkMainProfilePageState();
}

class _UrMyTalkMainProfilePageState extends ConsumerState<UrMyTalkMainProfilePage> {

  final _globalWidget = GlobalWidget();


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildBody(SignInState signinState) {

    return //_globalWidget.createBackground(context, formListview(context, signinState));
      _globalWidget.createBackground(context, formListview(context, signinState));
  }

  Column formListview(BuildContext context, SignInState signInState) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        // create form login

        Padding(
          padding: EdgeInsets.fromLTRB(0.0,size.height/30.0,8.0,0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0,0.0,0.0,0.0),
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
              Padding(
                  padding: const EdgeInsets.fromLTRB(0.0,0.0,8.0,0.0),
                child: IconButton(
                  icon: const Icon(
                      Icons.settings,
                    color: urmyLogoColor,
                  ),
                  onPressed: () {
                    displayPopup(context);
                  },
                ),
              )
              ],
          ),
        ),
        SizedBox(
          height: size.height/8,
        ),
        _globalWidget.createProfileCard(context, urmyprofile(signInState)),
        InkWell(
          child: Container(
            width: size.width/1.18,
            margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            decoration: BoxDecoration(
                color: urmyMainColor,
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                border: Border.all(
                  color: Colors.white10,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.8),
                    spreadRadius: 3,
                    blurRadius: 8,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: const Text('profile.main.profile', textAlign: TextAlign.center, style: TextStyle(
                fontWeight: urmyButtonFontWeight,
                fontSize: urmyButtonTextFontSize,
                color: urmyButtonTextColor
            )).tr(),
          ),
          onTap: (){
            Navigator.popAndPushNamed(context, UrMyTalkUpdateMainProfilePage.routeName);
          },
        ),

        // create sign up link
      ],
    );
  }


  Widget urmyprofile(SignInState signinState) {
    Size size = MediaQuery.of(context).size;//(MediaQuery.of(context).size.height / 170).round()*100;
    return Column(
      children:
      [
        Stack(
        alignment: AlignmentDirectional.bottomStart,
            children: [
              GestureDetector(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: signinState.imageFilePath == null || signinState.imageFilePath!.isEmpty
                        ? Image.asset('assets/images/native_profile.png', height: size.height*0.65)
                        : _globalWidget.profilePic(
                      context: context,
                      uuid: signinState.uuid,
                      profileurl: signinState.contentUrl,
                      profilelist:  signinState.imageFilePath!.last,
                      size: size.height*0.65,
                      borderredi: const BorderRadius.all(Radius.circular(10.0)),
                      shape: BoxShape.rectangle
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, UrMyTalkUrMyProfilePicturePage.routeName);
                },
              ),

              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.black.withOpacity(0.0),
                      ],
                    )
                ),
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 5),
                alignment: Alignment.bottomLeft,
                //margin: const EdgeInsets.only(top: 64),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    Text("${signinState.name}, ${getAge(signinState.birthdate)}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                        )
                    ),
                    Text(signinState.description,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w300,
                          )
                      ),

                    const SizedBox(
                      height: 5,
                    ),
                    Text("${signinState.mbti}, ${signinState.city}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w900,
                        )
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ]
          ),
    ]);
  }


  void displayPopup(BuildContext context){
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        return ListView(
          children: [
            GestureDetector(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: const Text('profile.main.setting', textAlign: TextAlign.center, style: TextStyle(
                    color: Colors.black
                )).tr(),
              ),
              onTap: (){
                Navigator.pushNamedAndRemoveUntil(context, UrMyTalkSettingMainPage.routeName, ModalRoute.withName(UrMyTalkMainPage.routeName));

              },
            ),
            const Divider(
              color: Colors.grey,
            ),
            GestureDetector(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: const Text('profile.main.information', textAlign: TextAlign.center, style: TextStyle(
                    color: Colors.black
                )).tr(),
              ),
              onTap: (){
                Navigator.pushNamedAndRemoveUntil(context, UrMyTalkInformationMainPage.routeName, ModalRoute.withName(UrMyTalkMainPage.routeName));
              },
            ),
            const Divider(
              color: Colors.grey,
            ),
            GestureDetector(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: const Text('profile.main.help', textAlign: TextAlign.center, style: TextStyle(
                    color: Colors.black
                )).tr(),
              ),
              onTap: (){
                Navigator.pushNamedAndRemoveUntil(context, UrMyTalkHelpMainPage.routeName, ModalRoute.withName(UrMyTalkMainPage.routeName));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(signinStateProvider, (SignInState? previous, SignInState? next) {

    });
    return  Scaffold(
      backgroundColor: Colors.white,
      body: _globalWidget.customConsumerWidget(
          buildBody(ref.watch(signinStateProvider)),
      ),
    );
  }
}