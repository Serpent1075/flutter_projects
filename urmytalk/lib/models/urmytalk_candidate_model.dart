

import 'models.dart';
import 'dart:convert';

Candidateslist candidatelistFromJson(String str) =>
    Candidateslist.fromJson(json.decode(str));

String candidatelistToJson(Candidateslist data) => json.encode(data.toJson());
String candidatesToJson(Candidates data) => json.encode(data.toJson());
class Candidateslist {
  Candidateslist({
    this.candidatelist,
  });

  List<Candidates>? candidatelist = [];

  factory Candidateslist.fromJson(Map<String, dynamic> json) => Candidateslist(
    candidatelist: List<Candidates>.from(
        json["candidatelist"].map((x) => Candidates.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "candidatelist": candidatelist == null
        ? null
        : List<dynamic>.from(candidatelist!.map((x) => x.toJson())),
  };
}

class Candidates {
  Candidates({
    this.candidateUuid = '',
    this.candidateName = '',
    this.candidateBirthDate,
    this.candidateGender,
    this.candidateMbti,
    this.hostGrade,
    this.opponentGrade,
    this.contentUrl = '',
    this.profilePicPath,
    this.description,
    this.country,
    this.statevalue,
    this.city,
    this.resultrecord,
  });

  String? candidateUuid;
  String? candidateName;
  String? candidateBirthDate;
  bool? candidateGender;
  String? candidateMbti;
  String? hostGrade;
  String? opponentGrade;
  String? contentUrl;
  String? description;
  String? country;
  String? statevalue;
  String? city;


  List<Map<String,int>>? resultrecord;
  List<UrMyProfilePicData>? profilePicPath;

  factory Candidates.fromJson(Map<String, dynamic> json) => Candidates(
    candidateUuid: json["CandidateUUID"].toString().trim(),
    candidateName: utf8.decode(base64.decode(json["CandidateName"].toString().trim())),
    candidateBirthDate: "${json['CandidateBirthDate'].toString().substring(0,4)}.${json['CandidateBirthDate'].toString().substring(4,6)}.${json['CandidateBirthDate'].toString().substring(6,8)}",
    candidateGender: json["CandidateGender"] == "false" ? false : true,
    candidateMbti: json["CandidateMBTI"].toString().trim(),
    hostGrade: json["HostGrade"].toString().trim(),
    opponentGrade: json["OpponentGrade"].toString().trim(),
    description: utf8.decode(base64.decode(json["Description"].toString().trim())),
    country: json["CandidateCountry"].toString().trim(),
    statevalue: json["CandidateState"].toString().trim(),
    city: json["CandidateCity"].toString().trim(),
    contentUrl: json["ContentUrl"].toString().trim(),
    resultrecord: json["ResultRecord"] == null ? null : List<Map<String, int>>.from(json["ResultRecord"].map((x) => Map.from(x).map((k, v) => MapEntry<String, int>(k, v)))),
    profilePicPath: json["ProfilePicPath"] == null
        ? null
        : List<UrMyProfilePicData>.from(
        json["ProfilePicPath"].map((x) => UrMyProfilePicData.fromJson(x))),
  );



  Map<String, dynamic> toJson() => {
    "CandidateUUID": candidateUuid,
    "CandidateName": candidateName,
    "CandidateBirthDate": candidateBirthDate!,
    "CandidateGender": candidateGender,
    "CandidateMBTI": candidateMbti,
    "Description" : description,
    "CandidateCountry" : country,
    "CandidateState" : statevalue,
    "CandidateCity" : city,
    "HostGrade" : hostGrade,
    "OpponentGrade" : opponentGrade,
    "ResultRecord" : resultrecord  == null
        ? null
        : List<dynamic>.from(resultrecord!.map((x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
    "ProfileUrl": contentUrl,
    "ProfilePicPath": profilePicPath == null
        ? null
        : List<dynamic>.from(profilePicPath!.map((x) => x.toJson())),
  };
}
