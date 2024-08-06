import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:hive/hive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:urmytalk/provider/providers.dart';
import 'package:http/http.dart' as http;
import 'package:urmytalk/urmyexception/exceptions.dart';

class ChatRepository {
  late final Ref ref;

  List<UrMyTalkChatList>? messages;
  var urmytokenstorage = Hive.box<UrMyToken>('accesstoken');

  ChatRepository({required this.ref});

  Future<void> sendChatting(
      String chatID,
      String myID,
      String selectedUserID,
      String content,
      String messageType,
      String myName,
      Candidateslist? candidateslist) async {
    if (candidateslist != null) {
      for (var data in candidateslist.candidatelist!) {
        if (data.candidateUuid == selectedUserID) {
          throw Exception("I guess our relationship ends here");
        }
      }
    }

    await sendMessageToChatRoom(
        chatID, myID, myName, selectedUserID, content, messageType);

  }

  Future<void> sendMessageToChatRoom(
      chatID, myID, myName, selectedUserID, content, messageType) async {
    final String baseUrl = ref.read(appConfigProvider.notifier).state.baseUrl;

    var url = Uri.parse('$baseUrl/v2/updateprofilepic');
    var accesstoken = urmytokenstorage.get('accesstoken');
    var msgtimestamp = DateTime.now().millisecondsSinceEpoch;
    /*
    if (messageType == "image") {


      var request = http.MultipartRequest("POST", url);
      request.headers['authtoken'] = accesstoken!.token;
      request.fields["chatId"] = chatID;
      var pic = await http.MultipartFile.fromPath("chatpicture", content);
      //add multipart to request
      request.files.add(pic);
      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      var responseBody = json.decode(responseString);
      print(responseBody);

      if (response.statusCode == 400) {
        throw Exception('Not uploadable type');
      }

      await FirebaseFirestore.instance
          .collection('chatroomId')
          .doc(chatID)
          .collection(chatID)
          .doc(msgtimestamp.toString())
          .set({
        'sender': myID,
        'receiver': selectedUserID,
        'msgtimestamp': msgtimestamp,
        'msgcontent': responseBody["imagepath"],
        'msgtype': messageType,
        'isread': false,
      });
      await updateLastChatRequestField(chatID, myID, selectedUserID,
          responseBody["imagepath"], messageType, msgtimestamp);
    } else {
      await FirebaseFirestore.instance
          .collection('chatroomId')
          .doc(chatID)
          .collection(chatID)
          .doc(msgtimestamp.toString())
          .set({
        'sender': myID,
        'receiver': selectedUserID,
        'msgtimestamp': msgtimestamp,
        'msgcontent': content,
        'msgtype': messageType,
        'isread': false,
      });
      await updateLastChatRequestField(
          chatID, myID, selectedUserID, content, messageType, msgtimestamp);
    }
    */
    await sendMessageNotification(chatID,selectedUserID, myID, content, messageType, msgtimestamp);
  }

  Future<void> sendMessageNotification(String chatID,String selectedUserID,String myID,String content,String messageType, int msgtimestamp) async{
    final String baseUrl = ref.read(appConfigProvider.notifier).state.baseUrl;

    var url = Uri.parse('$baseUrl/v2/sendmessage');

    var accesstoken = urmytokenstorage.get('accesstoken');

    final http.Response response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'authtoken': accesstoken!.token,
        'firebasetoken' : accesstoken.firebasetoken,
      },
      body: json.encode(
        {
          'chatroomid': chatID,
          'msguser': selectedUserID,
          'msgcontent': content,
          'sentdate' : msgtimestamp,
          'msgsender' : myID,
          'msgtype' : messageType,
        },
      ),
    );
    checkStatusCode(response.statusCode);

    if (response.statusCode != 200) {
      throw Exception("Need to update your profile");
    }
  }

  Future<void> updateLastChatRequestField(
      String chatroomId,
      String sender,
      String receiver,
      String lastMessage,
      String msgtype,
      int msgtimestamp) async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(sender)
        .collection('chatroomId')
        .doc(chatroomId)
        .set({
      'chatroomId': chatroomId,
      'user': receiver,
      'lastChat': lastMessage,
      'msgtimestamp': msgtimestamp,
      'msgtype': msgtype
    });
    await FirebaseFirestore.instance
        .collection('user')
        .doc(receiver)
        .collection('chatroomId')
        .doc(chatroomId)
        .set({
      'chatroomId': chatroomId,
      'user': sender,
      'lastChat': lastMessage,
      'msgtimestamp': msgtimestamp,
      'msgtype': msgtype
    });
  }

  Future<int> getUnreadMSGCount(String chatroomId, String targetID) async {
    try {
      int unReadMSGCount = 0;
      final QuerySnapshot chatListResult = await FirebaseFirestore.instance
          .collection('chatroomId')
          .doc(chatroomId)
          .collection(chatroomId)
          .get();
      final List<DocumentSnapshot> chatListDocuments = chatListResult.docs;
      for (var data in chatListDocuments) {
        final QuerySnapshot unReadMSGDocument = await FirebaseFirestore.instance
            .collection('chatroomId')
            .doc(data['chatroomId'])
            .collection(data['chatroomId'])
            .where('receiver', isEqualTo: targetID)
            .where('isread', isEqualTo: false)
            .get();

        final List<DocumentSnapshot> unReadMSGDocuments =
            unReadMSGDocument.docs;
        unReadMSGCount = unReadMSGCount + unReadMSGDocuments.length;
      }

      return unReadMSGCount;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> sendchatreport(String message, String time, String type, String chatroomid, String candidateuuid, String contents) async {
    final String baseUrl = ref.read(appConfigProvider.notifier).state.baseUrl;

    var accesstoken = urmytokenstorage.get('accesstoken');

    var reporturl = Uri.parse('$baseUrl/v3/insertchatreport');
    final http.Response response = await http.post(
      reporturl,
      headers: {
        'authtoken': accesstoken!.token,
        'firebasetoken' : accesstoken.firebasetoken,
      },
      body: json.encode(
        {
          'chatroomid': chatroomid,
          'reporttype' : type,
          'messages' : message,
          'messagetime': time,
          'reporteduser' : candidateuuid,
          'contents' : contents,
        },
      ),
    );

    if (response.statusCode == 200) {
      return;
    }

  }

  void checkStatusCode(int code) {
    switch (code) {
      case 401:
        throw UrMyTokenExpiredException("TokenExpired");
      case 500:
        throw UrMyTokenExpiredException("TokenDeleted");
    }
  }
}
