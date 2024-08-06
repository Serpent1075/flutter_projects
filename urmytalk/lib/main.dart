import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'firebase_options.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:urmytalk/widgets/wigets.dart';
import 'package:urmytalk/models/models.dart';





void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Hive.initFlutter();
  await Firebase.initializeApp(
    name: "urmytalk-prod",
    options: DefaultFirebaseOptions.currentPlatform,
  );


  await EasyLocalization.ensureInitialized();
  Hive.registerAdapter(UrMyTokenAdapter());
  Hive.registerAdapter(UrMySettingsAdapter());
  await Hive.openBox<AuthData>('urmy');
  await Hive.openBox<UrMyToken>('accesstoken');
  await Hive.openBox<UrMySettings>('settings');



  runApp( EasyLocalization(
      supportedLocales: const [Locale('en', 'US'),Locale('ko','KR')],
      path: 'assets/translations', // <-- change the path of the translation files
      fallbackLocale: const Locale('en', 'US'),
      child : const ProviderScope(child: UrMy())
  ));
}

class UrMy extends StatelessWidget {
  const UrMy({Key? key}) : super(key: key);

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const UrMyTalkCheckAutologinPage(),
      theme: ThemeData(
        primaryColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        //textTheme: GoogleFonts.montserratTextTheme(),
      ),
      routes: <String, WidgetBuilder>{
        UrMyTalkSignInPage.routeName: (context) => const UrMyTalkSignInPage(),
        UrMyTalkForgotPasswordPage.routeName: (context) => const UrMyTalkForgotPasswordPage(),
        UrMyTalkCheckAutologinPage.routeName: (context) => const UrMyTalkCheckAutologinPage(),
        UrMyTalkIntroductionPage.routeName: (context) => const UrMyTalkIntroductionPage(),
        UrMyTalkErrorPage.routeName: (context) => const UrMyTalkErrorPage(),
        UrMyTalkSignUpAgreementPage.routeName: (context) => const UrMyTalkSignUpAgreementPage(),
        UrMyTalkSignUpProfilePage.routeName: (context) => const UrMyTalkSignUpProfilePage(),
        UrMyTalkSignUpBirthDatePage.routeName: (context) => const UrMyTalkSignUpBirthDatePage(),
        UrMyTalkSignUpCountryPage.routeName: (context) => const UrMyTalkSignUpCountryPage(),
        UrMyTalkSignUpMGPage.routeName : (context) => const UrMyTalkSignUpMGPage(),
        UrMyTalkMainPage.routeName: (context) => const UrMyTalkMainPage(),
        UrMyTalkMainProfilePage.routeName: (context) => const UrMyTalkMainProfilePage(),
        UrMyTalkCandidateProfilePage.routeName:(context) => const UrMyTalkCandidateProfilePage(),
        UrMyChatBoardPage.routeName:(context) => const UrMyChatBoardPage(),
        UrMyTalkInformationMainPage.routeName: (context) => UrMyTalkInformationMainPage(),
        UrMyTalkInformationServicePolicyPage.routeName: (context) => UrMyTalkInformationServicePolicyPage(),
        UrMyTalkInformationDataPolicyPage.routeName: (context) => UrMyTalkInformationDataPolicyPage(),
        UrMyTalkInformationOpenSourcePage.routeName: (context) => UrMyTalkInformationOpenSourcePage(),
        UrMyTalkInformationIllegalPolicyPage.routeName: (context) => UrMyTalkInformationIllegalPolicyPage(),
        UrMyTalkInformationHomePage.routeName: (context) => UrMyTalkInformationHomePage(),
        UrMyTalkSettingMainPage.routeName: (context) => const UrMyTalkSettingMainPage(),
        UrMyTalkSettingNotificationPage.routeName: (context) => const UrMyTalkSettingNotificationPage(),
        UrMyTalkSettingAccountDataPage.routeName: (context) => UrMyTalkSettingAccountDataPage(),
        UrMyTalkSettingPasswordPage.routeName: (context) => const UrMyTalkSettingPasswordPage(),
        UrMyTalkSettingAgeFilterPage.routeName: (context) => const UrMyTalkSettingAgeFilterPage(),
        UrMyTalkSettingBlacklistPage.routeName: (context) => UrMyTalkSettingBlacklistPage(),
        UrMyTalkSettingWithdrawalPage.routeName: (context) => const UrMyTalkSettingWithdrawalPage(),
        UrMyTalkSettingUpdateEmailPage.routeName: (context) => const UrMyTalkSettingUpdateEmailPage(),
        UrMyTalkSettingLanguagePage.routeName: (context) => const UrMyTalkSettingLanguagePage(),
        UrMyTalkHelpMainPage.routeName: (context) => UrMyTalkHelpMainPage(),
        UrMyTalkHelpInquiryPage.routeName: (context) => const UrMyTalkHelpInquiryPage(),
        UrMyTalkHelpInquiryListPage.routeName: (context) => const UrMyTalkHelpInquiryListPage(),
        UrMyTalkHelpCurrentInquiryPage.routeName: (context) => const UrMyTalkHelpCurrentInquiryPage(),
        UrMyTalkUpdateMainProfilePage.routeName: (context) => const UrMyTalkUpdateMainProfilePage(),
        UrMyTalkUpdateBirthdateProfilePage.routeName: (context) => const UrMyTalkUpdateBirthdateProfilePage(),
        UrMyTalkUpdateNameProfilePage.routeName: (context) => const UrMyTalkUpdateNameProfilePage(),
        UrMyTalkUpdateResidenceProfilePage.routeName: (context) => const UrMyTalkUpdateResidenceProfilePage(),
        UrMyTalkUpdateMBTIProfilePage.routeName: (context) => const UrMyTalkUpdateMBTIProfilePage(),
        UrMyTalkUpdateDescriptionProfilePage.routeName: (context) => const UrMyTalkUpdateDescriptionProfilePage(),
        UrMyTalkCandidateProfilePicturePage.routeName: (context) => const UrMyTalkCandidateProfilePicturePage(),
        UrMyTalkUrMyProfilePicturePage.routeName: (context) => const UrMyTalkUrMyProfilePicturePage(),
      },
    );
  }
}

