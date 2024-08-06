

import 'dart:async';
import 'dart:core';
import 'package:web_socket_channel/io.dart';
import 'package:urmytalk/models/models.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class UrMyChatController {
  IOWebSocketChannel? channel;
  Database? database;
  List<UrMyTalkChatList>? messages;

  UrMyChatController({this.channel});

  Future<Database?> connecToChatDatabase() async {
    database = await openDatabase(
        join(await getDatabasesPath(), 'urmychat_database.db'),
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('CREATE TABLE IF NOT EXISTS urmy_chatlist ('
              'chatroomId TEXT PRIMARY KEY,'
              'msgcontent TEXT,'
              'msgtype TEXT,'
              'msgtimestamp TEXT)'
          );
        }
    );
    return database;
  }

  Future<void> connectToChannel() async{
    channel = await IOWebSocketChannel.connect('wss://7y5nkuvqs3.execute-api.ap-northeast-2.amazonaws.com/dev',
        headers:
        {
          "test" : "test",
          "test2" : "test2"
        });
    channel!.stream.listen((event) {
      print("listen callback: " + event);
    });
  }


  Future<void> sendMessage(String message, String type, String sendto) async {
    if (type =="text"){
      UrMyTalkChatList chatmsg = UrMyTalkChatList(
        chatroomId: 'chatroomId',
        sender: 'myid',
        receiver: sendto.trim(),
        msgcontent: message,
        msgtype: 'text',
        msgtimestamp: DateTime.now(),
      );

      List<UrMyTalkChatList> chatlist = [chatmsg];

      UrMyTalkChatTransfer transfermsg = UrMyTalkChatTransfer(
        action: 'sendMessage',
        type: 'text',
        message: chatlist,
      );
      channel!.sink.add(chattransferToJson(transfermsg));
      saveChatData(chatlist);
    } else {
      print("not text");
    }
  }


  Future<void> disconnectChannel() async {
    print("sink close");
    //channel?.sink.close();
  }


  Future<void> saveChatData(List<UrMyTalkChatList> chatdata) async {
    var data = chatdata.last;
    print('start save chat data');
    //'SELECT name FROM sqlite_master WHERE type="table" AND name=${data.chatroomId};')
    int? count = await database!.query('sqlite_master',
      columns: ['name'],
      where: 'type = ? AND name = ?',
      whereArgs: ["table", data.chatroomId],
    ).then((value) => value.length);
    print("count: " + count.toString());

    await database!.execute('CREATE TABLE IF NOT EXISTS ${data.chatroomId} ('
        'id INTEGER PRIMARY KEY AUTOINCREMENT, '
        'chatroomId TEXT,'
        'sender TEXT,'
        'receiver TEXT,'
        'msgcontent TEXT,'
        'msgtype TEXT,'
        'msgtimestamp TEXT)'
    );

    count = await database!.query('sqlite_master',
      columns: ['name'],
      where: 'type = ? AND name = ?',
      whereArgs: ["table", data.chatroomId],
    ).then((value) => value.length);
    print("count: " + count.toString());

    //await database!.rawInsert('INSERT INTO ${data.chatroomId}(chatroomId, sender, receiver, msgcontent, msgtype, msgtimestamp) '
    //    'VALUES(${data.chatroomId}, ${data.sender}, ${data.receiver},${data.msgcontent},${data.msgtype}, ${data.msgtimestamp})'
    //);
    await database!.insert(data.chatroomId.toString(),
        {
          "chatroomId" : data.chatroomId,
          "sender" : data.sender,
          "receiver" : data.receiver,
          "msgcontent" : data.msgcontent,
          "msgtype" : data.msgtype,
          "msgtimestamp" : data.msgtimestamp!.toIso8601String(),
        });

    //count = await database!.rawUpdate('UPDATE urmy_chatlist SET chatroomId = ?, msgcontent = ?, msgtype = ?, msgtimestamp = ?',
    //[data.chatroomId, data.msgcontent, data.msgtype, data.msgtimestamp]);
    count = await database!.update(
        'urmy_chatlist',
        {
          "chatroomId" : data.chatroomId,
          "msgcontent" : data.msgcontent,
          "msgtype" : data.msgtype,
          "msgtimestamp" : data.msgtimestamp!.toIso8601String(),
        },
        where:  'chatroomId = ?',
        whereArgs: [data.chatroomId]
    );

    if (count == 0) {
      //await database!.rawInsert('INSERT INTO urmy_chatlist(chatroomId, sender, receiver, msgcontent, msgtype, msgtimestamp) '
      //    'VALUES(${data.chatroomId}, ${data.sender}, ${data.receiver},${data.msgcontent},${data.msgtype}, ${data.msgtimestamp})'
      //);
      await database!.insert('urmy_chatlist',
        {
          "chatroomId" : data.chatroomId,
          "msgcontent" : data.msgcontent,
          "msgtype" : data.msgtype,
          "msgtimestamp" : data.msgtimestamp!.toIso8601String(),
        },
      );
    }


    List<Map<String, Object?>> records = await database!.query(
        data.chatroomId.toString()
    );
    print("saveChatdata: " + records.toString());
  }

  Future<void> deleteChatroom(String chatroomid) async {
    database!.execute('DROP TABLE ${chatroomid}');
  }

}
