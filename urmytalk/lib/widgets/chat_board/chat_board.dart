import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/provider/providers.dart';
import 'package:urmytalk/utils/utils.dart';
import 'package:urmytalk/widgets/wigets.dart';


class UrMyChatBoardPage extends ConsumerStatefulWidget {
  //const UrMyRegisterPage({Key key}) : super(key: key);
  static const String routeName = '/chatboard';

  const UrMyChatBoardPage({Key? key}) : super(key: key);

  @override
  ConsumerState<UrMyChatBoardPage> createState() => _UrMyChatBoardState();
}

class _UrMyChatBoardState extends ConsumerState<UrMyChatBoardPage> with TickerProviderStateMixin{
  final formattime = DateFormat('hh:mm a');
  final ScrollController _chatListController = ScrollController();
  final TextEditingController _msgTextController = TextEditingController();
  TextEditingController contentsController = TextEditingController();
  String contents = "";
  List<String> reporttype = <String>["credential","illegal","hacking", "etc"];
  String dropdownValue = "credential";
  late String chatroomId;
  int chatListLength = 20;
  int length = 0;
  final _globalWidget = GlobalWidget();
  final _focusNode = FocusNode();

  _focusListener() {
    setState(() {});
  }
  @override
  void initState() {
    _focusNode.addListener(_focusListener);
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_focusListener);
    contentsController.dispose();
    _msgTextController.dispose();
    _chatListController.dispose();
    super.dispose();
  }

  Widget buildBody(ChatState chatState) {
    return GestureDetector(
        onTap: (){
          _focusNode.unfocus();
        },
        child: _globalWidget.createBackgroundWithoutLogo(context, urmychatWidget(chatState))
    );
  }



