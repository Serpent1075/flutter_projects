import 'models.dart';
import 'dart:convert';

Inquirylist inquirylistFromJson(String str) =>
    Inquirylist.fromJson(json.decode(str));

class Inquirylist {
  Inquirylist({
    this.inquirylist,
  });

  List<Inquiry>? inquirylist = [];

  factory Inquirylist.fromJson(Map<String, dynamic> json) => Inquirylist(
    inquirylist: List<Inquiry>.from(
        json["inquirylist"].map((x) => Inquiry.fromJson(x))),
  );
}

class Inquiry {
  Inquiry({
    this.caseid = '',
    this.inquirytype = '',
    this.title = '',
    this.inquirystate = '',
  });

  String? caseid;
  String? inquirytype;
  String? title;
  String? inquirystate;

  factory Inquiry.fromJson(Map<String, dynamic> json) => Inquiry(
    caseid: json["caseid"].toString().trim(),
    inquirytype: json["inquirytype"].toString().trim(),
    title: utf8.decode(base64.decode(json["title"].toString().trim())),
    inquirystate: json["inquirystate"].toString().trim(),
  );
}


InquiryContentlist inquiryContentlistFromJson(String str) =>
    InquiryContentlist.fromJson(json.decode(str));

class InquiryContentlist {
  InquiryContentlist({
    this.inquirycontentlist,
  });

  List<InquiryContent>? inquirycontentlist = [];

  factory InquiryContentlist.fromJson(Map<String, dynamic> json) => InquiryContentlist(
    inquirycontentlist: List<InquiryContent>.from(
        json["inquirycontentlist"].map((x) => InquiryContent.fromJson(x))),
  );
}

class InquiryContent {
  InquiryContent({
    this.contents = '',
    this.registereddate,
    this.managerid = '',
  });

  String? contents;
  String? managerid;
  DateTime? registereddate;


  factory InquiryContent.fromJson(Map<String, dynamic> json) => InquiryContent(
    managerid: json['managerid'].toString().trim(),
    contents: utf8.decode(base64.decode(json["contents"].toString().trim())),
    registereddate: DateTime.parse(json["registereddate"]),
  );
}
