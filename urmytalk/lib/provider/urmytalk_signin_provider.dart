import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/models/models.dart';
import 'package:urmytalk/provider/urmytalk_signin_repository_provider.dart';
import 'package:urmytalk/urmyexception/exceptions.dart';


class SignInState {
  final bool loggingIn;
  final bool autoLogin;
  final bool authenticated;
  final bool updating;
  final bool intro;
  final int needprofileupdate;
  final String error;
  final String profileupdateerr;
  final String pmerr;


  final String uuid;
  final String email;
  final String password;
  final String mbti;
  final String phone;
  final String phonecode;
  final String name;
  final String birthdate;
  final bool gender;
  final String description;
  final String country;
  final String statevalue;
  final String city;
  final String contentUrl;
  final Saju? saju;
  final List<UrMyProfilePicData>? imageFilePath;
  late String? profileimage;
  final UrMySettings? settings;
  Inquirylist? inquirylist;
  Inquiry? currentInquiry;
  InquiryContentlist? inquirycontentlist;

  SignInState({
    this.loggingIn = false,
    this.autoLogin = false,
    this.authenticated = false,
    this.intro = false,
    this.updating = false,
    this.needprofileupdate = 0,
    this.error = '',
    this.profileupdateerr = '',
    this.pmerr = '',

    this.uuid = '',
    this.email = '',
    this.password = '',
    this.mbti = '',
    this.phone = '',
    this.description = '',
    this.country = '',
    this.statevalue = '',
    this.city = '',
    this.phonecode = '',
    this.name = '',
    this.birthdate = '',
    this.gender = false,
    this.contentUrl = '',
    this.saju,
    this.imageFilePath,
    this.profileimage,
    this.settings,
    this.inquirylist,
    this.currentInquiry,
    this.inquirycontentlist,
  });

  SignInState copyWith({
    required bool loggingIn,
    required bool autoLogin,
    required bool authenticated,
    required int needprofileupdate,
    bool? intro,
    bool? updating,
    String? error,
    String? profileupdateerr,
    String? pmerr,

    String? uuid,
    String? email,
    String? password,
    String? mbti,
    String? phone,
    String? description,
    String? country,
    String? statevalue,
    String? city,
    String? phonecode,
    String? name,
    String? birthdate,
    bool? gender,
    String? contentUrl,
    Saju? saju,
    List<UrMyProfilePicData>? imageFilePath,
    String? profileimage,
    UrMySettings? settings,
    Inquirylist? inquirylist,
    Inquiry? currentInquiry,
    InquiryContentlist? inquirycontentlist,
  }) {
    return SignInState(
      loggingIn: loggingIn,
      autoLogin: autoLogin,
      authenticated: authenticated,
      needprofileupdate : needprofileupdate,
      intro: intro ?? this.intro,
      updating: updating ?? this.updating,
      error: error ?? this.error,
      profileupdateerr: profileupdateerr ?? this.profileupdateerr,
      pmerr: pmerr ?? this.pmerr,

      uuid: uuid ?? this.uuid,
      email: email ?? this.email,
      password: password ?? this.password,
      mbti: mbti ?? this.mbti,
      phone: phone ?? this.phone,
      description: description ?? this.description,
      country: country ?? this.country,
      statevalue: statevalue ?? this.statevalue,
      city: city ?? this.city,
      phonecode: phonecode ?? this.phonecode,
      name: name ?? this.name,
      birthdate: birthdate ?? this.birthdate,
      gender: gender ?? this.gender,
        contentUrl: contentUrl ?? this.contentUrl,
      saju: saju ?? this.saju,
      imageFilePath: imageFilePath ?? this.imageFilePath,
      profileimage: profileimage ?? this.profileimage,
      settings: settings ?? this.settings,
      inquirylist: inquirylist ?? this.inquirylist,
      currentInquiry: currentInquiry ?? this.currentInquiry,
      inquirycontentlist: inquirycontentlist ?? this.inquirycontentlist
    );
  }
}

final signinProvider = StateNotifierProvider<SignIn, SignInState>((ref) {
  return SignIn(ref: ref);
});

