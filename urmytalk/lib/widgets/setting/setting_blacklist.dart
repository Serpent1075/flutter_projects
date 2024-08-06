import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_io/io.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/provider/providers.dart';
import 'package:urmytalk/widgets/wigets.dart';

import '../../utils/utils.dart';

class UrMyTalkSettingBlacklistPage extends ConsumerWidget {
  static const String routeName = '/urmysettingblacklistpage';

  final _globalWidget = GlobalWidget();

  UrMyTalkSettingBlacklistPage({super.key});


  void _showPopup(
      BuildContext context, int index, CandidateState candidateState, WidgetRef ref) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(
                candidateState.blacklist!.candidatelist![index].candidateName!),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  ref.read(candidateProvider.notifier).deleteBlackList(
                      candidateState.blacklist!.candidatelist![index]);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.account_circle,
                        size: 36.0, color: Colors.orange),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 16.0),
                      child: const Text('setting.blacklist.deleteblacklist').tr(),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getblackFuture = ref.watch(blacklistProvider);
    final candidateState = ref.watch(candidateStateProvider);
    ref.listen(candidateStateProvider, (CandidateState? previous, CandidateState? next) {

    });
    return Scaffold(

      backgroundColor: Colors.white,
      appBar: _globalWidget.globalAppBar('setting.blacklist.title'.tr()),
      body:  AnnotatedRegion<SystemUiOverlayStyle>(
        value: Platform.isIOS
            ? SystemUiOverlayStyle.light
            : const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light),
        child: getblackFuture.when(
            data: ((data){
              if (data == null) {
                return Container();
              } else if (data.candidatelist!.isEmpty) {
                return Center(child: const Text('setting.blacklist.nocandidate').tr());
              } else {
                return ListView.builder(
                  itemCount: candidateState.blacklist!.candidatelist!.length,
                  itemBuilder: (context, index) {
                    try{
                      return GestureDetector(
                        onLongPress: () => _showPopup(context, index, candidateState, ref),
                        child: ListTile(
                          leading: candidateState.blacklist!.candidatelist![index].profilePicPath ==
                              null
                              ? const CircleAvatar(
                            backgroundImage: AssetImage(
                                'assets/images/native_profile.png'),
                          )
                              : CircleAvatar(
                            backgroundImage: NetworkImage(getProfilePicPath(
                                candidateState.blacklist!.candidatelist![index].contentUrl!,
                                candidateState.blacklist!.candidatelist![index].candidateUuid!,
                                "${candidateState.blacklist!.candidatelist![index].profilePicPath!
                                    .last
                                    .filename!}?w=$ProfilePic100&h=$ProfilePic100")),
                          ),
                          title: Text(
                              candidateState.blacklist!.candidatelist![index].candidateName!),
                          trailing:   Container(
                              padding: const EdgeInsets.fromLTRB(5,5,5,5),
                              child: _globalWidget.createCircularPercentageIndicator(20, 2, 10,double.parse(candidateState.blacklist!.candidatelist![index].opponentGrade!))
                          ),
                        ),
                      );
                    } catch (e) {
                      return Container();
                    }

                  },
                );
              }
            }),
            error: ((error, stackTrace) {
              _globalWidget.showNormalDialog(context, "error", error.toString());
              return const UrMyTalkSignInPage();
            }),
            loading: ((){
              return  const Center(child: CircularProgressIndicator(),);
            })),
      )
    );
  }

}