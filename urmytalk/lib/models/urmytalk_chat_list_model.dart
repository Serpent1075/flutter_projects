class UrMyMessage {
  String chatroomId;
  String sender;
  String msgtype;
  String msgcontent;
  String msgtimestamp;

  UrMyMessage({
    this.chatroomId ='',
    this.sender = '',
    this.msgtype = '',
    this.msgcontent = '',
    this.msgtimestamp = '',
  });

  factory UrMyMessage.fromJson(Map<String, dynamic> parsedJson) {
    return UrMyMessage(
      chatroomId: parsedJson['ChatroomId'].toString().trim(),
      sender: parsedJson['Sender'].toString().trim(),
      msgtype: parsedJson['Msgtype'].toString().trim(),
      msgcontent: parsedJson['Msgcontent'].toString().trim(),
      msgtimestamp: parsedJson['Msgtimestamp'].toString().trim(),
    );
  }


  Map<String, dynamic> toJson() => {
    "ChatroomId": chatroomId,
    "Sender": sender,
    "Msgtype": msgtype,
    "Msgcontent": msgcontent,
    "Msgtimestamp": msgtimestamp,
  };
}
