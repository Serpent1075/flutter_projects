import 'dart:convert';

import 'package:hive/hive.dart';
import 'models.dart';

part 'urmytalk_user_model.g.dart';

UrData trasferFromJson(String str) =>
    UrData.fromJson(json.decode(str));

String urdatatransferToJson(UrData data) =>
    json.encode(data.toJson());


class AuthData {
  String email;
  String password;
  String uuid;
  String authtype;


  AuthData({
    required this.email,
    required this.password,
    required this.uuid,
    required this.authtype
  });

  factory AuthData.fromJson(Map<String, dynamic> parsedJson) {
    return AuthData(
      email: parsedJson['Email'].toString().trim(),
      password: parsedJson['Password'].toString().trim(),
      uuid: parsedJson['Uuid'].toString().trim(),
      authtype: parsedJson['Authtype'].toString().trim()
    );
  }

  Map<dynamic, dynamic> toMap() {
    return {
      'loginId': email,
      'password': password,
    };
  }
}

class UrData {
  String? uuid;
  String? email;
  String? name;
  bool? genderState;
  String? mbti;
  String? birthdate;
  String? phoneNo;
  String? phonecode;
  String? description;
  String? country;
  String? city;
  String? currentcountry;
  String? currentstate;
  String? currentcity;
  List<UrMyProfilePicData>? imageFile;
  Saju? saju;
  UrMySettings? settings;
  bool? isoverage;
  bool? privacy;
  bool? service;
  bool? illegal;


  UrData({
    this.uuid = '',
    this.email = '',
    this.name = '',
    this.genderState = true,
    this.birthdate = '',
    this.mbti = '',
    this.phoneNo = '',
    this.phonecode = '',
    this.description = '',
    this.country = '',
    this.city = '',
    this.currentcountry = '',
    this.currentstate = '',
    this.currentcity = '',
    this.imageFile,
    this.settings,
    this.isoverage = false,
    this.privacy = false,
    this.service = false,
    this.illegal = false,
    this.saju
  });


  factory UrData.fromJson(Map<String, dynamic> parsedJson) {

    return UrData(
      uuid: parsedJson['LoginUuid'].toString().trim(),
      name: utf8.decode(base64.decode(parsedJson['Name'].toString().trim())),
      genderState: parsedJson['Gender'],
      birthdate: "${parsedJson['Birthdate'].toString().substring(0,4)}.${parsedJson['Birthdate'].toString().substring(4,6)}.${parsedJson['Birthdate'].toString().substring(6,8)}",
      mbti: parsedJson['Mbti'].trim(),
      description : utf8.decode(base64.decode(parsedJson['Description'].toString().trim())),
      country: parsedJson['Country'] == null ? "" : parsedJson['Country'].trim(),
      city: parsedJson['City'] == null ? "" : parsedJson['City'].trim(),
      currentcountry: parsedJson['CurrentCountry']["String"].toString().contains("none")  ? "" : parsedJson['CurrentCountry']["String"].toString().trim(),
      currentstate: parsedJson['CurrentState']["String"].toString().contains("none") ? "" : parsedJson['CurrentState']["String"].toString().trim(),
      currentcity: parsedJson['CurrentCity']["String"].toString().contains("none") ? "" : parsedJson['CurrentCity']["String"].toString().trim(),
      phonecode: parsedJson['PhoneCode'] == null ? "" : parsedJson['PhoneCode'].toString().trim(),
      saju : parsedJson['SajuPalja'] == null ? null : Saju.fromJson(parsedJson["SajuPalja"]),
      imageFile: parsedJson['ProfilePicPath'] == null
          ? null
          : List<UrMyProfilePicData>.from(parsedJson["ProfilePicPath"]
              .map((x) => UrMyProfilePicData.fromMap(x))),
    );
  }

  Map<dynamic, dynamic> toMap() {
    return {
      'name': name,
      'gender': genderState,
      'birthdate': birthdate,
      'isoverage': isoverage,
      'privacy': privacy,
      'service': service,
      'illegal': illegal,
    };
  }

  Map<String, dynamic> toJson() => {
    "loginuuid": uuid,
    "email": name,
    "phoneno": phoneNo,
    "phonecode": phonecode,
    "name": name,
    "birthday": birthdate,
    "gender": genderState,
    "mbti": mbti,
    "description" : description,
    'country' : country,
    'city' : city
  };
}

class Saju {
  String? yearChun;
  String? yearJi;
  String? monthChun;
  String? monthJi;
  String? dayChun;
  String? dayJi;
  String? timeChun;
  String? timeJi;

  Saju({
    this.yearChun,
    this.yearJi,
    this.monthChun,
    this.monthJi,
    this.dayChun,
    this.dayJi,
    this.timeChun,
    this.timeJi
  });

  factory Saju.fromJson(Map<String, dynamic> parsedJson) {
    return Saju(
        yearChun: utf8.decode(base64.decode(parsedJson['YearChun'].toString().trim())),
        yearJi: utf8.decode(base64.decode(parsedJson['YearJi'].toString().trim())),
        monthChun: utf8.decode(base64.decode(parsedJson['MonthChun'].toString().trim())),
        monthJi: utf8.decode(base64.decode(parsedJson['MonthJi'].toString().trim())),
        dayChun: utf8.decode(base64.decode(parsedJson['DayChun'].toString().trim())),
        dayJi: utf8.decode(base64.decode(parsedJson['DayJi'].toString().trim())),
        timeChun: utf8.decode(base64.decode(parsedJson['TimeChun'].toString().trim())),
        timeJi: utf8.decode(base64.decode(parsedJson['TimeJi'].toString().trim())),
    );
  }
}

@HiveType(typeId: 10)
class UrMyToken extends HiveObject {
  @HiveField(0)
  String token;
  @HiveField(1)
  String firebasetoken;

  UrMyToken({
    required this.token,
    required this.firebasetoken,
  });
}
