import 'dart:math';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';



// For Chatlist Functions

String readTimestamp(int timestamp) {
  var now = DateTime.now();
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  var diff = now.difference(date);
  var time = '';

  if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
    if (diff.inHours > 0) {
      time = diff.inHours.toString() + 'h ago';
    }else if (diff.inMinutes > 0) {
      time = diff.inMinutes.toString() + 'm ago';
    }else if (diff.inSeconds > 0) {
      time = 'now';
    }else if (diff.inMilliseconds > 0) {
      time = 'now';
    }else if (diff.inMicroseconds > 0) {
      time = 'now';
    }else {
      time = 'now';
    }
  } else if (diff.inDays > 0 && diff.inDays < 7) {
    time = diff.inDays.toString() + 'd ago';
  } else if (diff.inDays > 6){
    time = (diff.inDays / 7).floor().toString() + 'w ago';
  }else if (diff.inDays > 29) {
    time = (diff.inDays / 30).floor().toString() + 'm ago';
  }else if (diff.inDays > 365) {
    time = '${date.month}-${date.day}-${date.year}';
  }
  return time;
}

String returnTimeStamp(int messageTimeStamp) {
  String resultString = '';
  var format = DateFormat('hh:mm a');
  var date = DateTime.fromMillisecondsSinceEpoch(messageTimeStamp);
  resultString = format.format(date);
  return resultString;
}

String returnDateStamp(int messageTimeStamp) {
  String resultString = '';
  var format = DateFormat('yyyy/MM/dd, EEE');
  var date = DateTime.fromMillisecondsSinceEpoch(messageTimeStamp);
  resultString = format.format(date);
  return resultString;
}

String makeChatId(String myID,String? selectedUserID) {
  String chatID;
  myID = myID.replaceAll("-", "");
  selectedUserID = selectedUserID!.replaceAll("-", "");
  if (myID.hashCode > selectedUserID.hashCode) {
    chatID = 'urmy$selectedUserID$myID';
  }else {
    chatID = 'urmy$myID$selectedUserID';
  }
  return chatID;
}

int countChatListUsers(myID,snapshot) {
  int resultInt = snapshot.data.docs.length;
  for (var data in snapshot.data.docs) {
    if (data['userId'] == myID) {
      resultInt--;
    }
  }

  return resultInt;
}

// For ChatRoom Functions


void setCurrentChatRoomID(value) async { // To know where I am in chat room. Avoid local notification.
  var currentChatRoomstorage = Hive.box('currentChatRoom');

  currentChatRoomstorage.put('currentChatRoom', value);
}

// For main view Functions


String checkValidUserData(userImageFile,userImageUrlFromFB,name,intro) {
  String returnString = '';
  if(userImageFile.path == '' && userImageUrlFromFB == '') {
    returnString = returnString + 'Please select a image.';
  }

  if(name.trim() == '') {
    if(returnString.trim() != '') {
      returnString = returnString + '\n\n';
    }
    returnString = returnString + 'Please type your name';
  }

  if(intro.trim() == '') {
    if(returnString.trim() != '') {
      returnString = returnString + '\n\n';
    }
    returnString = returnString + 'Please type your intro';
  }
  return returnString;
}

String randomIdWithName(userName){
  int randomNumber = Random().nextInt(100000);
  return '$userName$randomNumber';
}

String genderState(bool gender) {
  if (gender == false) {
    return "Male";
  } else {
    return "Female";
  }
}

String getProfilePicPath(String url, String uuid, String filename) {
  String result = "${url}pic/${uuid.replaceAll("-", "")}/$filename";
  //print("getProfilePicPath : " + result);
  return result;
}

String getAge(String birthdate) {
  //print(birthdate);

  int parsedyear = int.parse(birthdate.substring(0, 4));
  int parsedday = int.parse(birthdate.substring(5,7));
  int parsedmonth = int.parse(birthdate.substring(8,10));
  var now = DateTime.now();
  int age = now.year - parsedyear;
  if (now.isBefore(DateTime(now.year, parsedmonth,parsedday))) {
    age--;
  }
  return age.toString();
}