final userautoLoginProvider = FutureProvider.autoDispose<bool>((ref) async{
  return await ref.read(signinProvider.notifier).autologin();
});

final userneedprofileupdateProvider = FutureProvider.autoDispose<int>((ref) async{
  return await ref.read(signinProvider).needprofileupdate;
});

class SignIn extends StateNotifier<SignInState> {
  final Ref ref;
  static SignInState initialAuthState = SignInState();
  SignIn({required this.ref}) : super(initialAuthState);

  String getUserId() {
    return state.uuid;
  }


  Future<void> checkAutologin() async {
    var autologin = await ref.read(signinRepositoryProvider).checkAutologin();
    try{
      bool intro = ref.read(signinRepositoryProvider).checkIntro();
      state = state.copyWith(
        loggingIn: state.loggingIn,
        autoLogin: autologin,
        intro: intro,
        needprofileupdate: state.needprofileupdate,
        authenticated: state.authenticated,
      );
    } catch(e) {
      state = state.copyWith(
        loggingIn: state.loggingIn,
        autoLogin: autologin,
        intro: false,
        needprofileupdate: state.needprofileupdate,
        authenticated: state.authenticated,
      );
    }
  }

  void firstInstalledState() {
    state = state.copyWith(
      loggingIn: false,
      autoLogin: false,
      intro: state.intro,
      needprofileupdate: 0,
      authenticated: false,
    );
  }

  void doneIntro() async{
    await ref.read(signinRepositoryProvider).doneIntro();
    state = state.copyWith(
      loggingIn: state.loggingIn,
      needprofileupdate: state.needprofileupdate,
      authenticated: state.authenticated,
      intro: true,
      autoLogin: state.autoLogin,
    );
  }

  Future<bool> autologin() async {
    try {
      if(state.autoLogin) {
        int needprofileupdate = await ref.read(signinRepositoryProvider).autologin();
        if(needprofileupdate == 10) {
          await geturmyuserdata();
          state = state.copyWith(
              loggingIn: false,
              authenticated: true,
              autoLogin: true,
              needprofileupdate: needprofileupdate,
              error: "",
              pmerr: ""
          );
        } else {
          state = state.copyWith(
              loggingIn: false,
              authenticated: true,
              autoLogin: state.autoLogin,
              needprofileupdate: needprofileupdate,
              error: "",
              pmerr: ""
          );
        }
        return true;
      } else {
        return false;
      }

    } on UrMyPMException {
      state = state.copyWith(
        loggingIn: false,
        authenticated: true,
        autoLogin: false,
        needprofileupdate: state.needprofileupdate,
        pmerr: "pm-time"
      );
      return false;
    }on UrMyAutoLoginException {
      state = state.copyWith(
        loggingIn: false,
        authenticated: false,
        autoLogin: false,
        needprofileupdate: state.needprofileupdate,
      );
      return false;
    } catch(e){
      state = state.copyWith(
        loggingIn: false,
        authenticated: false,
        autoLogin: false,
        needprofileupdate: state.needprofileupdate,
      );
      return false;
    }
  }

  Future<void> googlesignin() async {
    state = state.copyWith(
      loggingIn: true,
      authenticated: state.authenticated,
      autoLogin: state.autoLogin,
      needprofileupdate: state.needprofileupdate,
    );
    try {
      int needprofileupdate = await ref.read(signinRepositoryProvider).googleSingIn();
      if(needprofileupdate == 10) {
        await geturmyuserdata();
        state = state.copyWith(
          loggingIn: false,
          authenticated: true,
          autoLogin: true,
          needprofileupdate: needprofileupdate,
          error: "",
          pmerr: ""
        );
      } else {
        state = state.copyWith(
          loggingIn: false,
          authenticated: true,
          autoLogin: state.autoLogin,
          needprofileupdate: needprofileupdate,
          error: "",
          pmerr: ""
        );
      }
    } on UrMyPMException {
      state = state.copyWith(
          loggingIn: false,
          authenticated: false,
          autoLogin: false,
          needprofileupdate: state.needprofileupdate,
          pmerr: "pm-time"
      );
    } catch (e) {
      state = state.copyWith(
        loggingIn: false,
        authenticated: false,
        autoLogin: false,
        needprofileupdate: state.needprofileupdate,
      );
    }
  }

