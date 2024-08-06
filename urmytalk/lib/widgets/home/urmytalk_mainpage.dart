import 'dart:io';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/provider/providers.dart';
import 'package:urmytalk/widgets/wigets.dart';


class UrMyTalkMainPage extends ConsumerStatefulWidget {
  static const String routeName = '/urmytalkmainpage2';

  const UrMyTalkMainPage({Key? key}) : super(key: key);

  @override
  ConsumerState<UrMyTalkMainPage> createState() => _UrMyTalkMainPageState();
}


class _UrMyTalkMainPageState extends ConsumerState<UrMyTalkMainPage> with WidgetsBindingObserver {

  late PageController _pageController;
  int _currentIndex = 0;
  final _globalWidget = GlobalWidget();

  final List<Widget> _contentPages = <Widget>[
    const CandidatesMain(),
    const ChatMy(),
  ];


  @override
  void initState() {

    _pageController = PageController(initialPage: 0);
    _pageController.addListener(_handleTabSelection);

    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  void _handleTabSelection() {
    setState(() {
    });
  }


  void _tapNav(index){

    _currentIndex = index;
    _pageController.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
    FocusScope.of(context).unfocus();
  }

  Widget buildBody(SignInState signinState) {
   return PageView(
     controller: _pageController,
     physics: const NeverScrollableScrollPhysics(),
     children: _contentPages.map((Widget content) {
       return content;
     }).toList(),
   );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(signinStateProvider, (SignInState? previous, SignInState? next) {


    });

    if(ref.read(appConfigProvider.notifier).state.buildFlavor == 'dev') {

    }
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: Platform.isIOS
          ? SystemUiOverlayStyle.light
          : const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
      ),
        child: Scaffold(
          body: _globalWidget.customConsumerWidget(
              buildBody(ref.watch(signinStateProvider))
          ),
          bottomNavigationBar: ConvexAppBar(
            style : TabStyle.react,
            color : urmyTabTextColor,
            activeColor: urmyTabTextColor,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [urmyGradientTop,urmyGradientMiddleTop, urmyGradientMiddleBottom]
            ),
            items: [
              TabItem(icon:Icons.people_alt_rounded, title: "home.candidates".tr()),
              TabItem(icon:Icons.chat, title: "home.chat".tr()),
            ],
            initialActiveIndex: 0,
            onTap: (int i){
              _tapNav(i);
            },
          ),
          /*
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Fluttertoast.showToast(msg: 'FAB Pressed', toastLength: Toast.LENGTH_SHORT);
            },
            child: Icon(Icons.add),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          */
        ),
      );
  }
}