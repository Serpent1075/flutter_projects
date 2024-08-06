class UrMyTalkServiceList {

  String? serviceid;
  String? servicename;
  String? serviceprice;


  UrMyTalkServiceList({
    this.serviceid,
    this.servicename,
    this.serviceprice,
  });

  factory UrMyTalkServiceList.fromJson(Map<dynamic, dynamic> parsedJson) {
    return UrMyTalkServiceList(
      serviceid: parsedJson['ServiceUUID'],
      servicename: parsedJson['ServiceName'],
      serviceprice: parsedJson['ServicePrice'],
    );
  }

  Map<String, dynamic> toJson() => {
    "ServiceUUID": serviceid,
    "ServiceName": servicename,
    "ServicePrice": serviceprice,
  };

  Map<dynamic, dynamic> toMap() {
    return {
      "ServiceUUID": serviceid,
      "ServiceName": servicename,
      "ServicePrice": serviceprice,
    };
  }
}