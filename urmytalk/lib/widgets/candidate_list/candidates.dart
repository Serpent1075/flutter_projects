import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/models/models.dart';
import 'package:urmytalk/provider/providers.dart';
import 'package:urmytalk/widgets/wigets.dart';
import '../../../utils/utils.dart';

class CandidatesMain extends ConsumerStatefulWidget {
  const CandidatesMain({Key? key}) : super(key: key);

  @override
  ConsumerState<CandidatesMain> createState() => _CandidatesMainState();
}


class _CandidatesMainState extends ConsumerState<CandidatesMain> with SingleTickerProviderStateMixin {

  late TabBar _tabBar;
  int _tabIndex = 0;
  late TabController _tabController;
  final _globalWidget = GlobalWidget();
  late final Future? checknumFuture;

  final List<Tab> _tabBarList = [
    Tab(text: 'home.mydestiny'.tr()),
    Tab(text: 'home.worlddestiny'.tr()),
    //Tab( text: "Global Destiny")
  ];

  @override
  void initState() {
    _tabController = TabController(
        vsync: this, length: _tabBarList.length, initialIndex: _tabIndex);
    ref.read(candidateProvider.notifier).getCandidateList();
    checknumFuture = ref.read(candidateProvider.notifier).checknumberofcandidate();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  Widget buildBody(CandidateState candidateState) {
    return TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          CandidateMy(),
          CandidateWorld(),
        ]);
  }

  Widget leadingTitle(BuildContext context) {
    var futureBuilder = FutureBuilder(
        future: checknumFuture,
        builder: (context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const CircularProgressIndicator();
            default:
              if (snapshot.hasError) {
                int? numcandi = ref
                    .read(candidateProvider.notifier)
                    .state
                    .numberofcandidate;
                return Text(
                  "${"candidate.numofcandi".tr()} : $numcandi",
                  style: const TextStyle(
                      color: urmyLogoColor,
                      fontWeight: urmyContentFontWeight,
                      fontSize: urmyContentFontSize),
                );
              } else {
                String num;

                if (snapshot.data > 1000) {
                  num = "${snapshot.data/1000}k";
                } else {
                  num = "${snapshot.data}";
                }

                if (snapshot.data > 1000000) {
                  num = "${snapshot.data/1000000}m";
                }

                return Text(
                  "${"candidate.numofcandi".tr()} $num",
                  style: const TextStyle(
                      color: urmyLogoColor,
                      fontWeight: urmyContentFontWeight,
                      fontSize: urmyContentFontSize),
                );
              }
          }
        });
    return futureBuilder;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: DefaultTabController(
      length: _tabBarList.length,
      child: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, value) {
          var sizeofimage = 100;
          return [
            SliverAppBar(
              backgroundColor: urmyMainColor,
              flexibleSpace: Container(
                height: MediaQuery.of(context).size.height / 2.5,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [urmyGradientTop, urmyGradientMiddleTop,urmyGradientMiddleBottom],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.1, 0.5, 0.8],
                    )),
              ),
              leading: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                child: _globalWidget.customlogo(urmyLogoColor),
              ),
              iconTheme: const IconThemeData(
                color: Colors.black, //change your color here
              ),
              actions: [
                GestureDetector(
                  child: ref
                      .read(signinProvider.notifier)
                      .state
                      .imageFilePath ==
                      null
                      ? const Padding(
                    padding: EdgeInsets.fromLTRB(0,4,8,0),
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/native_profile.png'),
                    ),
                  )
                      : Padding(
                    padding: const EdgeInsets.fromLTRB(0,4,8,0),
                    child: CircleAvatar(backgroundImage: NetworkImage(getProfilePicPath(
                        ref.read(signinProvider.notifier).state.contentUrl,
                        ref.read(signinProvider.notifier).state.uuid,
                        "${ref.read(signinProvider.notifier).state.imageFilePath!.last.filename!}?w=$sizeofimage&h=$sizeofimage")),
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, UrMyTalkMainProfilePage.routeName);
                  },
                ), //IconButton
                //IconButton
              ],
              elevation: 0,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              floating: false,
              pinned: true,
              snap: false,
              centerTitle: true,
              title: leadingTitle(context),
              bottom: PreferredSize(
                  preferredSize: Size.fromHeight(MediaQuery.of(context).size.height /20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _tabBar = TabBar(
                        controller: _tabController,
                        onTap: (position) {
                          setState(() {
                            _tabIndex = position;
                          });
                          //print('idx : '+_tabIndex.toString());
                        },
                        isScrollable: true,
                        labelColor: urmyTabTextColor,
                        labelStyle: const TextStyle(fontSize: urmySubTextTitleFontSize, fontWeight: urmySubTextTitleFontWeight, color: urmyTabTextColor),
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorWeight: 4,
                        indicatorColor: urmyTabTextColor,
                        unselectedLabelColor: SOFT_GREY,
                        labelPadding:
                        const EdgeInsets.symmetric(horizontal: 30.0),
                        tabs: _tabBarList,
                      ),
                      Container(
                        color: Colors.grey[200],
                        height: 1.0,
                      )
                    ],
                  )),
            ),
          ];
        },
        body: _globalWidget.customConsumerWidget(
            buildBody(ref.watch(candidateStateProvider))
        ),
      ),
    ),
    );
  }
}
