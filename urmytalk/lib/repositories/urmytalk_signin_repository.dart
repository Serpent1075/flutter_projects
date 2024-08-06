import 'dart:convert';
import 'dart:io' show Platform;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:urmytalk/provider/providers.dart';
import 'package:urmytalk/models/models.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:urmytalk/urmyexception/exceptions.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class SignInRepository {
  late final Ref ref;
  var urmytokenstorage = Hive.box<UrMyToken>('accesstoken');
  var settingdatastorage = Hive.box<UrMySettings>('settings');
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  final authstorage = const FlutterSecureStorage();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  late Stream<FileResponse?> fileStream;
  SignInRepository({required this.ref});



  Future<int> autologin() async {
    Map<String,String> type = await retrieveData("type");
    try {
      switch (type["type"]) {
        case "google":
          return await googleSingIn();
        case "apple":
          return await appleSingIn();
        case "normal":
          Map<String,String> email = await retrieveData("email");
          Map<String,String> password = await retrieveData("password");
          return await normalSingIn(email['email']!, password['password']!);
      }
      return 30;
    } on UrMyPMException {
      throw UrMyPMException("pm time");
    }catch (e) {
      throw UrMyAutoLoginException("autologinerror");
    }

  }

  Future<bool> checkAutologin() async {
    var settings = settingdatastorage.get('settings');
    if (settings == null) {
      return false;
    }
    return settings.autologin;
  }

  bool checkIntro() {
    var settings = settingdatastorage.get('settings');
    if (settings == null) {
      return false;
    } else if (settings.introduction == null){
      return false;
    }else {
      return settings.introduction!;
    }
  }

  Future<void> doneIntro() async {
    var settings = UrMySettings(
      introduction: true,
      min: 0,
      max: 0,
      delreq: false,
      autologin: false,
      needprofileupdate: 0,
    );
    await settingdatastorage.put('settings', settings);
  }



  Future<int> appleSingIn() async {
    final String baseUrl = ref.read(appConfigProvider.notifier).state.baseUrl;
    var signinurl = Uri.parse('$baseUrl/v1/checkneedinsert');
    var setting = await settingdatastorage.get('settings');



    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        clientId: "com.urmycorp.urmytalk.apple",
        redirectUri: Uri.parse(
            "https://urmytalk-prod.firebaseapp.com/__/auth/handler"),
      ),
    );
