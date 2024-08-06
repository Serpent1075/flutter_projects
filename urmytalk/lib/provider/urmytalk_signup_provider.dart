import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/provider/providers.dart';
import 'package:urmytalk/models/models.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import '../urmyexception/urmyauth_exception.dart';


class SignUpState {
  final bool registering;
  final bool registered;
  final bool registerfailed;
  final bool verifiedemail;
  final String error;
  final List<Country>? listcountry;

  final bool isoverage;
  final bool privacy;
  final bool service;
  final bool illegal;



  final String name;
  final String birthdate;
  final String description;
  final String country;
  final String city;
  final bool gender;
  final String mbti;
  final String? imageFilePath;


  SignUpState({
    this.registering = false,
    this.registered = false,
    this.verifiedemail = false,
    this.registerfailed = false,
    this.error = '',
    this.listcountry,

    this.isoverage = false,
    this.privacy = false,
    this.service = false,
    this.illegal = false,


    this.name = '',
    this.description = '',
    this.birthdate = '',
    this.country = '',
    this.city = '',
    this.mbti = '',
    this.gender = false,
    this.imageFilePath = '',

  });

  SignUpState copyWith({
    required bool registering,
    required bool registered,
    required bool registerfailed,
    required bool verifiedemail,
    String? error,
    List<Country>? listcountry,

    bool? isoverage,
    bool? privacy,
    bool? service,
    bool? illegal,



    String? name,
    String? description,
    String? birthdate,
    String? country,
    String? city,
    bool? gender,
    String? mbti,
    String? imageFilePath,

  }) {
    return SignUpState(
      registering: registering,
      registered: registered,
      registerfailed: registerfailed,
      verifiedemail: verifiedemail,
      error: error ?? this.error,
      listcountry: listcountry ?? this.listcountry,

      isoverage: isoverage ?? this.isoverage,
      privacy: privacy ?? this.privacy,
      service: service ?? this.service,
      illegal: illegal ?? this.illegal,



      name: name ?? this.name,
      description: description ?? this.description,
      birthdate: birthdate ?? this.birthdate,
      country: country ?? this.country,
      city: city ?? this.city,
      gender: gender ?? this.gender,
      mbti : mbti ?? this.mbti,
      imageFilePath : imageFilePath ?? this.imageFilePath,
    );
  }
}

final signupProvider = StateNotifierProvider<SignUp, SignUpState>((ref) {
  return SignUp(ref: ref);
});

class SignUp extends StateNotifier<SignUpState> {
  final Ref ref;
  static SignUpState initialAuthState = SignUpState();
  SignUp({required this.ref}) : super(initialAuthState);

  Future<void> signupAgreement(bool isoverage, bool privacy, bool service, bool illegal) async {
    state = state.copyWith(
        registering: state.registering,
        registerfailed: state.registerfailed,
        registered: state.registered,
        verifiedemail: state.verifiedemail,

        isoverage: isoverage,
        privacy: privacy,
        service: service,
        illegal: illegal,

    );
  }


  Future<void> signupProfile(String name, String description, String imageFilePath) async {
    try {
      state = state.copyWith(
        registering: state.registering,
        registered: state.registered,
        registerfailed: state.registerfailed,
        verifiedemail: true,
        name: name,
        description: description,
        imageFilePath : imageFilePath,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        registered: state.registered,
        registerfailed: state.registerfailed,
        registering: state.registering,
        verifiedemail: state.verifiedemail,
      );
    }
  }

  void setProfilePicPath(String picpath) {
    try {
      state = state.copyWith(
        registering: state.registering,
        registered: state.registered,
        registerfailed: state.registerfailed,
        verifiedemail: true,
        imageFilePath : picpath,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        registered: state.registered,
        registerfailed: state.registerfailed,
        registering: state.registering,
        verifiedemail: state.verifiedemail,
      );
    }
  }

  Future<void> SignUpBirthdate(String birthdate) async {
    try {
      state = state.copyWith(
          registering: false,
          registered: state.registered,
          registerfailed: state.registerfailed,
          verifiedemail: state.verifiedemail,
          birthdate: birthdate,
      );

    } catch (e) {
      state = state.copyWith(
        registering: false,
        registered: state.registered,
        registerfailed: state.registerfailed,
        verifiedemail: state.verifiedemail,
        error: e.toString(),
      );
    }
  }

  Future<void> readCountryJson() async {
    final String response = await rootBundle.loadString('assets/country/country.json');
    final data = countryFromMap(response);
    state = state.copyWith(
      registering: false,
      registered: state.registered,
      registerfailed: state.registerfailed,
      verifiedemail: state.verifiedemail,
      listcountry: data,
    );
  }

  Future<void> SignUpCountry(String country, String city) async {
    try {
      state = state.copyWith(
        registering: false,
        registered: state.registered,
        registerfailed: state.registerfailed,
        verifiedemail: state.verifiedemail,
        country: country,
        city: city,
      );
    } catch (e) {
      state = state.copyWith(
        registering: false,
        registered: state.registered,
        registerfailed: state.registerfailed,
        verifiedemail: state.verifiedemail,
        error: e.toString(),
      );
    }

  }


  Future<void> SignUpMG(bool gender, String mbti) async {
    state = state.copyWith(
      registering: true,
      registered: state.registered,
      registerfailed: state.registerfailed,
      verifiedemail: state.verifiedemail,
      mbti: mbti,
      gender: gender,
    );

    try {
      UrData urdata = UrData(
        name: state.name,
        genderState: gender,
        birthdate: state.birthdate,
        mbti: mbti,
        description: state.description,
        country: state.country,
        city: state.city,
        isoverage: state.isoverage,
        privacy: state.privacy,
        service: state.service,
        illegal: state.illegal,
      );
      var result = await ref.read(signupRepositoryProvider).SignUp(urdata);
      switch (result) {
        case 201:
          if (state.imageFilePath != "") {
            await ref.read(signupRepositoryProvider).insertPropic(state.imageFilePath);
          }
          state = state.copyWith(
            registering: false,
            registerfailed: false,
            registered: true,
            verifiedemail: state.verifiedemail,
            name: "",
            description: "",
            birthdate: "",
            country: "",
            city: "",
            gender: false,
            mbti: "",
            imageFilePath: "",
          );
          return;
        case 401:
          await ref.read(signinRepositoryProvider).autologin();
          result = await ref.read(signupRepositoryProvider).SignUp(urdata);
          if (result == 201 && state.imageFilePath != "") {
            await ref.read(signupRepositoryProvider).insertPropic(state.imageFilePath);
          }
          state = state.copyWith(
            registering: false,
            registered: true,
            registerfailed: state.registerfailed,
            verifiedemail: state.verifiedemail,
            name: "",
            description: "",
            birthdate: "",
            country: "",
            city: "",
            gender: false,
            mbti: "",
            imageFilePath: "",
          );
          return;
        default:
          state = state.copyWith(
            registering: false,
            registerfailed: true,
            registered: false,
            verifiedemail: state.verifiedemail,
          );
          return;
      }

    } catch (e) {
      state = state.copyWith(
        registering: false,
        registered: state.registered,
        registerfailed: true,
        verifiedemail: state.verifiedemail,
        error: e.toString(),
      );
    }
  }

}

final signupStateProvider = Provider<SignUpState>((ref) {
  final SignUpState signup = ref.watch(signupProvider);

  return signup;
});