  Future<void> applesignin() async {
    state = state.copyWith(
      loggingIn: true,
      authenticated: state.authenticated,
      autoLogin: state.autoLogin,
      needprofileupdate: state.needprofileupdate,
    );
    try {
      int needprofileupdate = await ref.read(signinRepositoryProvider).appleSingIn();
      if(needprofileupdate == 10) {
        await geturmyuserdata();
        state = state.copyWith(
          loggingIn: false,
          authenticated: true,
          autoLogin: true,
          needprofileupdate: needprofileupdate,
          error: "",
          pmerr: ""
        );
      } else {
        state = state.copyWith(
          loggingIn: false,
          authenticated: true,
          autoLogin: state.autoLogin,
          needprofileupdate: needprofileupdate,
          error: "",
          pmerr: ""
        );
      }
    } on UrMyPMException {
      state = state.copyWith(
          loggingIn: false,
          authenticated: false,
          autoLogin: false,
          needprofileupdate: state.needprofileupdate,
          pmerr: "pm-time"
      );
    } catch (e) {
      state = state.copyWith(
        loggingIn: false,
        authenticated: false,
        autoLogin: false,
        needprofileupdate: state.needprofileupdate,
      );
    }
  }

  Future<void> normalsignin(String email, String password) async {
    state = state.copyWith(
      loggingIn: true,
      authenticated: state.authenticated,
      autoLogin: state.autoLogin,
      needprofileupdate: state.needprofileupdate,
    );

    try {
      int needupdateprofile = await ref.read(signinRepositoryProvider).normalSingIn(email, password);
      if(needupdateprofile == 10) {
        await geturmyuserdata();
        state = state.copyWith(
          loggingIn: false,
          authenticated: true,
          autoLogin: true,
          needprofileupdate: needupdateprofile,
          error: "",
          pmerr: ""
        );
      } else {
        state = state.copyWith(
          loggingIn: false,
          authenticated: true,
          autoLogin: state.autoLogin,
          needprofileupdate: needupdateprofile,
        );
      }

    } on UrMyWrongPasswordException {
      state = state.copyWith(
        loggingIn: false,
        authenticated: false,
        autoLogin: false,
        needprofileupdate: state.needprofileupdate,
        error: "wrongpassword",
      );
    } on UrMyTooManyException{
      state = state.copyWith(
        loggingIn: false,
        authenticated: false,
        autoLogin: false,
        needprofileupdate: state.needprofileupdate,
        error: "toomanyattempt",
      );
    } on UrMyPMException {
      state = state.copyWith(
          loggingIn: false,
          authenticated: false,
          autoLogin: false,
          needprofileupdate: state.needprofileupdate,
          pmerr: "pm-time"
      );
    } catch(e){
      state = state.copyWith(
        loggingIn: false,
        authenticated: false,
        autoLogin: false,
        needprofileupdate: state.needprofileupdate,
        error: e.toString(),
      );
    }


  }

  void setneedprofileupdate(int value) {
    state = state.copyWith(
        loggingIn: state.loggingIn,
        authenticated: state.authenticated,
        autoLogin: state.autoLogin,
        needprofileupdate: value
    );
  }


  void setErrorEmpty() {
    state = state.copyWith(
        loggingIn: state.loggingIn,
        authenticated: state.authenticated,
        autoLogin: state.autoLogin,
        needprofileupdate: state.needprofileupdate,
        error: "",
        profileupdateerr: "",
        pmerr: ""
    );
  }



  Future<void> geturmyuserdata() async {

    try {
      UrData urdata = await ref.read(signinRepositoryProvider).geturmyuserdata();
      state = state.copyWith(
        loggingIn: false,
        authenticated: true,
        autoLogin: true,
        needprofileupdate: state.needprofileupdate,

        uuid: urdata.uuid,
        email: urdata.email,
        mbti: urdata.mbti,
        phone: urdata.phoneNo,
        name: urdata.name,
        birthdate: urdata.birthdate,
        description: urdata.description,
        country: urdata.currentcountry,
        statevalue: urdata.currentcity,
        city: urdata.currentcity,
        gender: urdata.genderState,
        saju: urdata.saju,
        imageFilePath: urdata.imageFile,
        settings: urdata.settings,
        error: "",
      );

    } catch(e){
      state = state.copyWith(
          loggingIn: false,
          authenticated: false,
          autoLogin: false,
          needprofileupdate: state.needprofileupdate,
          error: e.toString(),
      );
    }

  }