/*
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    */
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    final auth.UserCredential authResult = await _auth.signInWithCredential(oauthCredential);

    final http.Response response = await http.post(
      signinurl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {
          'loginId': authResult.user!.email,
          'userUid': authResult.user!.uid,
        },
      ),
    ).timeout(const Duration(seconds: 5));

    int needprofileupdate;

    if(response.statusCode == 201) {
      needprofileupdate = 10;
    } else if (response.statusCode == 202) {
      needprofileupdate = 20;
    } else if (response.statusCode == 510){
      throw UrMyPMException("pmtime");
    }else {
      needprofileupdate = 0;
    }

    var responseBody = json.decode(response.body);
    var firebasetoken = await auth.FirebaseAuth.instance.currentUser!.getIdToken();
    /*
    if(responseBody['newuuid'] != null) {
      AuthData authdata = AuthData(email: authResult.user!.email!, password: "", uuid: authResult.user!.uid, authtype: "apple");
      await saveData(authdata);
    }
    if(responseBody['currentuuid'] != null) {
      AuthData authdata = AuthData(email: authResult.user!.email!, password: "", uuid: authResult.user!.uid, authtype: "apple");
      await saveData(authdata);
    }
     */
    AuthData authdata = AuthData(email: authResult.user!.email!, password: "", uuid: authResult.user!.uid, authtype: "apple");
    await saveData(authdata);

    if (responseBody['authtoken'] != null) {
      UrMyToken token = UrMyToken(token: responseBody["authtoken"].toString().trim(), firebasetoken: firebasetoken);
      urmytokenstorage.put('accesstoken', token);
    }


    setting = UrMySettings(
      introduction: true,
      min: 0,
      max: 0,
      delreq: false,
      autologin: false,
      needprofileupdate: needprofileupdate,
    );
    await settingdatastorage.put('settings', setting);

    return setting.needprofileupdate;
  }

  Future<int> googleSingIn() async {
    final String baseUrl = ref.read(appConfigProvider.notifier).state.baseUrl;
    var signinurl = Uri.parse('$baseUrl/v1/checkneedinsert');
    var setting = await settingdatastorage.get('settings');

    final GoogleSignInAccount? account = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await account!.authentication;

    final auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final auth.UserCredential authResult = await _auth.signInWithCredential(credential);
    final auth.User? user = authResult.user;

    final http.Response response = await http.post(
      signinurl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {
          'loginId': user!.email,
          'userUid': user.uid,
        },
      ),
    ).timeout(const Duration(seconds: 5));

    int needprofileupdate;

    if(response.statusCode == 201) {
      needprofileupdate = 10;
    } else if (response.statusCode == 202) {
      needprofileupdate = 20;
    } else if (response.statusCode == 510){
      throw UrMyPMException("pmtime");
    }else {
      needprofileupdate = 0;
    }

    var responseBody = json.decode(response.body);
    /*
    if(responseBody['newuuid'] != null) {
      AuthData authdata = AuthData(email: user.email!, password: "", uuid: user.uid,authtype: "google");
      await saveData(authdata);
    }
    if(responseBody['currentuuid'] != null) {
      AuthData authdata = AuthData(email: user.email!, password: "", uuid: user.uid, authtype: "google");
      await saveData(authdata);
    }
     */
    AuthData authdata = AuthData(email: user.email!, password: "", uuid: user.uid, authtype: "google");
    await saveData(authdata);

    if (responseBody['authtoken'] != null) {
      var firebasetoken = await auth.FirebaseAuth.instance.currentUser!.getIdToken();

      UrMyToken token = UrMyToken(token: responseBody["authtoken"].toString().trim(), firebasetoken: firebasetoken);
      urmytokenstorage.put('accesstoken', token);
    }



    setting = UrMySettings(
      introduction: true,
      min: 0,
      max: 0,
      delreq: false,
      autologin: false,
      needprofileupdate: needprofileupdate,
    );

    await settingdatastorage.put('settings', setting);

    return setting.needprofileupdate;
  }

  Future<int> needProfileUpdate(String email, String useruid) async{
    var setting = await settingdatastorage.get('settings');

    if (setting == null) {
      final String baseUrl = ref.read(appConfigProvider.notifier).state.baseUrl;
      var signinurl = Uri.parse('$baseUrl/v1/checkneedinsert');
      final http.Response response = await http.post(
        signinurl,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'loginId': email,
            'userUid': useruid,
          },
        ),
      ).timeout(const Duration(seconds: 5));
      var responseBody = json.decode(response.body);
      return responseBody;
    }else {
      return setting.needprofileupdate;
    }
  }

  Future<int> normalSingIn(String email, String password) async {
    final String baseUrl = ref.read(appConfigProvider.notifier).state.baseUrl;
    var signinurl = Uri.parse('$baseUrl/v1/checkneedinsert');
    var setting = await settingdatastorage.get('settings');
    String? uuid = '';

    try {
      auth.UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      uuid = userCredential.user!.uid;
    } on auth.FirebaseAuthException catch (e) {

      if (e.code == 'user-not-found') {
        uuid = await firebaseSignUp(email,password);
      } else if (e.code == 'wrong-password') {
        throw UrMyWrongPasswordException("wrong-password");
      } else if (e.code =='too-many-requests') {
        throw UrMyTooManyException('too-many-requests');
      }
    }

    final http.Response response = await http.post(
      signinurl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {
          'loginId': email,
          'userUid': uuid,
        },
      ),
    ).timeout(const Duration(seconds: 5));

    int needprofileupdate;

    if(response.statusCode == 201) {
      needprofileupdate = 10;
    } else if (response.statusCode == 202) {
      needprofileupdate = 20;
    } else if (response.statusCode == 510){
      throw UrMyPMException("pmtime");
    }else {
      needprofileupdate = 0;
    }

    var responseBody = json.decode(response.body);
    /*if(responseBody['newuuid'] != null) {
      AuthData authdata = AuthData(email: email, password: password, uuid: uuid!, authtype: "normal");
      await saveData(authdata);
    }
    if(responseBody['currentuuid'] != null) {
      AuthData authdata = AuthData(email: email, password: password, uuid: uuid!, authtype: "normal");
      await saveData(authdata);
    }*/
    AuthData authdata = AuthData(email: email, password: password, uuid: uuid!, authtype: "normal");
    await saveData(authdata);
    if (responseBody['authtoken'] != null) {
      var firebasetoken = await auth.FirebaseAuth.instance.currentUser!.getIdToken();

      UrMyToken token = UrMyToken(token: responseBody["authtoken"].toString().trim(), firebasetoken: firebasetoken);
      urmytokenstorage.put('accesstoken', token);
    }

    setting = UrMySettings(
        introduction: true,
        min: 0,
        max: 0,
        delreq: false,
        autologin: false,
        needprofileupdate: needprofileupdate,
      );
    await settingdatastorage.put('settings', setting);

    return setting.needprofileupdate;
  }

  Future<void> getFirebaseAuthToken() async {
    var firebasetoken = await auth.FirebaseAuth.instance.currentUser!.getIdToken();
    var accesstoken = urmytokenstorage.get('accesstoken');
    UrMyToken token = UrMyToken(token: accesstoken!.token, firebasetoken: firebasetoken);
    urmytokenstorage.put('accesstoken', token);
  }

  Future<String?> firebaseSignUp(String email, String password) async {
    try {
      auth.UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user?.uid;
    } on auth.FirebaseAuthException catch (e) {
      //print("ecode: ${e.code}");
      if (e.code == 'email-already-in-use') {
        throw UrMyEmailAlreadyExistsException(e.toString());
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    return null;
  }

  Future<void> refreshFirebaseToken() async {
    try {
      var firebasetoken = await auth.FirebaseAuth.instance.currentUser!.getIdToken();
      var previoustoken = urmytokenstorage.get('accesstoken');
      UrMyToken token = UrMyToken(token: previoustoken!.token, firebasetoken: firebasetoken);
      urmytokenstorage.put('accesstoken', token);
      } catch (e) {
        return;
    }
  }

  Future<UrData> geturmyuserdata() async {
    final String baseUrl = ref.read(appConfigProvider.notifier).state.baseUrl;
    var accesstoken = urmytokenstorage.get('accesstoken');
    Map<String, String> email = await retrieveData('email');
    //final fcmToken = await FirebaseMessaging.instance.getToken();
    Map<String, dynamic> deviceInfo = await _getDeviceInfo();


    var signinurl = Uri.parse('$baseUrl/v2/getudata');
    final http.Response response = await http.post(
      signinurl,
      headers: {
        'authtoken': accesstoken!.token,
        'firebasetoken' : accesstoken.firebasetoken,
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {
          'loginId': email['email'],
          'notificationtoken' : 'yet',
          'deviceos' : "${deviceInfo['os']}:${deviceInfo['device']}",
          'urmyplatform' : Platform.operatingSystem
        },
      ),
    );
    var responseBody = json.decode(response.body);
    UrData urdata = UrData.fromJson(responseBody["urdata"]);
    urdata.email =  email['email'];
    var settings = settingdatastorage.get("settings");

    int min = DateTime.now().year-int.parse(urdata.birthdate!.substring(0, 4))-12;
    if (min < 19) {
      min = 19;
    }
    if(settings == null) {
      settings = UrMySettings(
        introduction: true,
        min: min,
        max: DateTime.now().year-int.parse(urdata.birthdate!.substring(0, 4))+12,
        delreq: false,
        autologin: true,
        needprofileupdate: 10,
      );
      await settingdatastorage.put("settings", settings);
    } else {
      settings.introduction = true;
      settings.min = min;
      settings.max = DateTime.now().year-int.parse(urdata.birthdate!.substring(0, 4))+12;
      settings.delreq = false;
      settings.autologin = true;
      settings.needprofileupdate = 10;
      await settingdatastorage.put('settings', settings);
    }
    urdata.settings = settings;
    return urdata;
  }

  Future<String> getcfurl() async {

    final String baseUrl = ref.read(appConfigProvider.notifier).state.baseUrl;
    var signinurl = Uri.parse('$baseUrl/v1/getcfurl');
    final http.Response response = await http.post(
      signinurl,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    var responseBody = json.decode(response.body);
    if (response.statusCode == 200) {
      return responseBody['ContentUrl'];
    } else {
      return 'error';
    }
  }

  Future<void> saveData(AuthData authdata) async {
    if(Platform.isAndroid){
      AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: false,
      );
      await authstorage.write(key: "email", value: authdata.email, aOptions: _getAndroidOptions());
      await authstorage.write(key: "password", value: authdata.password, aOptions: _getAndroidOptions());
      await authstorage.write(key: "uuid", value: authdata.uuid, aOptions: _getAndroidOptions());
      await authstorage.write(key: "type", value: authdata.authtype, aOptions: _getAndroidOptions());
    } else if (Platform.isIOS) {
      const options = IOSOptions(accessibility: KeychainAccessibility.unlocked);
      await authstorage.write(key: "email", value: authdata.email, iOptions: options);
      await authstorage.write(key: "password", value: authdata.password, iOptions: options);
      await authstorage.write(key: "uuid", value: authdata.uuid, iOptions: options);
      await authstorage.write(key: "type", value: authdata.authtype, iOptions: options);
    }
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

  Future<void> deleteData() async {
    if(Platform.isAndroid){
      AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: false,
      );
      await authstorage.deleteAll(aOptions: _getAndroidOptions());
    } else if (Platform.isIOS) {
      const options = IOSOptions(accessibility: KeychainAccessibility.unlocked);
      await authstorage.deleteAll(iOptions: options);
    }

  }

  Future<String> firebaseSignIn(String email, String password) async {
    try {
      auth.UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return userCredential.user!.uid;
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        //print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        //print('Wrong password provided for that user.');
      }
    }
    return "";
  }

  


  Future<void> signout() async {
    final String baseUrl = ref.read(appConfigProvider.notifier).state.baseUrl;
    var url = Uri.parse('$baseUrl/v2/signout');

    var accesstoken = urmytokenstorage.get('accesstoken');

    await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'authtoken': accesstoken!.token,
        'firebasetoken' : accesstoken.firebasetoken,
      },
    );


    try {
      await _auth.signOut();
    } on UrMyPMException {
      throw UrMyPMException("pm time");
    }catch (e) {
      throw UrMySignOutException("signouterror");
    }
    urmytokenstorage.delete('accesstoken');
    var settings = settingdatastorage.get("settings");
    settings!.autologin = false;
    settings!.introduction = false;
    settingdatastorage.put("settings", settings);
    await deleteData();
  }
  

  Future<UrData> updateProfile(String key, String value) async {
    if(key=="email") {
      Map<String, String> authdata = await authstorage.readAll();
      try {
        switch (authdata["type"]) {
          case "google":
            final GoogleSignInAccount? account = await googleSignIn.signIn();
            final GoogleSignInAuthentication googleAuth = await account!.authentication;

            final auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken,
              idToken: googleAuth.idToken,
            );

            final auth.UserCredential authResult = await _auth.signInWithCredential(credential);
            final auth.User? user = authResult.user;
            await user?.updateEmail(value);
            break;
          case "apple":
            final appleCredential = await SignInWithApple.getAppleIDCredential(
              scopes: [
                AppleIDAuthorizationScopes.email,
                AppleIDAuthorizationScopes.fullName,
              ],
            );
            final oauthCredential = OAuthProvider("apple.com").credential(
              idToken: appleCredential.identityToken,
              accessToken: appleCredential.authorizationCode,
            );

            final auth.UserCredential authResult = await _auth.signInWithCredential(oauthCredential);
            await authResult.user?.updateEmail(value);
            break;
          case "normal":
            auth.UserCredential userCredential = await _auth.signInWithEmailAndPassword(
                email: authdata['email']!,
                password: authdata['password']!
            );
            await userCredential.user!.updateEmail(value);
            break;
        }
      } on UrMyPMException {
        throw UrMyPMException("pm time");
      } catch (e) {
        throw UrMyUpdateProfileException(e.toString());
      }
    }

    final String baseUrl = ref.read(appConfigProvider.notifier).state.baseUrl;

    var url = Uri.parse('$baseUrl/v2/updateprofile');


    var accesstoken = urmytokenstorage.get('accesstoken');
    final http.Response response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'authtoken': accesstoken!.token,
          'firebasetoken' : accesstoken.firebasetoken,
        },
        body: json.encode({"key": key, "value": value}));

    switch (response.statusCode) {
      case 200:
        var responseBody = json.decode(response.body);
        UrData urdata = UrData.fromJson(responseBody["urdata"]);
        if(key=='email') {
          await resetEmail(value);
          urdata.email = value;
        } else {
          var currentemail = await retrieveData("email");
          urdata.email = currentemail['email'];
        }
        Map<String, String> previousauthdata = await authstorage.readAll();
        String type;
        if(value.contains("gmail.com")) {
          type = "google";
        } else if (value.contains("icloud.com")) {
          type = "apple";
        } else {
          type = "normal";
        }
        AuthData authdata = AuthData(email: value, password: previousauthdata["password"]!, uuid: previousauthdata["uuid"]! ,authtype: type);
        await saveData(authdata);

        return urdata;
      case 406:
        throw UrMyUpdateTooMuchBirthdateException("too-much-birthdate");
      default:
        throw UrMyUpdateProfileException("exception");
    }
  }

  Future<UrMyProfilepiclist> updateProfilePicture(
      String key, String filepath) async {
    final String baseUrl = ref.read(appConfigProvider.notifier).state.baseUrl;

    var url = Uri.parse('$baseUrl/v3/updateprofilepic');
    var accesstoken = urmytokenstorage.get('accesstoken');

    var request = http.MultipartRequest("POST", url);
    request.headers['authtoken'] = accesstoken!.token;
    request.fields["key"] = key;
    var pic = await http.MultipartFile.fromPath("profile", filepath);
    //add multipart to request
    request.files.add(pic);
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);


    UrMyProfilepiclist listprofile = urmytalkProfileFromMap(responseString);

    if (response.statusCode == 400) {
      throw Exception('Not uploadable type');
    }

    if (listprofile.profilepiclist == null) {
      UrMyProfilepiclist urmyprofilepiclist =
      UrMyProfilepiclist(profilepiclist: []);
      return urmyprofilepiclist;
    } else {
      listprofile.profilepiclist!
          .sort((a, b) => a.profilesequence!.compareTo(b.profilesequence!));
      return listprofile;
    }
  }

  Future<void> resetEmail(String newEmail) async {
    var currentemail = await retrieveData("email");
    var currentpassword = await retrieveData("password");


    auth.User? firebaseUser = _auth.currentUser;
    await firebaseUser!.reauthenticateWithCredential(
      EmailAuthProvider.credential(
        email: currentemail['email']!,
        password: currentpassword['password']!,
      ),
    );

    await firebaseUser.updateEmail(newEmail);
  }

  UrMySettings? getSettings() {
    return settingdatastorage.get("settings");
  }

  void updateAgeFilter(int min, int max) {
    var previous = settingdatastorage.get("settings");
    previous!.min = min;
    previous.max = max;
    settingdatastorage.put('settings', previous);
  }

  Future<UrMyProfilepiclist> deleteProfilePicture(String key, String filename) async {
    final String baseUrl = ref.read(appConfigProvider.notifier).state.baseUrl;

    var url = Uri.parse('$baseUrl/v3/deleteprofilepic');
    var accesstoken = urmytokenstorage.get('accesstoken');

    final http.Response response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'authtoken': accesstoken!.token,
        },
        body: json.encode({"key": key, "value": filename}));


    UrMyProfilepiclist listprofile = urmytalkProfileFromMap(response.body);

    if (response.statusCode != 200) {
      throw Exception('Fail to update');
    } else if (listprofile.profilepiclist!.isEmpty) {
      return UrMyProfilepiclist(profilepiclist: []);
    } else {
      listprofile.profilepiclist!
          .sort((a, b) => a.profilesequence!.compareTo(b.profilesequence!));
      return listprofile;
    }
  }


  Future<Map<String, dynamic>> _getDeviceInfo() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    Map<String, dynamic> deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        //var notitoken = await messaging.getToken();
        var notitoken = "yet";
        deviceData = _readAndroidDeviceInfo(await deviceInfoPlugin.androidInfo, notitoken);
      } else if (Platform.isIOS) {
        //var notitoken = await messaging.getAPNSToken();
        var notitoken = "yet";
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo, notitoken);
      }
    } catch(error) {
      deviceData = {
        "Error": "Failed to get platform version."
      };
    }

    return deviceData;
  }

  Map<String, dynamic> _readAndroidDeviceInfo(AndroidDeviceInfo info, String notitoken) {
    var release = info.version.release;
    var sdkInt = info.version.sdkInt;
    var manufacturer = info.manufacturer;
    var model = info.model;

    return {
      "os": "$release:$sdkInt",
      "device": "$manufacturer:$model",
      "notitoken" : notitoken
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo info, String notitoken) {
    var systemName = info.systemName;
    var version = info.systemVersion;
    var machine = info.utsname.machine;

    return {
      "os": "$systemName:$version",
      "device": "$machine",
      "notitoken" : notitoken
    };
  }


  Future<void> deleteUser() async {
    final String baseUrl = ref.read(appConfigProvider.notifier).state.baseUrl;

    var url = Uri.parse('$baseUrl/v2/deleteuser');

    var accesstoken = urmytokenstorage.get('accesstoken');
    Map<String, String> authdata = await authstorage.readAll();

    var useruid;
    try {
      switch (authdata["type"]) {
        case "google":
          final GoogleSignInAccount? account = await googleSignIn.signIn();
          final GoogleSignInAuthentication googleAuth = await account!.authentication;

          final auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          final auth.UserCredential authResult = await _auth.signInWithCredential(credential);
          final auth.User? user = authResult.user;
          useruid = user!.uid;
          break;
        case "apple":
          final appleCredential = await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
          );
          final oauthCredential = OAuthProvider("apple.com").credential(
            idToken: appleCredential.identityToken,
            accessToken: appleCredential.authorizationCode,
          );

          final auth.UserCredential authResult = await _auth.signInWithCredential(oauthCredential);
          useruid = authResult.user!.uid;
          break;
        case "normal":
          useruid = await firebaseSignIn(authdata['email']!, authdata['password']!);
        break;
      }
    } on UrMyPMException {
      throw UrMyPMException("pm time");
    }catch (e) {
      //print(e.toString());
      throw UrMyAutoLoginException("autologinerror");
    }


    if (useruid == ""){
      throw Exception("Invalid Sign In");
    } else {
      final http.Response response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'authtoken': accesstoken!.token,
            'firebasetoken' : accesstoken.firebasetoken,
          },
          body: json.encode(
            {
              'loginId': authdata['email'],
              'userUid': useruid,
            },
          )
      );

      if (response.statusCode == 200) {
        //print('${response.statusCode}: ${response.reasonPhrase}');

        authstorage.deleteAll();
        urmytokenstorage.delete('accesstoken');
        var settings = settingdatastorage.get("settings");
        settings!.autologin = false;
        settings!.introduction = false;
        settingdatastorage.put("settings", settings);
      } else {

        throw UrMyUserWithDrawalException;
      }
    }
  }

  Future<bool> checkPM() async {
    final String baseUrl = ref.read(appConfigProvider.notifier).state.baseUrl;

    var signinurl = Uri.parse('$baseUrl/v1/checkpm');
    final http.Response response = await http.post(
      signinurl,
      headers: {

      },
      body: json.encode(
        {

        },
      ),
    );

    if(response.statusCode == 510) {
      return true;
    }

    return false;
  }

  Future<Inquirylist> listInquiry() async {
    final String baseUrl = ref.read(appConfigProvider.notifier).state.baseUrl;
    var url = Uri.parse('$baseUrl/v3/getinquiry');
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
      var result = inquirylistFromJson(response.body);

      return result;
    }
  }

  Future<InquiryContentlist> listContentInquiry(String caseid) async {
    final String baseUrl = ref.read(appConfigProvider.notifier).state.baseUrl;

    var url = Uri.parse('$baseUrl/v3/getinquirycontent');
    var accesstoken = urmytokenstorage.get('accesstoken');

    final http.Response response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'authtoken': accesstoken!.token,
        'firebasetoken' : accesstoken.firebasetoken,
      },
      body: json.encode(
        {
            "caseid" : int.parse(caseid),
        },
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Fail to login');
    } else {

      var result = inquiryContentlistFromJson(response.body);
      return result;
    }
  }

  Future<void> sendhelp(String type, String title, String content) async {
    final String baseUrl = ref.read(appConfigProvider.notifier).state.baseUrl;

    var accesstoken = urmytokenstorage.get('accesstoken');

    var signinurl = Uri.parse('$baseUrl/v3/insertinquiry');
    final http.Response response = await http.post(
      signinurl,
      headers: {
        'authtoken': accesstoken!.token,
        'firebasetoken' : accesstoken.firebasetoken,
      },
      body: json.encode(
        {
          'inquirytype': type,
          'title' : title,
          'contents' : content,
        },
      ),
    );

    if (response.statusCode == 200) {
      return;
    }
  }

  Future<void> sendreply(String caseid, String content) async {
    final String baseUrl = ref.read(appConfigProvider.notifier).state.baseUrl;

    var accesstoken = urmytokenstorage.get('accesstoken');

    var signinurl = Uri.parse('$baseUrl/v3/insertinquirycontent');
    final http.Response response = await http.post(
      signinurl,
      headers: {
        'authtoken': accesstoken!.token,
        'firebasetoken' : accesstoken.firebasetoken,
      },
      body: json.encode(
        {
          'caseid': int.parse(caseid),
          'contents' : content,
        },
      ),
    );

    if (response.statusCode == 200) {
      return;
    }
  }

}


