// To parse this JSON data, do
//
//     final welcome = welcomeFromMap(jsonString);

import 'dart:convert';

List<Country> countryFromMap(String str) => List<Country>.from(json.decode(str).map((x) => Country.fromMap(x)));

String countryToMap(List<Country> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Country {
  Country({
    this.countryname,
    this.city,
    this.emoji,
    this.emojiU,
  });

  final String? countryname;
  final String? emoji;
  final String? emojiU;
  final List<City>? city;

  factory Country.fromMap(Map<String, dynamic> json) => Country(
    countryname: json["countryname"],
    emoji: json["emoji"],
    emojiU: json["emojiU"],
    city: List<City>.from(json["city"].map((x) => City.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "countryname": countryname,
    "emoji" : emoji,
    "emojiU" : emojiU,
    "city": List<dynamic>.from(city!.map((x) => x.toMap())),
  };

  String countryAsString() {
    return "${emoji!}  ${countryname!}";
  }

  bool? countryFilterByName(String? filter) {
    filter ??= "";
    return countryname!.contains(filter);
  }

  bool? isEqual(Country country) {
    return countryname == country.countryname;
  }

  String? getName() => countryname;

}

class City {
  City({
    this.cityname,
    this.gmt,
    this.sign,
    this.hour,
    this.min,
  });

  final String? cityname;
  final String? gmt;
  final bool? sign;
  final int? hour;
  final int? min;

  factory City.fromMap(Map<String, dynamic> json) => City(
    cityname: json["cityname"],
    gmt: json["gmt"],
    sign: json["sign"],
    hour: json["hour"],
    min: json["min"],
  );

  Map<String, dynamic> toMap() => {
    "cityname": cityname,
    "gmt": gmt,
    "sign": sign,
    "hour": hour,
    "min": min,
  };

  String cityAsString() {
    return cityname!;
  }

  bool cityFilterByName(String? filter) {
    filter ??= "";
    return cityname!.contains(filter);
  }

  bool? isEqual(City city) {
    return cityname == city.cityname;
  }

  String? getName() => cityname;

}