  Future<void> getCFurl() async {
    String cfurl = await ref.read(signinRepositoryProvider).getcfurl();
    if(cfurl == 'error') {
      state = state.copyWith(
        loggingIn: state.loggingIn,
        autoLogin: state.loggingIn,
        authenticated: state.authenticated,
        needprofileupdate: state.needprofileupdate,
        error: cfurl
      );
    } else {
      state = state.copyWith(
        loggingIn: state.loggingIn,
        autoLogin: state.loggingIn,
        authenticated: state.authenticated,
        needprofileupdate: state.needprofileupdate,
        contentUrl: cfurl,
      );
    }
  }

  void getSettings() {
    UrMySettings? settings = ref.read(signinRepositoryProvider).getSettings();
    state = state.copyWith(
        loggingIn: state.loggingIn,
        autoLogin: state.loggingIn,
        authenticated: state.authenticated,
        needprofileupdate: state.needprofileupdate,
        settings: settings
    );
  }



  Future<void> updateProfile(String key, String value) async{
    state = state.copyWith(
        loggingIn: state.loggingIn,
        autoLogin: state.loggingIn,
        authenticated: state.authenticated,
        needprofileupdate: state.needprofileupdate,
        updating: true,
    );
    try {
      UrData urdata = await ref.read(signinRepositoryProvider).updateProfile(key, value);
      state = state.copyWith(
        loggingIn: state.loggingIn,
        autoLogin: state.loggingIn,
        authenticated: state.authenticated,
        needprofileupdate: state.needprofileupdate,
        updating: false,
        email: urdata.email,
        mbti: urdata.mbti,
        phone: urdata.phoneNo,
        name: urdata.name,
        description: urdata.description,
        birthdate: urdata.birthdate,
        gender: urdata.genderState,
        imageFilePath: urdata.imageFile,
        country: urdata.currentcountry,
        statevalue: urdata.currentstate,
        city: urdata.currentcity,
      );
    } on UrMyUpdateTooMuchBirthdateException {
      state = state.copyWith(
          loggingIn: state.loggingIn,
          autoLogin: state.loggingIn,
          authenticated: state.authenticated,
          needprofileupdate: state.needprofileupdate,
          updating: false,
          profileupdateerr: "too-much-birthdate",
      );
    } on UrMyUpdateProfileException {
      await ref.read(signinRepositoryProvider).refreshFirebaseToken();
      state = state.copyWith(
        loggingIn: state.loggingIn,
        autoLogin: state.loggingIn,
        authenticated: state.authenticated,
        needprofileupdate: state.needprofileupdate,
        updating: false,
        error: "updateprofile",
      );
    } catch (e) {
      await ref.read(signinRepositoryProvider).refreshFirebaseToken();
      state = state.copyWith(
          loggingIn: state.loggingIn,
          autoLogin: state.loggingIn,
          authenticated: state.authenticated,
          needprofileupdate: state.needprofileupdate,
          updating: false,
          error: e.toString(),
      );
    }

  }



 Future<void> updateProfileImage(String profileimage) async {
    try {
      var profilepiclist = await ref.read(signinRepositoryProvider).updateProfilePicture("image", profileimage);
      state = state.copyWith(
        loggingIn: state.loggingIn,
        autoLogin: state.loggingIn,
        authenticated: state.authenticated,
        needprofileupdate: state.needprofileupdate,
        profileimage: profileimage,
        imageFilePath: profilepiclist.profilepiclist,
      );
    } catch (e) {
      await ref.read(signinRepositoryProvider).refreshFirebaseToken();
    }
 }

 void updateAgeFilter(int min, int max) {
    var birthyear = int.parse(state.birthdate.substring(0,4));
    if ((min >= DateTime.now().year-birthyear-12) && (max <= DateTime.now().year-birthyear+12)) {
      ref.read(signinRepositoryProvider).updateAgeFilter(min, max);
      getSettings();
    }

 }