/*
    if (rawCookie != null) {
      //int index = rawCookie.lastIndexOf("=");
      //await prefs.setString("accesstoken", rawCookie.substring(rawCookie.indexOf("accesstoken=")+12,rawCookie.indexOf("refreshtoken=")-1));
      //await prefs.setString("refreshtoken", rawCookie.substring(rawCookie.indexOf("refreshtoken=")+13,rawCookie.length));
     var tokendata = UrTokenData();
      tokendata.accesstoken = rawCookie.substring(
          rawCookie.indexOf("accesstoken=") + 12,
          rawCookie.indexOf("refreshtoken=") - 1);
      tokendata.refreshtoken = rawCookie.substring(
          rawCookie.indexOf("refreshtoken=") + 13,
          rawCookie.length);
      //tokendata.firebasetoken = rawCookie.substring(rawCookie.indexOf("firebasetoken=") + 14, rawCookie.length);
      tokendata.firebasetoken =
          personaltokenstorage.get('tokendata')!.firebasetoken;
      personaltokenstorage.put('tokendata', tokendata);

      if (keyconfigexist == false) {
        var keyconfig = KeyConfig();
        keyconfig.ServerKey = rawCookie.substring(
            rawCookie.indexOf("firebasekey=") + 12,
            rawCookie.indexOf("accesstoken=") - 1);
        print(keyconfig.ServerKey);
        serverdatastorage.put('firebasekey', keyconfig);
      }
      }
      */
