import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:hive/hive.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:urmytalk/models/models.dart';
import 'package:urmytalk/provider/providers.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:urmytalk/urmyexception/exceptions.dart';

class SignUpRepository {
  late final Ref ref;
  var urmytokenstorage = Hive.box<UrMyToken>('accesstoken');
  var settingdatastorage = Hive.box<UrMySettings>('settings');
  final authstorage = const FlutterSecureStorage();
  SignUpRepository({required this.ref});



  Future<int> SignUp(UrData urdata) async{
    final String baseUrl = ref.read(appConfigProvider.notifier).state.baseUrl;
    Map<String, dynamic> deviceInfo = await _getDeviceInfo();
    var accesstoken = await urmytokenstorage.get('accesstoken');
    var url = Uri.parse('$baseUrl/ping');
    final http.Response healthcheck = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (healthcheck.statusCode != 200) {
      throw Exception("Server is not responding");
    }
    Map<String,String> email = await retrieveData("email");
    Map<String,String> loginuuid = await retrieveData("uuid");
    var signinurl = Uri.parse('$baseUrl/v4/signup');
    final http.Response response = await http.post(
      signinurl,
      headers: {
        'Content-Type': 'application/json',
        'firebasetoken' : accesstoken!.firebasetoken,
      },
      body: jsonEncode(
        {
          'deviceos' : "${deviceInfo['os']}:${deviceInfo['device']}",
          'loginId': email['email'],
          'userUid': loginuuid['uuid'],
          'name' : urdata.name,
          'genderState' : urdata.genderState,
          'birthdate': urdata.birthdate,
          'mbti' : urdata.mbti,
          'description' : urdata.description,
          'country' : urdata.country,
          'city' : urdata.city,
          'isoverage' : urdata.isoverage,
          'privacy': urdata.privacy,
          'service': urdata.service,
          'illegal': urdata.illegal,
        },
      ),
    );

    switch(response.statusCode) {
      case 201:
        return 201;
      case 401:
        return 401;
      case 406:
        return 406;
      default:
        throw Exception('Fail to register');
    }

/*
    if (filepath != null || filepath != "") {

    }
*/
  }

  Future<void> insertPropic(String? filepath) async {
    final String baseUrl = ref.read(appConfigProvider.notifier).state.baseUrl;
    var url = Uri.parse('$baseUrl/v2/insertpropic');
    var accesstoken = urmytokenstorage.get('accesstoken');

    var request = http.MultipartRequest("POST", url);
    request.headers['authtoken'] = accesstoken!.token;
    request.headers['firebasetoken'] = accesstoken.firebasetoken;
    request.fields["key"] = "image";

    var pic = await http.MultipartFile.fromPath("profile", filepath!);
    //add multipart to request
    request.files.add(pic);
    await request.send();
  }

  Future<Map<String,String>> retrieveData(String keyname) async {
    String? value = "";
    if(Platform.isAndroid){
      AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: false,
      );
      value = await authstorage.read(key: keyname, aOptions: _getAndroidOptions());

    } else if (Platform.isIOS) {
      const options = IOSOptions(accessibility: KeychainAccessibility.unlocked);
      value = await authstorage.read(key: keyname, iOptions: options);
    }

    Map<String, String> result = {
      keyname : value!,
    };
    return result;
  }

  Future<Map<String, dynamic>> _getDeviceInfo() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    Map<String, dynamic> deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidDeviceInfo(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } catch(error) {
      deviceData = {
        "Error": "Failed to get platform version."
      };
    }

    return deviceData;
  }

  Map<String, dynamic> _readAndroidDeviceInfo(AndroidDeviceInfo info) {
    var release = info.version.release;
    var sdkInt = info.version.sdkInt;
    var manufacturer = info.manufacturer;
    var model = info.model;

    return {
      "os": "$release:$sdkInt",
      "device": "$manufacturer:$model"
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo info) {
    var systemName = info.systemName;
    var version = info.systemVersion;
    var machine = info.utsname.machine;

    return {
      "os": "$systemName:$version",
      "device": "$machine"
    };
  }
}
