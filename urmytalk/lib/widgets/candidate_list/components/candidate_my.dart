import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:urmytalk/provider/providers.dart';
import 'package:urmytalk/widgets/wigets.dart';


import '../../../utils/utils.dart';

class CandidateMy extends ConsumerStatefulWidget {
  const CandidateMy({Key? key}) : super(key: key);

  @override
  ConsumerState<CandidateMy> createState() => _CandidateMyState();
}

class _CandidateMyState extends ConsumerState<CandidateMy> {

  final _globalWidget = GlobalWidget();


  @override
  void initState() {
    ref.read(candidateProvider.notifier).getFriendList();
    ref.read(candidateProvider.notifier).getBlackList();

    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }


  Widget getCandidates(CandidateState candidateState) {
    if (candidateState.friends == null) {
      return Container();
    } else if (candidateState.friends!.candidatelist!.isEmpty) {
      return Center(child: const Text('home.nocandidate').tr());
    } else {
      return ListView.builder(
        itemCount: candidateState.friends!.candidatelist!.length,
        itemBuilder: (context, index) {
          try {
            return GestureDetector(
              onLongPress: () => _showPopup(context, index, candidateState),
              child: ListTile(
                leading: candidateState.friends!.candidatelist![index].profilePicPath ==
                    null
                    ? const CircleAvatar(
                  backgroundImage: AssetImage(
                      'assets/images/native_profile.png'),
                )
                    : CircleAvatar(
                  backgroundImage: NetworkImage(getProfilePicPath(
                      candidateState.friends!.candidatelist![index].contentUrl!,
                      candidateState.friends!.candidatelist![index].candidateUuid!,
                      "${candidateState.friends!.candidatelist![index].profilePicPath!
                          .last
                          .filename!}?w=$ProfilePic100&h=$ProfilePic100")),
                ),
                title: Text(
                    candidateState.friends!.candidatelist![index].candidateName!),
                trailing:   Container(
                    padding: const EdgeInsets.fromLTRB(5,5,5,5),
                    child: _globalWidget.createCircularPercentageIndicator(20, 2, 10,double.parse(candidateState.friends!.candidatelist![index].opponentGrade!))
                ),
                onTap: () {

                  ref.read(chatProvider.notifier).setCurrentCandidate(
                      candidateState.friends!.candidatelist![index]);
                  Navigator.pushNamed(
                      context, UrMyTalkCandidateProfilePage.routeName);
                },
              ),
            );
          } catch (e) {
            return Container();
          }

        },
      );
    }
  }

  void _showPopup(
      BuildContext context, int index, CandidateState candidateState) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(
                candidateState.friends!.candidatelist![index].candidateName!),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  ref.read(candidateProvider.notifier).deleteFriendList(
                      candidateState.friends!.candidatelist![index]);
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.account_circle,
                        size: 36.0, color: Colors.orange),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 16.0),
                      child: const Text('home.deletefriend').tr(),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  ref.read(candidateProvider.notifier).addBlackList(
                      candidateState.friends!.candidatelist![index]);
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.account_circle,
                        size: 36.0, color: Colors.orange),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 16.0),
                      child: const Text('home.blockfriend').tr(),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  Widget buildBody(CandidateState candidateState) {

    return getCandidates(candidateState);
  }


  @override
  Widget build(BuildContext context) {

      ref.listen(candidateStateProvider, (CandidateState? previous, CandidateState? next) {
      if(ref.read(appConfigProvider.notifier).state.buildFlavor == 'dev') {

      }

    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: _globalWidget.customConsumerWidget(
          buildBody(ref.watch(candidateStateProvider))
      ),
    );
  }
}
