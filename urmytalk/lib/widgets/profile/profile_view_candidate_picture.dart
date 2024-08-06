import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_io/io.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/provider/providers.dart';
import 'package:urmytalk/widgets/wigets.dart';

class UrMyTalkCandidateProfilePicturePage extends ConsumerStatefulWidget {
  static const String routeName = '/urmycandidateprofilepicturepage';

  const UrMyTalkCandidateProfilePicturePage({Key? key}) : super(key: key);
  //const UrMyRegisterPage({Key key}) : super(key: key);

  @override
  ConsumerState<UrMyTalkCandidateProfilePicturePage> createState() => _UrMyTalkCandidateProfilePicturePageState();
}

class _UrMyTalkCandidateProfilePicturePageState extends ConsumerState<UrMyTalkCandidateProfilePicturePage> {

  final _globalWidget = GlobalWidget();
  int _currentIndex = 1;
  int _maxCount = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildBody(ChatState chatState) {
    if (chatState.currentCandidates == null) {
      return Image.asset('assets/images/native_profile.png', height: 300);
    } else if (chatState.currentCandidates!.profilePicPath == null){
      _currentIndex =0;
      return  Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 20,
          ),
          Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0,10.0,0.0,0.0),
                    child: Center(
                      child: ClipRect(
                        child: Text("$_currentIndex/$_maxCount"),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0,8.0,0.0,0.0),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: urmyMainColor,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ]
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 4.5,
          ),
          Expanded(
            child:  ClipRect(
                child: SizedBox(
                    width: ProfilePic500,
                    height: ProfilePic500,
                    child: Image.asset('assets/images/native_profile.png', fit: BoxFit.cover)
                )
            ),
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height / 4.5,
          ),
        ],
      );
    }
    _maxCount = chatState.currentCandidates!.profilePicPath!.length;

    return

        CarouselSlider(
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height,
          aspectRatio: 16/9,
          viewportFraction: 0.8,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 20),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal,
          onPageChanged: (index, reason) {
            setState((){
              _currentIndex = index+1;
            });
          },
          //onPageChanged: callbackFunction,
        ),
        items: chatState.currentCandidates!.profilePicPath!.reversed.map((profilepic) {
          return Builder(
            builder: (BuildContext context) {
              return Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                  ),
                  Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _globalWidget.customIndex(context, _maxCount,_currentIndex),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8.0,0.0,8.0,8.0),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              color: urmyMainColor,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    )
                  ]),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                  ),

                  Expanded(
                    child:  _globalWidget.profilePic(
                        context: context,
                        profileurl: chatState.currentCandidates!.contentUrl!,
                        uuid: chatState.currentCandidates!.candidateUuid!,
                        profilelist: profilepic,
                        size: ProfilePic500,
                        borderredi: const BorderRadius.all(Radius.circular(10.0)),
                        shape: BoxShape.rectangle
                    ),
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height / 4.5,
                  ),
                ],
              );
            },
          );
        }).toList(),

      );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _globalWidget.customConsumerWidget(
          buildBody(ref.watch(chatStateProvider))
      )
    );
  }

}