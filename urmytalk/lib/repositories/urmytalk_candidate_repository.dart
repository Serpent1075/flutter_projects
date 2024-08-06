import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:urmytalk/main.dart';
import 'package:urmytalk/models/models.dart';
import 'package:urmytalk/provider/providers.dart';
import 'package:urmytalk/urmyexception/exceptions.dart';

import '../utils/utils.dart';

class CandidateRepository {
  late final Ref ref;
  var urmytokenstorage = Hive.box<UrMyToken>('accesstoken');
  var settingdatastorage = Hive.box<UrMySettings>('settings');

  CandidateRepository({required this.ref});

  Future<Candidateslist> listcandidate() async {
    final String baseUrl = ref.read(appConfigProvider.notifier).state.baseUrl;

    var url = Uri.parse('$baseUrl/v3/listcandidatelist');
    var accesstoken = urmytokenstorage.get('accesstoken');

    final http.Response response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'authtoken': accesstoken!.token,
        'firebasetoken' : accesstoken.firebasetoken,
      },
    );


    checkStatusCode(response.statusCode);
    if (response.statusCode != 200) {
      throw Exception('Fail to login');
    } else {
      var result = candidatelistFromJson(response.body);

      return result;
    }
  }


  Candidateslist filterAgeCandidatelist(Candidateslist candilist) {
    var settings = settingdatastorage.get("settings");

    for (int i=0; i<candilist.candidatelist!.length; i++) {
      int birthyear = int.parse(getAge(candilist.candidatelist![i].candidateBirthDate!));
       if ( birthyear < settings!.min ) {
        candilist.candidatelist!.removeAt(i);
        i = 0;
       }
      if (birthyear > settings.max) {
        candilist.candidatelist!.removeAt(i);
        i = 0;
       }

    }
    if (candilist.candidatelist!.length == 1) {
      int birthyear = int.parse(getAge(candilist.candidatelist![0].candidateBirthDate!));
      if ( birthyear < settings!.min ) {
        candilist.candidatelist!.removeAt(0);

      }
      if (birthyear > settings.max) {
        candilist.candidatelist!.removeAt(0);
      }
    }
    return candilist;
  }

  Future<int> checknumberofcandidate() async {
    final String baseUrl = ref.read(appConfigProvider.notifier).state.baseUrl;

    var url = Uri.parse('$baseUrl/v3/numberofoppositesex');


    var accesstoken = urmytokenstorage.get('accesstoken');

    final http.Response response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'authtoken': accesstoken!.token,
        'firebasetoken' : accesstoken.firebasetoken,
      },
    );

    checkStatusCode(response.statusCode);
    if (response.statusCode != 200) {
      return 0;
    } else {
      var responseBody = json.decode(response.body);
      return responseBody["count"];
    }
  }

  Future<int> checknumberofurmy() async {
    final String baseUrl = ref.read(appConfigProvider.notifier).state.baseUrl;

    var url = Uri.parse('$baseUrl/v3/numberofurmy');


    var accesstoken = urmytokenstorage.get('accesstoken');

    final http.Response response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'authtoken': accesstoken!.token
      },
    );

    checkStatusCode(response.statusCode);
    var responseBody = json.decode(response.body);
    if (response.statusCode != 200) {
      return 0;
    } else {
      return responseBody["count"];
    }
  }

  Future<Candidateslist> getFriendlist() async {
    final String baseUrl = ref.read(appConfigProvider.notifier).state.baseUrl;

    var url = Uri.parse('$baseUrl/v3/listfriendlist');

    var accesstoken = urmytokenstorage.get('accesstoken');

    final http.Response response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'authtoken': accesstoken!.token,
        'firebasetoken' : accesstoken.firebasetoken,
      },
    );


    if (response.statusCode != 200) {
      throw Exception('Fail to login');
    } else {
      var result = candidatelistFromJson(response.body);
      return result;
    }
  }

  Future<Candidateslist> addFriendlist(Candidates friend) async {
    final String baseUrl = ref.read(appConfigProvider.notifier).state.baseUrl;

    var url = Uri.parse('$baseUrl/v3/addfriendlist');

    var accesstoken = urmytokenstorage.get('accesstoken');

    final http.Response response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'authtoken': accesstoken!.token,
        'firebasetoken' : accesstoken.firebasetoken,
      },
      body: jsonEncode({
        'CandidateUUID': friend.candidateUuid,
        'HostGrade': friend.hostGrade,
        'OpponentGrade' : friend.opponentGrade,
        'ResultRecord' : List<dynamic>.from(friend.resultrecord!.map((x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
      })
    );
    if (response.statusCode != 200) {
      throw Exception('Fail to login');
    } else {

      var result = candidatelistFromJson(response.body);
      return result;
    }
  }

  Future<Candidateslist> addAnonymousFriendlist(String uuid) async {
    final String baseUrl = ref.read(appConfigProvider.notifier).state.baseUrl;

    var url = Uri.parse('$baseUrl/v3/addanonymousfriendlist');

    var accesstoken = urmytokenstorage.get('accesstoken');

    final http.Response response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'authtoken': accesstoken!.token,
          'firebasetoken' : accesstoken.firebasetoken,
        },
        body: jsonEncode({
          'CandidateUUID': uuid,
        })
    );
    if (response.statusCode != 200) {
      throw Exception('Fail to login');
    } else {

      var result = candidatelistFromJson(response.body);
      return result;
    }
  }

  Future<Candidateslist> deleteFriendList(Candidates friend) async {
    final String baseUrl = ref.read(appConfigProvider.notifier).state.baseUrl;

    var url = Uri.parse('$baseUrl/v3/deletefriendlist');

    var accesstoken = urmytokenstorage.get('accesstoken');

    final http.Response response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'authtoken': accesstoken!.token,
          'firebasetoken' : accesstoken.firebasetoken,
        },
        body: jsonEncode({'CandidateUUID': friend.candidateUuid})
    );

    if (response.statusCode != 200) {
      throw Exception('Fail to login');
    } else {

      var result = candidatelistFromJson(response.body);
      return result;
    }
  }

  Future<Candidateslist> getBlackList() async {
    final String baseUrl = ref.read(appConfigProvider.notifier).state.baseUrl;

    var url = Uri.parse('$baseUrl/v3/listblacklist');

    var accesstoken = urmytokenstorage.get('accesstoken');

    final http.Response response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'authtoken': accesstoken!.token,
          'firebasetoken' : accesstoken.firebasetoken,
        },
        );

    checkStatusCode(response.statusCode);
    if (response.statusCode != 200) {
      throw Exception('Fail to login');
    } else {
    var result = candidatelistFromJson(response.body);
    return result;
    }
  }

  Future<Candidateslist> addBlacklist(Candidates blacklist) async {
    final String baseUrl = ref.read(appConfigProvider.notifier).state.baseUrl;

    var url = Uri.parse('$baseUrl/v3/addblacklist');

    var accesstoken = urmytokenstorage.get('accesstoken');

    final http.Response response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'authtoken': accesstoken!.token,
          'firebasetoken' : accesstoken.firebasetoken,
        },
        body: jsonEncode({
          'CandidateUUID': blacklist.candidateUuid,
          'HostGrade': blacklist.hostGrade,
          'OpponentGrade' : blacklist.opponentGrade,
        })
    );

    if (response.statusCode != 200) {
      throw Exception('Fail to login');
    } else {

      var result = candidatelistFromJson(response.body);
      return result;
    }
  }

  Future<Candidateslist> deleteBlackList(Candidates blacklist) async {
    final String baseUrl = ref.read(appConfigProvider.notifier).state.baseUrl;

    var url = Uri.parse('$baseUrl/v3/deleteblacklist');

    var accesstoken = urmytokenstorage.get('accesstoken');

    final http.Response response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'authtoken': accesstoken!.token,
          'firebasetoken' : accesstoken.firebasetoken,
        },
        body: jsonEncode({'CandidateUUID': blacklist.candidateUuid})
    );

    if (response.statusCode != 200) {
      throw Exception('Fail to login');
    } else {

      var result = candidatelistFromJson(response.body);
      return result;
    }
  }

  Future<void> sendcandidatereport(String? candidateuuid, String type, String contents) async {
    final String baseUrl = ref.read(appConfigProvider.notifier).state.baseUrl;

    var accesstoken = urmytokenstorage.get('accesstoken');

    var reporturl = Uri.parse('$baseUrl/v3/insertcandidatereport');
    final http.Response response = await http.post(
      reporturl,
      headers: {
        'authtoken': accesstoken!.token,
        'firebasetoken' : accesstoken.firebasetoken,
      },
      body: json.encode(
        {
          'reporttype' : type,
          'reporteduser' : candidateuuid,
          'contents' : contents,
        },
      ),
    );

    if (response.statusCode == 200) {
      return;
    }

  }

  void checkStatusCode(int code) {
    switch (code) {
      case 401:
        throw UrMyTokenExpiredException("TokenExpired");
      case 500:
        throw UrMyTokenExpiredException("TokenDeleted");
    }
  }
}
