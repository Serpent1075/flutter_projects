import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'dart:io';
import 'package:urmytalk/models/models.dart';
import 'package:urmytalk/provider/providers.dart';
import 'package:urmytalk/widgets/wigets.dart';
import 'package:urmytalk/classes/urmytalk_classes.dart';
import '../../../utils/utils.dart';

class CandidateWorld extends ConsumerStatefulWidget {
  const CandidateWorld({Key? key}) : super(key: key);

  @override
  ConsumerState<CandidateWorld> createState() => _CandidateWorldState();
}


class _CandidateWorldState extends ConsumerState<CandidateWorld> {

  final _globalWidget = GlobalWidget();
  List<String> reporttype = <String>["credential","illegal","hacking", "etc"];
  String dropdownValue = "credential";
  TextEditingController contentsController = TextEditingController();
  String contents = "";
  final UrMyTalkAdManager urmytalkAdmanager = UrMyTalkAdManager();

  @override
  void initState() {
    ref.read(candidateProvider.notifier).getCandidateList();
    super.initState();
    urmytalkAdmanager.loadFullScreenAd();
  }

  @override
  void dispose() {
    urmytalkAdmanager.dispose();
    contentsController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() {
    ref.read(candidateProvider.notifier).getCandidateList();
    return Future<void>.value();
  }

  Widget getSlideCandidates(BuildContext context, CandidateState candidateState) {

    if (candidateState.candidates == null) {
      return const Center(child: CircularProgressIndicator());
    } else if (candidateState.candidates!.candidatelist!.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Center(child: const Text('home.nocandidate').tr()),
        ],
      );
    } else {
      return CarouselSlider(
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height/1.2,
          aspectRatio: 16 / 9,
          viewportFraction: 0.9,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 20),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          scrollDirection: Axis.vertical,
          //onPageChanged: callbackFunction,
        ),
        items: candidateState.filteredcandidates!.candidatelist!.map((candidate) {
          return Builder(
            builder: (BuildContext context) {
              return Column(
                children: [
                  _globalWidget.createProfileCard(
                      context, candidateListContent(context, candidate)),
                ],
              );
            },
          );
        }).toList(),
      );
    }
  }

  Widget candidateListContent(BuildContext context, Candidates candidates) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
          GestureDetector(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: candidates.profilePicPath == null
                    ? Image.asset('assets/images/native_profile.png',
                    height: MediaQuery.of(context).size.height / 1.6)
                    : _globalWidget.profilePic(
                    context: context,
                    profileurl: candidates.contentUrl!,
                    uuid: candidates.candidateUuid!,
                    profilelist: candidates.profilePicPath!.last,
                    size: MediaQuery.of(context).size.height / 1.6,
                    borderredi: const BorderRadius.all(Radius.circular(10.0)),
                    shape: BoxShape.rectangle),
              ),
            ),
            onTap: () {
              ref
                  .read(chatProvider.notifier)
                  .setCurrentCandidate(candidates);
              Navigator.pushNamed(
                  context, UrMyTalkCandidateProfilePicturePage.routeName);
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      padding: const EdgeInsets.fromLTRB(20,5,5,5),
                      child: _globalWidget.createCircularPercentageIndicator(40, 4, 20, double.parse(candidates.opponentGrade!))
                  ),

                ],
              ),
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.black.withOpacity(0.0),
                      ],
                    )),
                padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                alignment: Alignment.bottomLeft,
                //margin: const EdgeInsets.only(top: 64),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 2.0,
                      runSpacing: 2.0,
                      direction: Axis.vertical,
                      children: <Widget>[
                        Text(
                            "${candidates.candidateName!}, ${getAge(candidates.candidateBirthDate!)}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                            )),
                        Text(candidates.description!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w300,
                            )),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            candidateMBTIDescription(context, candidates),
                            candidateCountryDescription(context, candidates)
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),

                      ],
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                ),
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showPopup(context, candidates);
                        //context.read(candidateProvider.notifier).addBlackList(candidates);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        width: size.width / 8.3,
                        decoration: BoxDecoration(
                            color: urmyPrimaryColor,
                            borderRadius: const BorderRadius.all(
                                Radius.circular(10)
                            ),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 10),
                                blurRadius: 60,
                                color: urmyPrimaryColor.withOpacity(0.29),
                              )
                            ]
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Icon(Icons.report, color: urmyIconColor,size: 30,),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    GestureDetector(
                      onTap: () {
                        if(ref.read(candidateProvider.notifier).state.friends == null || ref.read(candidateProvider.notifier).state.friends!.candidatelist!.length < 5) {
                          try {
                            urmytalkAdmanager.adManagerInterstitialAd!.show();
                          } catch (e) {

                          }
                          ref.read(candidateProvider.notifier).addFriendList(candidates);
                        } else {
                          ref.read(candidateProvider.notifier).setTooManyFriendError();
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        width: size.width / 2.1,
                        decoration: BoxDecoration(
                            color: urmyPrimaryColor,
                            borderRadius: const BorderRadius.all(
                                Radius.circular(10)
                            ),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 10),
                                blurRadius: 60,
                                color: urmyPrimaryColor.withOpacity(0.29),
                              )
                            ]
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.person_add, color: urmyIconColor,size: 30,),
                            const SizedBox(width: 5,),
                            const Text("home.addfriend",style: TextStyle(color: Colors.white, fontSize: 15),).tr(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ]),
      ],
    );
  }

  void _showPopup(
      BuildContext context, Candidates candidates) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text("home.report.reporttitle", style: TextStyle(color: urmyTextColor),).tr(),
            children: [
              DropdownButton<String>(
                isExpanded: true,
                value: dropdownValue,
                icon: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.arrow_downward)),
                iconEnabledColor: urmyIconColor,
                iconSize: urmyIconSize,
                elevation: 16,
                style: const TextStyle(color: urmyTextColor),
                underline: Container(
                  height: 0,
                ),
                onChanged: (newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                selectedItemBuilder: (context){
                  return reporttype.map<Widget>((e){
                    switch (dropdownValue) {
                      case "credential":
                        return SafeArea(
                            left: true,
                            right: true,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(urmyParagraphPadding,15.0,0.0,0.0),
                              child: Column(children: [
                                const Text("home.report.reportcredential", style: TextStyle(color: urmyLabelColor,
                                    fontSize: urmyContentFontSize,
                                    fontWeight: urmyContentFontWeight),
                                ).tr()
                              ],),
                            ));
                      case "illegal":
                        return SafeArea(
                            left: true,
                            right: true,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(urmyParagraphPadding,15.0,0.0,0.0),
                              child: Column(children: [
                                const Text("home.report.reportillegalfirm", style: TextStyle(color: urmyLabelColor,
                                    fontSize: urmyContentFontSize,
                                    fontWeight: urmyContentFontWeight),
                                ).tr()
                              ],),
                            ));

                      case "hacking":
                        return SafeArea(
                            left: true,
                            right: true,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(urmyParagraphPadding,15.0,0.0,0.0),
                              child: Column(children: [
                                const Text("home.report.reporthacking", style: TextStyle(color: urmyLabelColor,
                                    fontSize: urmyContentFontSize,
                                    fontWeight: urmyContentFontWeight),
                                ).tr()
                              ],),
                            ));
                      default:
                        return SafeArea(
                            left: true,
                            right: true,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(urmyParagraphPadding,15.0,0.0,0.0),
                              child: Column(children: [
                                const Text("home.report.reportetc", style: TextStyle(color: urmyLabelColor,
                                    fontSize: urmyContentFontSize,
                                    fontWeight: urmyContentFontWeight),
                                ).tr()
                              ],),
                            ));
                    }

                  }).toList();
                },
                items:
                reporttype.map<DropdownMenuItem<String>>((String value) {
                  switch (value) {
                    case "credential":
                      return DropdownMenuItem<String>(
                        value: value,
                        child: const Text("home.report.reportcredential").tr(),
                      );
                    case "illegal":
                      return DropdownMenuItem<String>(
                        value: value,
                        child: const Text("home.report.reportillegalfirm").tr(),
                      );
                    case "hacking":
                      return DropdownMenuItem<String>(
                        value: value,
                        child: const Text("home.report.reporthacking").tr(),
                      );
                    default:
                      return DropdownMenuItem<String>(
                        value: value,
                        child: const Text("home.report.reportetc").tr(),
                      );
                  }


                }).toList(),
              ),
              const SizedBox(
                height: urmyDialogPadding,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextFormField(
                      maxLines: 5,
                      cursorColor: urmyLabelColor,
                      keyboardType: TextInputType.name,
                      controller: contentsController,
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: urmyUnderlineInActiveColor)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: urmyUnderlineActiveColor),
                        ),
                      ),
                      onSaved: (val) {
                        contents = contentsController.text;
                      },
                      onChanged: (val) {
                        contents = contentsController.text;
                      },
                      validator: (val) {
                        if (val == null || contentsController.text.isEmpty) {
                          return 'help.inquiry.needcontent'.tr();
                        }
                        if (val.length > 150) {
                          return val.substring(0,150);
                        }
                      },
                    ),
                    Text("${contentsController.text.length}/150",
                      style: const TextStyle(
                          color: urmySubTextColor,
                          fontSize: urmySubTextFontSize,
                          fontWeight: urmySubTextFontWeight
                      ),)
                  ],
                ),
              ),
              const SizedBox(
                height: urmyDialogPadding,
              ),
              SimpleDialogOption(
                onPressed: () {
                  ref.read(candidateProvider.notifier).sendCandidateReport(
                      candidates,
                      dropdownValue,
                      base64.encode(utf8.encode(contentsController.text))
                  );
                  contentsController.clear();
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text('chatboard.reportsubmit',style: TextStyle(color: urmyLabelColor,
                          fontSize: urmyMenuTitleFontSize,
                          fontWeight: urmysubTitleFontWeight),).tr(),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  Widget candidateMBTIDescription(BuildContext context, Candidates candidates){
    if (candidates.candidateMbti == null || candidates.candidateMbti=="none") {
      return const Text("");
    } else {
      return Text(candidates.candidateMbti!,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w900,
          ));
    }
  }
  Widget candidateCountryDescription(BuildContext context, Candidates candidates) {
    if (candidates.city == "null" || candidates.city == "none") {
      return const Text("");
    } else if (candidates.candidateMbti == null){
      return Text(candidates.city!,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w900,
          ));
    }else{
      return Text(",${candidates.city!}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w900,
          ));
    }
  }

  Widget buildBody(CandidateState candidateState) {
    return getSlideCandidates(context, candidateState);
  }


  @override
  Widget build(BuildContext context) {

    ref.listen(candidateStateProvider, (CandidateState? previous, CandidateState? next) {
      if(ref.read(appConfigProvider.notifier).state.buildFlavor == 'dev') {

      }
      if (next!.tmerr == 'too-many-friends') {
        _globalWidget.showDialogWithFunc(context, 'candidate.friendlimit'.tr(), ref.read(candidateProvider.notifier).setErrorEmpty());
      }
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: _globalWidget.customConsumerWidget(
            buildBody(ref.watch(candidateStateProvider))
        ),
      ),
    );
  }
}
