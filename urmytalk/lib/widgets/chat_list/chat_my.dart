import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/provider/providers.dart';
import 'package:urmytalk/utils/utils.dart';
import 'package:urmytalk/widgets/wigets.dart';
import 'package:urmytalk/classes/urmytalk_classes.dart';


class ChatMy extends ConsumerStatefulWidget {
  const ChatMy({Key? key}) : super(key: key);


  @override
  ConsumerState<ChatMy> createState() => _ChatMyState();
}


class _ChatMyState extends ConsumerState<ChatMy> with SingleTickerProviderStateMixin  {

  final _globalWidget = GlobalWidget();
  late final Future<int>? checknumFuture;
  final UrMyTalkAdManager urmytalkAdmanager = UrMyTalkAdManager();


  @override
  void initState() {
    checknumFuture = ref.read(candidateProvider.notifier).checknumberofurmy();
    super.initState();
    urmytalkAdmanager.loadFullScreenAd();
  }

  @override
  void dispose() {
    urmytalkAdmanager.dispose();
    super.dispose();
  }

  Widget buildBody(ChatState chatState) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('user')
            .doc(ref
            .read(signinProvider.notifier)
            .state
            .uuid)
            .collection("chatroomId")
            .orderBy("msgtimestamp", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: const Text('chatlist.nochatlist').tr(),
            );
          }

          return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chatroomId')
                  .doc(snapshot.data!.docs[0]["chatroomId"])
                  .collection(
                  snapshot.data!.docs[0]["chatroomId"])
                  .where('sender',
                  isEqualTo: snapshot.data?.docs[0]["user"])
                  .where('isread', isEqualTo: false)
                  .snapshots(),
              builder: (context, notReadMSGSnapshot) {
                return ListView.builder(
                    padding: const EdgeInsets.all(10.0),
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> senderInfo = ref.read(candidateProvider.notifier).getProfile(snapshot.data?.docs[index]["user"]);
                      try {
                        return ListTile(
                          contentPadding: const EdgeInsets.fromLTRB(
                              10.0, 5.0, 5.0, 5.0),
                          leading: GestureDetector(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: senderInfo['propic'] ==
                                  null
                                  ? const CircleAvatar(
                                backgroundImage: AssetImage(
                                    'assets/images/native_profile.png'),
                              )
                                  : CircleAvatar(
                                backgroundImage: NetworkImage(getProfilePicPath(
                                    senderInfo['profileUrl'],
                                    snapshot.data?.docs[index]["user"],
                                    senderInfo['propic']!
                                        .last
                                        .filename! +
                                        "?w=" +
                                        ProfilePic100.toString() +
                                        "&h=" +
                                        ProfilePic100.toString())),
                              ),
                            ),
                            onTap: () {
                              if(senderInfo['addable']){
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: const Text("chatlist.addfriend").tr(),
                                        contentTextStyle: const TextStyle(
                                            fontSize: urmyAlertTextFontSize,
                                            fontWeight: urmyAlertTextFontWeight,
                                            color: urmyAlertTextColor
                                        ),
                                        actions: [
                                          TextButton(
                                            child: const Text("chatlist.yes", style: TextStyle(
                                                fontWeight: urmyAlertActionFontWeight,
                                                fontSize: urmyAlertActionFontSize,
                                                color: urmyAlertActionColor
                                            ),).tr(),
                                            onPressed: () {
                                              if(ref.read(candidateProvider.notifier).state.friends == null || ref.read(candidateProvider.notifier).state.friends!.candidatelist!.length < 6) {
                                                ref.read(candidateProvider.notifier).addAnonymousFriendList(snapshot.data?.docs[index]["user"]);
                                                Navigator.pushNamedAndRemoveUntil(context, UrMyTalkMainPage.routeName, (route) => false);
                                              } else {
                                                ref.read(candidateProvider.notifier).setTooManyFriendError();
                                              }
                                            },
                                          ),
                                          TextButton(
                                            child: const Text("chatlist.no", style: TextStyle(
                                                fontWeight: urmyAlertActionFontWeight,
                                                fontSize: urmyAlertActionFontSize,
                                                color: urmyAlertActionColor
                                            ),).tr(),
                                            onPressed: (){
                                              Navigator.pop(context);
                                            },
                                          )
                                        ],
                                      );
                                    }
                                );
                              } else {
                                try {
                                  urmytalkAdmanager.adManagerInterstitialAd!.show();
                                } catch (e) {

                                }
                                ref.read(chatProvider.notifier).setCurrentCandidate(ref.read(candidateProvider.notifier).getCandidate(snapshot.data?.docs[index]["user"]));
                                Navigator.pushNamed(context, UrMyTalkCandidateProfilePicturePage.routeName);
                              }
                            },
                          ),
                          title: senderInfo['name'] == "none" ? const Text("chatlist.none").tr() : Text(
                              senderInfo['name']),
                          subtitle: snapshot.data?.docs[index]["msgtype"] == "text"
                              ? Text(
                              snapshot.data?.docs[index]["lastChat"])
                              : const Text("image"),
                          trailing: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 4, 4),
                              child: Column(
                                children: [
                                  Text(returnTimeStamp(
                                      snapshot.data?.docs[index]["msgtimestamp"])),
                                  notReadMSGSnapshot.hasData == false
                                      ? const Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  )
                                      : Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0, 0, 0, 0),
                                    child: CircleAvatar(
                                      radius: 10,
                                      backgroundColor: notReadMSGSnapshot.data!
                                          .docs
                                          .isNotEmpty ? Colors.red[400] : Colors
                                          .transparent,
                                      child: Text(
                                        (notReadMSGSnapshot.data!.docs.isNotEmpty
                                            ? '${notReadMSGSnapshot.data!.docs
                                            .length}'
                                            : ''),
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    ),

                                  ),
                                ],
                              )
                          ),
                          onTap: () {
                            if(senderInfo['addable']){
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: const Text("chatlist.addfriend").tr(),
                                      contentTextStyle: const TextStyle(
                                          fontSize: urmyAlertTextFontSize,
                                          fontWeight: urmyAlertTextFontWeight,
                                          color: urmyAlertTextColor
                                      ),
                                      actions: [
                                        TextButton(
                                          child: const Text("chatlist.yes", style: TextStyle(
                                              fontWeight: urmyAlertActionFontWeight,
                                              fontSize: urmyAlertActionFontSize,
                                              color: urmyAlertActionColor
                                          ),).tr(),
                                          onPressed: () {
                                            ref.read(candidateProvider.notifier).addAnonymousFriendList(snapshot.data?.docs[index]["user"]);
                                            Navigator.pushNamedAndRemoveUntil(context, UrMyTalkMainPage.routeName, (route) => false);
                                          },
                                        ),
                                        TextButton(
                                          child: const Text("chatlist.no", style: TextStyle(
                                              fontWeight: urmyAlertActionFontWeight,
                                              fontSize: urmyAlertActionFontSize,
                                              color: urmyAlertActionColor
                                          ),).tr(),
                                          onPressed: (){
                                            Navigator.pop(context);
                                          },
                                        )
                                      ],
                                    );
                                  }
                              );
                            } else {
                              ref.read(chatProvider.notifier).setCurrentCandidate(ref.read(candidateProvider.notifier).getCandidate(snapshot.data?.docs[index]["user"]));
                              ref.read(chatProvider.notifier).setCurrentChatroomId();
                              FlutterAppBadger.updateBadgeCount(notReadMSGSnapshot.data!.docs.length);
                              Navigator.pushNamed(context, UrMyChatBoardPage.routeName);
                            }
                          },
                        );
                      } catch (e) {
                        return Container();
                      }

                    }
                );
              }
          );
        });
  }


  Widget leadingTitle(BuildContext context) {

    var futureBuilder = FutureBuilder(
        future: checknumFuture,
        builder: (context, AsyncSnapshot snapshot) {
          switch(snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const CircularProgressIndicator();
            default:
              if (snapshot.hasError) {
                int? numberofurmy = ref.read(candidateProvider.notifier).state.numberofurmy;

                return Text("${"candidate.numofurmy".tr()} : $numberofurmy",
                  style: const TextStyle(
                      color: urmyLogoColor,
                      fontWeight: urmyContentFontWeight,
                      fontSize: urmyContentFontSize),
                );
              } else {
                String num;

                if (snapshot.data > 1000) {
                  num = "${snapshot.data/1000}k";
                } else {
                  num = "${snapshot.data}";
                }

                if (snapshot.data > 1000000) {
                  num = "${snapshot.data/1000}m";
                }



                return Text(
                  "${"candidate.numofurmy".tr()} $num",
                  style: const TextStyle(
                      color: urmyLogoColor,
                      fontWeight: urmyContentFontWeight,
                      fontSize: urmyContentFontSize),
                );
              }
          }
        }
    );
    return futureBuilder;
  }

  @override
  Widget build(BuildContext context) {
    final chatWatch = ref.watch(chatStateProvider);
    if (chatWatch.tmerr == "too-many-friends") {
      _globalWidget.showDialogWithFunc(context, 'chatlist.friendlimit'.tr(), ref.read(candidateProvider.notifier).setErrorEmpty());
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, value) {
            return [
              SliverAppBar(
                backgroundColor: urmyMainColor,
                flexibleSpace: Container(
                  height: MediaQuery.of(context).size.height / 2.5,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [urmyGradientTop, urmyGradientMiddleTop,urmyGradientMiddleBottom],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.1, 0.5, 0.8],
                      )),
                ),
                leading: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0,0,0,0),
                  child: _globalWidget.customlogo(urmyLogoColor),
                ),
                iconTheme: const IconThemeData(
                  color: Colors.black, //change your color here
                ),
                elevation: 0,
                systemOverlayStyle: SystemUiOverlayStyle.dark,
                floating: false,
                pinned: true,
                title: leadingTitle(context),
                snap: false,
                centerTitle: true,
                /*bottom: PreferredSize(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _tabBar = TabBar(
                          controller: _tabController,
                          onTap: (position) {
                            setState(() {
                              _tabIndex = position;
                            });
                            //print('idx : '+_tabIndex.toString());
                          },
                          isScrollable: true,
                          labelColor: BLACK21,
                          labelStyle: const TextStyle(fontSize: 14),
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorWeight: 4,
                          indicatorColor: BLACK21,
                          unselectedLabelColor: SOFT_GREY,
                          labelPadding: const EdgeInsets.symmetric(
                              horizontal: 30.0),
                          tabs: _tabBarList,
                        ),
                        Container(
                          color: Colors.grey[200],
                          height: 1.0,
                        )
                      ],
                    ),
                    preferredSize: Size.fromHeight(
                        _tabBar.preferredSize.height + 1)),*/
              ),
            ];
          },
          body: _globalWidget.customConsumerWidget(
              buildBody(ref.watch(chatStateProvider))
          ),
        ),

    );
  }
}