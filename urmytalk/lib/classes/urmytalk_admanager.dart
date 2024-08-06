import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class UrMyTalkAdManager {

  AdManagerInterstitialAd? adManagerInterstitialAd;

  String getInterstitialAdUnitId() {

    switch (Platform.operatingSystem) {
      case "android" :
        //real
      return "ca-app-pub-3368556349512006/4663798034";
      //test
        //return 'ca-app-pub-3940256099942544/1033173712';
      case "ios" :
        //real
      return "ca-app-pub-3368556349512006/3306221004";
      //test
        //return 'ca-app-pub-3940256099942544/4411468910';
      default :
        return "/6499/example/interstitial";
    }
  }

  void loadFullScreenAd() async {
    AdManagerInterstitialAd.load(
        adUnitId: getInterstitialAdUnitId(),
        request: const AdManagerAdRequest(),
        adLoadCallback: AdManagerInterstitialAdLoadCallback(
          onAdLoaded: (AdManagerInterstitialAd ad) {
            // Keep a reference to the ad so you can show it later.
            adManagerInterstitialAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            //print('InterstitialAd failed to load: $error');
          },
        ));

    adManagerInterstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (AdManagerInterstitialAd ad) {
        //print('%ad onAdShowedFullScreenContent.');
      },
      onAdDismissedFullScreenContent: (AdManagerInterstitialAd ad) {
      //print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (AdManagerInterstitialAd ad, AdError error) {
        //print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
      },
      onAdImpression: (AdManagerInterstitialAd ad) {
        //print('$ad impression occurred.');
      },
    );
  }

  void dispose() {
    adManagerInterstitialAd?.dispose();
  }


}