/*
  Widget urmychatWidget(ChatState chatState) {
    return Column(
      children: <Widget>[
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('chatroomId')
                .doc(chatState.currentChatroomId)
                .collection(chatState.currentChatroomId!)
                .orderBy("msgtimestamp", descending: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: Text("no chat"),
                );
              } else {
                length = snapshot.data!.docs.length;
                for (var data in snapshot.data!.docs) {
                  if (data['sender'] == chatState.currentCandidates!.candidateUuid &&
                      data['isread'] == false) {
                    FirebaseFirestore.instance.runTransaction(
                            (Transaction myTransaction) async {
                          myTransaction.update(data.reference, {'isread': true});
                        });
                  }
                }
                return ListView.separated(
                    reverse: true,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    controller: _chatListController,
                    itemBuilder: (context, index) =>
                        makeRowItem(snapshot, index, chatState),
                    separatorBuilder: (context, index) =>
                        makeDateSeperated(snapshot, index),
                    itemCount: snapshot.data!.docs.length);
              }
            },
          ),
        ),
        _buildTextComposer(),

      ],
    );
  }
*/
  Widget urmychatWidget(ChatState chatState) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chatroomId')
          .doc(chatState.currentChatroomId)
          .collection(chatState.currentChatroomId!)
          .orderBy("msgtimestamp", descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: Text("no chat"),
          );
        } else {
          length = snapshot.data!.docs.length;
          for (var data in snapshot.data!.docs) {
            if (data['sender'] == chatState.currentCandidates!.candidateUuid &&
                data['isread'] == false) {
              FirebaseFirestore.instance.runTransaction(
                      (Transaction myTransaction) async {
                    myTransaction.update(data.reference, {'isread': true});
                  });
            }
          }
          return Column(
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0,20.0,0.0,0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: urmyLogoColor,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0,50.0,0.0,0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _globalWidget.customIndex(context, 200,length),
                      ],
                    ),
                  ),
                ]
              ),
              Expanded(
                child: ListView.separated(
                    reverse: true,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    controller: _chatListController,
                    itemBuilder: (context, index) =>
                        makeRowItem(snapshot, index, chatState),
                    separatorBuilder: (context, index) =>
                        makeDateSeperated(snapshot, index),
                    itemCount: snapshot.data!.docs.length),
              ),
              _buildTextComposer(),
            ],
          );
        }
      },
    );
  }

  Widget makeRowItem(AsyncSnapshot<QuerySnapshot> snapshot, int index,
      ChatState chatState) {
    index = snapshot.data!.docs.length - 1 - index;

    if (index == snapshot.data!.docs.length - 1 || index == 0) {
      return snapshot.data!.docs[index]["sender"] ==
              chatState.currentCandidates!.candidateUuid
          ? _listItemOther(
              context,
              chatState.currentCandidates!.candidateName!,
              //chatState.currentCandidates.imageURL,
              snapshot.data!.docs[index]["msgcontent"],

              returnTimeStamp(
                  snapshot.data!.docs[index]["msgtimestamp"]),
              snapshot.data!.docs[index]["isread"],
              snapshot.data!.docs[index]["msgtype"],
              urmyChatTruePadding,
              true,
              chatState
            )
          : _listItemMine(
              context,
              snapshot.data!.docs[index]["msgcontent"],
              returnTimeStamp(
                  snapshot.data!.docs[index]["msgtimestamp"]),
              snapshot.data!.docs[index]["isread"],
              snapshot.data!.docs[index]["msgtype"],
              urmyChatTruePadding
            );
    } else {
      int currenttimevalue =
          snapshot.data!.docs[index]["msgtimestamp"]!;
      int nexttimevalue =
          snapshot.data!.docs[index + 1]["msgtimestamp"]!;
      if (snapshot.data!.docs[index]["sender"] ==
          chatState.currentCandidates!.candidateUuid) {
        if ((snapshot.data!.docs[index + 1]["sender"] ==
            chatState.currentCandidates!.candidateUuid)) {
          if ((nexttimevalue / 60000).floor() ==
              (currenttimevalue / 60000).floor()) {
            return _listItemOther(
              context,
              chatState.currentCandidates!.candidateName!,
              //chatState.currentCandidates.imageURL,
              snapshot.data!.docs[index]["msgcontent"],
              '',
              snapshot.data!.docs[index]["isread"],
              snapshot.data!.docs[index]["msgtype"],
              urmyChatFalsePadding,
              false,
              chatState
            );
          }
        }
        return _listItemOther(
          context,
          chatState.currentCandidates!.candidateName!,
          //chatState.currentCandidates.imageURL,
          snapshot.data!.docs[index]["msgcontent"],
          returnTimeStamp(
              snapshot.data!.docs[index]["msgtimestamp"]),
          snapshot.data!.docs[index]["isread"],
          snapshot.data!.docs[index]["msgtype"],
          urmyChatTruePadding,
          true,
          chatState
        );
      } else {
        if (snapshot.data!.docs[index + 1]["sender"] !=
            chatState.currentCandidates!.candidateUuid) {
          if ((nexttimevalue / 60000).floor() ==
              (currenttimevalue / 60000).floor()) {
            return _listItemMine(
              context,
              snapshot.data!.docs[index]["msgcontent"],
              '',
              snapshot.data!.docs[index]["isread"],
              snapshot.data!.docs[index]["msgtype"],
              urmyChatFalsePadding,
            );
          }
        }
        return _listItemMine(
          context,
          snapshot.data!.docs[index]["msgcontent"],
          returnTimeStamp(
              snapshot.data!.docs[index]["msgtimestamp"]),
          snapshot.data!.docs[index]["isread"],
          snapshot.data!.docs[index]["msgtype"],
          urmyChatTruePadding,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(chatStateProvider, (ChatState? previous, ChatState? next) {
      if(ref.read(appConfigProvider.notifier).state.buildFlavor == 'dev') {

      }
      if (next!.tmerr == "too-many-messages") {
        _globalWidget.showDialogWithFunc(context, 'chatboard.messagelimit'.tr(), ref.read(chatProvider.notifier).setErrorEmpty());
      }
    });

    return  AnnotatedRegion<SystemUiOverlayStyle>(
      value: Platform.isIOS
          ? SystemUiOverlayStyle.light
          : const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _globalWidget.customConsumerWidget(
            buildBody(ref.watch(chatStateProvider))
        ),
      ),
    );
  }

  Widget _listItemOther(
      BuildContext context,
      String name, //String thumbnail,
      String message,
      String time,
      bool isRead,
      String type,
      double padding,
      bool propic,
      ChatState chatState) {

    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          propic == true ? GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, UrMyTalkCandidateProfilePage.routeName);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: chatState.currentCandidates!.profilePicPath ==
                  null
                  ? const CircleAvatar(
                backgroundImage: AssetImage(
                    'assets/images/native_profile.png'),
              )
                  : CircleAvatar(
                backgroundImage: NetworkImage(getProfilePicPath(
                    chatState.currentCandidates!.contentUrl!,
                    chatState.currentCandidates!.candidateUuid!,
                    "${chatState.currentCandidates!.profilePicPath!
                        .last
                        .filename!}?w=$ProfilePic100&h=$ProfilePic100")),
              ),
            ),
          ) : Container(
            width: 40,
          ),
          const SizedBox(
            width: 5,
          ),
          GestureDetector(
            onLongPress: () {
              _showPopup(context, time, message);
            },
            child: Container(
              alignment: Alignment.centerLeft,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.80,
                ),
                padding: const EdgeInsets.all(12),
                margin: EdgeInsets.symmetric(vertical: padding),
                decoration: BoxDecoration(
                    color: urmyChatYourColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                      )
                    ]),
                child: Text(message, style: const TextStyle(color: urmyChatTextColor, fontWeight: urmyContentFontWeight, fontSize: urmyContentFontSize)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 4, left: 8, top: 40),
            child: Text(
              time,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listItemMine(BuildContext context, String message, String time,
      bool isRead, String type, double padding) {
    return Padding(
      padding: EdgeInsets.only(right: 8, bottom: padding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0, right: 2, left: 4),
            child: Text(
              isRead ? '' : '1',
              style: TextStyle(fontSize: 12, color: Colors.yellow[900]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0, right: 4, left: 8),
            child: Text(
              time,
              style: const TextStyle(fontSize: urmyTimeFontIze, fontWeight: urmyTimeFontWeight),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.80,
              ),
              padding: const EdgeInsets.all(12),
              margin: EdgeInsets.symmetric(vertical: padding),
              decoration: BoxDecoration(
                  color: urmyChatMyColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                    )
                  ]),
              child: Text(
                message,
                style: const TextStyle(color: urmyChatTextColor, fontWeight: urmyContentFontWeight, fontSize: urmyContentFontSize),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _imageMessage(imageUrlFromFB) {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: GestureDetector(
        onTap: () {
          //Navigator.push(context, MaterialPageRoute(builder: (context) => FullPhoto(url: imageUrlFromFB)));
        },
        child: Container(),
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).toggleableActiveColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
    /*
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 2.0),
              child: IconButton(
                  icon: Icon(
                    Icons.photo,
                    color: Colors.cyan[900],
                  ),
                  onPressed: () {
                    PickImageController.instance.cropImageFromFile().then((croppedFile) {
                      if (croppedFile != null) {
                        setState(() { messageType = 'image'; _isLoading = true; });
                        _saveUserImageToFirebaseStorage(croppedFile);
                      }else {
                        _showDialog('Pick Image error');
                      }
                    });
                  }),
            ),*/
            Flexible(
              child: TextField(
                cursorColor: urmyChatYourColor,
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: urmyChatMyColor)),
                    border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: urmyChatYourColor)),
                    filled: true,

                    contentPadding: EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                  ),
                  keyboardType: TextInputType.text,
                  controller: _msgTextController,
                  onSubmitted: _handleSubmitted,
                  onTap: () {

                  },
                  focusNode: _focusNode,
                  ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 2.0),
              child: IconButton(
                  icon: const Icon(Icons.send, color: urmyIconColor,),
                  onPressed: () {
                      _handleSubmitted(_msgTextController.text);
                  }),
            ),

          ],
        ),
      ),
    );
  }

  Widget makeDateSeperated(
      AsyncSnapshot<QuerySnapshot> snapshot, int index) {
    if (index == 0) {
      return Container();
    } else {
      index = snapshot.data!.docs.length - 1 - index;
      int previoustimevalue =
          snapshot.data!.docs[index - 1]["msgtimestamp"];
      int currenttimevalue =
          snapshot.data!.docs[index]["msgtimestamp"];
      if ((previoustimevalue / 86400000).floor() !=
          (currenttimevalue / 86400000).floor()) {
        return Container(
          alignment: Alignment.center,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.80,
            ),
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  )
                ]),
            child: Text(returnDateStamp(currenttimevalue),
                style: const TextStyle(fontSize: 20)),
          ),
        );
      } else {
        return Container();
      }
    }
  }

  Future<void> _handleSubmitted(String text) async {
    String base64Text = base64.encode(utf8.encode(text));
    if(base64Text == "" || base64.encode(utf8.encode(base64Text)) == "ICA=" || base64Text == "ICAg" || base64Text == "ICAgIA==" || base64Text == "ICAgICA=" || base64Text == "ICAgICAg") {
      _globalWidget.showNormalDialog(context, 'chatboard.notice.abusivetitle'.tr(), 'chatboard.notice.abusivecontent'.tr());
    } else {
      int count = 0;
      for (int i=0; i<5; i++) {
        if (text.contains("  ")) {
          text.replaceAll("  ", " ");
          count += 1;
        }
      }
      if(count > 4) {
        _globalWidget.showNormalDialog(context, 'chatboard.notice.abusivetitle'.tr(), 'chatboard.notice.abusivecontent'.tr());
      } else {
        if (length < 200) {
          ref.read(chatProvider.notifier).sendMessage(text, "text", ref.read(signinProvider.notifier).state.name ,ref.read(candidateProvider.notifier).state.blacklist,length);
        } else {
          ref.read(chatProvider.notifier).setTooManyMessageError();
        }
      }
    }


    _resetTextFieldAndLoading();
  }

  _resetTextFieldAndLoading() {
    _msgTextController.text = '';
    //FocusScope.of(context).requestFocus(focusNode);
    //_UrMyChatBoardState urmychatboard = _UrMyChatBoardState(animationController: AnimationController(duration: const Duration(milliseconds: 700), vsync: this));
    //urmychatboard.animationController.forward();
  }

  void _showPopup(
      BuildContext context, String time, String message) {
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
                  ref.read(chatProvider.notifier).sendchatreport(
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
}
