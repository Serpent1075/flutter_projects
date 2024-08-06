import 'dart:convert';

UrMyTalkChatTransfer chattrasferFromJson(String str) => UrMyTalkChatTransfer.fromJson(json.decode(str));
String chattransferToJson(UrMyTalkChatTransfer data) => json.encode(data.toJson());

class UrMyTalkChatTransfer {
  String? action;
  String? type;
  List<UrMyTalkChatList>? message;

  UrMyTalkChatTransfer({
    this.action,
    this.type,
    this.message,
  });

  factory UrMyTalkChatTransfer.fromJson(Map<String, dynamic> json) => UrMyTalkChatTransfer(
    action: json["action"],
    type: json["Type"],
    message: List<UrMyTalkChatList>.from(json["Message"].map((x) => UrMyTalkChatList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "action": action,
    "Type": type,
    "Message": List<dynamic>.from(message!.map((x) => x.toJson())),
  };
}


class UrMyTalkChatList {

  String? chatroomId;
  String? sender;
  String? receiver;
  String? msgcontent;
  String? msgtype;
  DateTime? msgtimestamp;

  UrMyTalkChatList({
    this.chatroomId,
    this.sender,
    this.receiver,
    this.msgcontent,
    this.msgtype,
    this.msgtimestamp,
  });

  factory UrMyTalkChatList.fromJson(Map<dynamic, dynamic> parsedJson) {
    return UrMyTalkChatList(
      chatroomId: parsedJson['ChatroomId'],
      sender: parsedJson['Sender'],
      receiver: parsedJson['Receiver'],
      msgcontent: parsedJson['Message'],
      msgtype: parsedJson['Msgtype'],
      msgtimestamp: parsedJson['Msgtimestamp'] == null ? null : DateTime.parse(parsedJson['Msgtimestamp']),
    );
  }

  Map<String, dynamic> toJson() => {
    "ChatroomId": chatroomId,
    "Sender": sender,
    "Receiver": receiver,
    "Message": msgcontent,
    "Msgtype" : msgtype,
    "Msgtimestamp": msgtimestamp == null ? null : msgtimestamp!.toIso8601String(),
  };

  Map<dynamic, dynamic> toMap() {
    return {
      'ChatroomId': chatroomId,
      'Sender': sender,
      'Receiver': receiver,
      'Message': msgcontent,
      'Msgtype': msgtype,
      'Msgtimestamp' : msgtimestamp == null ? null : msgtimestamp!.toIso8601String(),
    };
  }
}
