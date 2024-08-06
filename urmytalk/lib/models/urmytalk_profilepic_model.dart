import 'dart:convert';

UrMyProfilepiclist urmytalkProfileFromMap(String str) => UrMyProfilepiclist.fromMap(json.decode(str));

String urmytalkProfileToMap(UrMyProfilepiclist data) => json.encode(data.toMap());

class UrMyProfilepiclist {
  UrMyProfilepiclist({
    this.profilepiclist,
  });

  final List<UrMyProfilePicData>? profilepiclist;

  factory UrMyProfilepiclist.fromMap(Map<String, dynamic> json) =>  json["profilepiclist"] == null ? UrMyProfilepiclist(profilepiclist: []) : UrMyProfilepiclist(
    profilepiclist: List<UrMyProfilePicData>.from(json["profilepiclist"].map((x) => UrMyProfilePicData.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "profilepiclist": List<dynamic>.from(profilepiclist!.map((x) => x.toMap())),
  };
}

class UrMyProfilePicData {
  String? filename;
  DateTime? uploadeddate;
  int? profilesequence;

  UrMyProfilePicData({
    this.filename,
    this.uploadeddate,
    this.profilesequence,
  });

  factory UrMyProfilePicData.fromMap(Map<String, dynamic> parsedJson) => UrMyProfilePicData(
    filename: parsedJson['Filename'].toString().trim(),
    uploadeddate: DateTime.parse(parsedJson['UploadedDate']),
    profilesequence: parsedJson['ProfileSequence'],
  );


  Map<String, dynamic> toMap() => {
    "Filename": filename,
    "UploadedDate": uploadeddate!.toIso8601String(),
    "ProfileSequence": profilesequence,
  };

  factory UrMyProfilePicData.fromJson(Map<String, dynamic> json) => UrMyProfilePicData(
    filename: json["Filename"].toString().trim(),
    uploadeddate: DateTime.parse(json["UploadedDate"]),
    profilesequence: json["ProfileSequence"],
  );

  Map<String, dynamic> toJson() => {
    "Filename": filename,
    "UploadedDate": uploadeddate!.toIso8601String(),
    "ProfileSequence": profilesequence,
  };
}