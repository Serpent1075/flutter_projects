
import 'dart:convert';

ServicePurchasedList servicepurchasedlistFromJson(String str) =>
    ServicePurchasedList.fromJson(json.decode(str));

String servicepurchasedlistToJson(ServicePurchasedList data) => json.encode(data.toJson());
String servicepurchasedToJson(ServicePurchased data) => json.encode(data.toJson());
class ServicePurchasedList {
  ServicePurchasedList({
    this.servicelist,
  });

  List<ServicePurchased>? servicelist = [];

  factory ServicePurchasedList.fromJson(Map<String, dynamic> json) => ServicePurchasedList(
    servicelist: List<ServicePurchased>.from(
        json["servicepurchased"].map((x) => ServicePurchased.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "servicepurchased": servicelist == null
        ? null
        : List<dynamic>.from(servicelist!.map((x) => x.toJson())),
  };
}

class ServicePurchased {
  ServicePurchased({
    this.serviceid,
    this.purchaseddate ,
  });

  String? serviceid;
  DateTime? purchaseddate;

  factory ServicePurchased.fromJson(Map<String, dynamic> json) => ServicePurchased(
    serviceid: json["ServiceId"].toString().trim(),
    purchaseddate: DateTime.parse(json["PurchasedDate"].toString().trim()),
  );

  Map<String, dynamic> toJson() => {
    "ServiceId": serviceid,
    "PurchasedDate": purchaseddate,
  };
}