 Future<void> deleteProfileImage(String profileimage) async {
    try {
      UrMyProfilepiclist profilepiclist = await ref.read(signinRepositoryProvider).deleteProfilePicture("image", profileimage);
      state = state.copyWith(
        loggingIn: state.loggingIn,
        autoLogin: state.loggingIn,
        authenticated: state.authenticated,
        needprofileupdate: state.needprofileupdate,
        profileimage: profileimage,
        imageFilePath: profilepiclist.profilepiclist,
      );
    } catch (e) {
      await ref.read(signinRepositoryProvider).refreshFirebaseToken();
    }

 }

  Future<void> signout() async {
    state = state.copyWith(
      loggingIn: state.loggingIn,
      authenticated: false,
      needprofileupdate: state.needprofileupdate,
      autoLogin: false,
    );
    try {
      await ref.read(signinRepositoryProvider).signout();
      state = state.copyWith(
        loggingIn: false,
        authenticated: false,
        needprofileupdate: 0,
        autoLogin: false,
        intro: true,

      );
    } catch(e) {
      await ref.read(signinRepositoryProvider).refreshFirebaseToken();
      state = state.copyWith(
        loggingIn: false,
        authenticated: true,
        needprofileupdate: state.needprofileupdate,
        autoLogin: false,
        error: e.toString(),
      );
    }
  }

  Future<void> withdrawal() async {
    try {
      await ref.read(signinRepositoryProvider).deleteUser();
      state = state.copyWith(
        loggingIn: false,
        authenticated: false,
        autoLogin: false,
        needprofileupdate: 0,
        error: "",
      );
    } catch(e) {
      await ref.read(signinRepositoryProvider).refreshFirebaseToken();

      state = state.copyWith(
        loggingIn: false,
        authenticated: true,
        needprofileupdate: state.needprofileupdate,
        autoLogin: false,
        error: e.toString(),
      );
    }
  }

  void checkPM() async {
    bool checkpm = await ref.read(signinRepositoryProvider).checkPM();
    if (checkpm) {
      state = state.copyWith(
          loggingIn: false,
          authenticated: false,
          needprofileupdate: state.needprofileupdate,
          autoLogin: true,
          pmerr: "pm-time"
      );
    } else {
      state = state.copyWith(
          loggingIn: false,
          authenticated: false,
          needprofileupdate: state.needprofileupdate,
          autoLogin: true,
          pmerr: ""
      );
    }
  }

  Future<void> sendInquiry(String type, String title, String contents) async {
    await ref.read(signinRepositoryProvider).sendhelp(type, title, contents);
  }

  Future<void> sendInquiryContent(String caseid, String contents) async {
    await ref.read(signinRepositoryProvider).sendreply(caseid, contents);
  }

  Future<void> getInquirylist() async {
    try {
      var inquirylist = await ref.read(signinRepositoryProvider).listInquiry();
      state = state.copyWith(
        loggingIn: state.loggingIn,
        authenticated: state.authenticated,
        needprofileupdate: state.needprofileupdate,
        autoLogin: state.autoLogin,
        inquirylist: inquirylist
      );
    } catch (e) {

    }
  }
  void setCurrentInquiry(Inquiry? currentInquiry) {
    state = state.copyWith(
      loggingIn: state.loggingIn,
      authenticated: state.authenticated,
      needprofileupdate: state.needprofileupdate,
      autoLogin: state.autoLogin,
      currentInquiry: currentInquiry,
    );
  }

  Future<void> getInquiryContentlist(String caseid) async {
    try {
      var inquirycontentlist = await ref.read(signinRepositoryProvider).listContentInquiry(caseid);
      state = state.copyWith(
          loggingIn: state.loggingIn,
          authenticated: state.authenticated,
          needprofileupdate: state.needprofileupdate,
          autoLogin: state.autoLogin,
          inquirycontentlist: inquirycontentlist
      );
    } catch (e) {

    }
  }
}

final signinStateProvider = Provider<SignInState>((ref) {
  final SignInState signin = ref.watch(signinProvider);
  return signin;
});

