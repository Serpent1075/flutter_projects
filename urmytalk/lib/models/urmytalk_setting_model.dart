import 'package:hive/hive.dart';

import 'models.dart';
import 'dart:convert';

part 'urmytalk_setting_model.g.dart';

String settingsToJson(UrMySettings data) => json.encode(data.toJson());
UrMySettings settingsFromJson(String data) => UrMySettings.fromJson(json.decode(data));

@HiveType(typeId: 15)
class UrMySettings extends HiveObject{
  UrMySettings({
    required this.min,
    required this.max,
    required this.delreq,
    required this.autologin,
    required this.needprofileupdate,
    this.introduction,
  });

  @HiveField(0)
  int min;
  @HiveField(1)
  int max;
  @HiveField(2)
  bool delreq;
  @HiveField(3)
  bool autologin;
  @HiveField(4)
  int needprofileupdate;
  @HiveField(5)
  bool? introduction;



  factory UrMySettings.fromJson(Map<String, dynamic> json) => UrMySettings(
    min: json["Min"],
    max: json["Max"],
    delreq: json["Delreq"],
    autologin : json["Autologin"],
    needprofileupdate : json["CheckProfileUpdate"]
  );

  Map<String, dynamic> toJson() => {
    "Min": min,
    "Max": max,
    "Delreq" : delreq,
    "Autologin" : autologin,
    "CheckProfileUpdate" : needprofileupdate
  };
}