/*
  Future<UrData> signin(String loginid, String password) async {
    final String baseUrl = read(appConfigProvider).state.baseUrl;

    Map<String, dynamic> deviceInfo = await _getDeviceInfo();
    var useruid = await firebaseSignIn(loginid, password);

    if (useruid == ""){
      throw UrMyWrongPasswordException("wrongpassword");
    }


    var signinurl = Uri.parse('$baseUrl/v1/signin');
    final http.Response response = await http.post(
      signinurl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {
          'loginId': loginid,
          'userUid': useruid,
          'notificationtoken' : deviceInfo['notitoken'],
          'deviceos' : deviceInfo['os'].toString()+":"+deviceInfo['device'].toString()
        },
      ),
    );
    print("signin bytes: "+ response.contentLength.toString());
    if (response.statusCode != 200) {
      throw Exception("Need to update your profile");
    }

    var firebasetoken = await auth.FirebaseAuth.instance.currentUser!.getIdToken();

    UrMyToken token = UrMyToken(token: response.headers["authtoken"]!.toString().trim(), firebasetoken: firebasetoken!);
    urmytokenstorage.put('accesstoken', token);

    AuthData authdata = AuthData(email: loginid, password: password, uuid:"");
    var responseBody = json.decode(response.body);

    UrData urdata = UrData.fromJson(responseBody["urdata"]);

    var settings = settingdatastorage.get("settings");
    if(settings == null) {
      settings = UrMySettings(
        min: DateTime.now().year-int.parse(urdata.birthdate!.substring(0, 4))-12,
        max: DateTime.now().year-int.parse(urdata.birthdate!.substring(0, 4))+12,
        delreq: false,
        autologin: false,
        needprofileupdate: 10,
      );
      await settingdatastorage.put("settings", settings);
    } else {
      settings.autologin = false;
      await saveData(authdata);
      await settingdatastorage.put('settings', settings);
    }


    return urdata;
  }
*/