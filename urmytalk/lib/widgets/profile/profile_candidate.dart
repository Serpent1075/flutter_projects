import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/provider/providers.dart';
import 'package:urmytalk/utils/utils.dart';
import 'package:urmytalk/widgets/wigets.dart';
import 'package:urmytalk/widgets/config/constant.dart';
import 'package:urmytalk/classes/urmytalk_classes.dart';


class UrMyTalkCandidateProfilePage extends ConsumerStatefulWidget {
  static const String routeName = '/urmycandidateprofilepage';

  const UrMyTalkCandidateProfilePage({Key? key}) : super(key: key);
  //const UrMyRegisterPage({Key key}) : super(key: key);

  @override
  ConsumerState<UrMyTalkCandidateProfilePage>  createState() => _UrMyTalkCandidateProfilePageState();
}

class _UrMyTalkCandidateProfilePageState extends ConsumerState<UrMyTalkCandidateProfilePage> {
  final _globalWidget = GlobalWidget();
  final UrMyTalkAdManager urmytalkAdmanager = UrMyTalkAdManager();

  @override
  void initState() {
    super.initState();
    urmytalkAdmanager.loadFullScreenAd();
  }

  @override
  void dispose() {
    urmytalkAdmanager.dispose();
    super.dispose();
  }

  Widget buildBody(ChatState chatState) {
    return  _globalWidget.createBackground(context,formListview(context, chatState));
  }

  Column formListview(BuildContext context, ChatState chatState) {
    Size size = MediaQuery.of(context).size;
    return Column(

      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        // create form login
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0,10.0,0.0,0.0),
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
            ],
          ),
        ),
        SizedBox(
          height: size.height/8,
        ),
        _globalWidget.createProfileCard(context, urmycandidateprofile(chatState)),
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
            child: const Text('profile.candidate.chatbutton', textAlign: TextAlign.center, style: TextStyle(
                fontWeight: urmyButtonFontWeight,
                fontSize: urmyButtonTextFontSize,
                color: urmyButtonTextColor
            )).tr(),
          ),
          onTap: (){
            try {
              urmytalkAdmanager.adManagerInterstitialAd!.show();
            } catch (e) {

            }
            ref.read(chatProvider.notifier).setCurrentChatroomId();
            Navigator.popAndPushNamed(context, UrMyChatBoardPage.routeName);
          },
        ),

        // create sign up link
      ],
    );
  }

  Widget urmycandidateprofile(ChatState chatState) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: <Widget>[
        Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              GestureDetector(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: chatState.currentCandidates!.profilePicPath == null || chatState.currentCandidates!.profilePicPath!.isEmpty
                        ? Image.asset('assets/images/native_profile.png', height: size.height*0.65,)
                        : _globalWidget.profilePic(
                        context: context,
                        profileurl: chatState.currentCandidates!.contentUrl!,
                        uuid: chatState.currentCandidates!.candidateUuid!,
                        profilelist: chatState.currentCandidates!.profilePicPath!.last,
                        size: size.height*0.65,
                        borderredi: const BorderRadius.all(Radius.circular(10.0)),
                        shape: BoxShape.rectangle
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, UrMyTalkCandidateProfilePicturePage.routeName);
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

                    Text("${chatState.currentCandidates!.candidateName!}, ${getAge(chatState.currentCandidates!.candidateBirthDate!)}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                        )
                    ),
                    Text(chatState.currentCandidates!.description!,
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
                    Text("${chatState.currentCandidates!.candidateMbti!}, ${chatState.currentCandidates!.city!}",
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

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _globalWidget.customConsumerWidget(
          buildBody(ref.watch(chatStateProvider))
      )
    );
  }


}