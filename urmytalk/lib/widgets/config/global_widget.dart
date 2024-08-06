import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:introduction_slider/source/presentation/widgets/background_decoration.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:urmytalk/provider/providers.dart';
import 'package:urmytalk/utils/utils.dart';
import 'dart:io';
import 'constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:urmytalk/models/models.dart';

class GlobalWidget{
  Random _random = Random();

  // create random color for polylines
  Color _getColor() {
    return Color.fromARGB(
        255, _random.nextInt(255), _random.nextInt(255), _random.nextInt(255));
  }

  final List<IconData> _iconList = [
    Icons.star_rate,
    Icons.code,
    Icons.adb,
    Icons.android,
    Icons.select_all,
    Icons.eco,
    Icons.label_important,
    Icons.album,
    Icons.scatter_plot,
    Icons.memory,
    Icons.audiotrack,
    Icons.miscellaneous_services,
    Icons.whatshot
  ];

  PreferredSizeWidget globalCustomAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: urmyGradientTop,
      leading: Padding(
        padding: const EdgeInsets.fromLTRB(8.0,8.0,0.0,0.0),
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: urmyLogoColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  PreferredSizeWidget globalAppBar(String title){
    return AppBar(
      iconTheme: const IconThemeData(
        color: Colors.black, //change your color here
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      centerTitle: false,
      title : Text(title, style: const TextStyle(color: BLACK21, fontSize: 20, fontWeight: FontWeight.bold)),
      bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey[100],
            height: 1.0,
          )),
    );
  }

  PreferredSizeWidget customAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: urmyGradientTop,
      leading: Padding(
        padding: const EdgeInsets.fromLTRB(8.0,8.0,0.0,0.0),
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: urmyLogoColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Widget customConsumerWidget(Widget buildBody) {
    return Consumer(
      builder: (context, ref, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: Platform.isIOS
              ? SystemUiOverlayStyle.light
              : const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.light),
          child: buildBody,
        );
      },
    );
  }

  Widget profileDialog(String dialog){
    return AlertDialog(
      content: Text(dialog),
    );
  }

  Widget profilePic({required BuildContext context, required UrMyProfilePicData? profilelist, required String uuid, required String profileurl, required double size, required BorderRadius borderredi, required BoxShape shape}){
     //remove .0 when requests image via url
    if (profilelist == null) {
      return ClipRect(
          child: SizedBox(
            width: size,
            height: size,
            child: Image.asset('assets/images/native_profile.png', fit: BoxFit.cover)
          )
        );
    } else {"?w=200&h=200";
    String sizeofimage = ((size/100).round()*100).toInt().toString();
      //print(getProfilePicPath(profileurl, context.read(signinProvider.notifier).state.uuid, profilelist.filename! + "?w="+sizeofimage+"&h="+sizeofimage));
      return Container(
          height:size,
          width: size,
          decoration: BoxDecoration(
              shape: shape,
              borderRadius: borderredi,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(getProfilePicPath(profileurl, uuid, "${profilelist.filename!}?w=$sizeofimage&h=$sizeofimage")
          ),

      )));
    }
  }


  Widget screenTabList({required BuildContext context, required String title, String? desc, required String routename}){
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: (){
        Navigator.pushNamed(context, routename);
      },
      child: Container(
        margin: const EdgeInsets.only(top:8, bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 24),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w400
                    )),
                    const SizedBox(height: 4),
                    (desc==null)?Wrap():Text(desc, style: TextStyle(
                        fontSize: 12, color: Colors.grey[700]
                    )),
                    (desc==null)?Wrap():const SizedBox(height: 4),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget screenCandidateList({required BuildContext context, required String title, String? desc, required StatefulWidget page}){
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        margin: const EdgeInsets.only(top:16, bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 24),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w400
                    )),
                    const SizedBox(height: 4),
                    (desc==null)?Wrap():Text(desc, style: TextStyle(
                        fontSize: 12, color: Colors.grey[700]
                    )),
                    (desc==null)?Wrap():const SizedBox(height: 4),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget screenChatList({required BuildContext context, required String title, String? desc, required StatefulWidget page}){
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        margin: const EdgeInsets.only(top:16, bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 24),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w400
                    )),
                    const SizedBox(height: 4),
                    (desc==null)?Wrap():Text(desc, style: TextStyle(
                        fontSize: 12, color: Colors.grey[700]
                    )),
                    (desc==null)?Wrap():const SizedBox(height: 4),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }



  Widget screenDetailList({required BuildContext context, required String title, required StatefulWidget page}){
    Color _color = _getColor();
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Card(
          elevation: 0.5,
          child: Container(
            margin: const EdgeInsets.all(18),
            child: Row(
              children: [
                Icon(_iconList[_random.nextInt(_iconList.length)], color: _color, size: 26),
                const SizedBox(width: 24),
                Expanded(
                  child: Text(title, style: const TextStyle(
                      fontSize: 16, color: BLACK55, fontWeight: FontWeight.w500
                  )),
                ),
                Icon(Icons.chevron_right, size: 30, color: _color),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget createDetailWidget({required String title, required String desc}){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text(title, style: const TextStyle(
              fontSize: 18, color: BLACK21, fontWeight: FontWeight.w500
          )),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Container(
            child: Text(desc, style: const TextStyle(
                fontSize: 15, color: BLACK77,letterSpacing: 0.5
            )),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 24, bottom: 8),
          child: const Text('Example', style: TextStyle(
              fontSize: 18, color: BLACK21, fontWeight: FontWeight.w500
          )),
        ),
      ],
    );
  }

  Widget createButton({Color backgroundColor = Colors.blue, Color textColor = Colors.white, required String buttonName, required Function onPressed,}){
    return TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) => backgroundColor,
          ),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.0),
              )
          ),
        ),
        onPressed: onPressed as void Function(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            buttonName,
            style: TextStyle(
                fontSize: 14,
                color: textColor),
            textAlign: TextAlign.center,
          ),
        )
    );
  }

  Widget createDefaultLabel(context){
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
      decoration: BoxDecoration(
          color: SOFT_BLUE,
          borderRadius: BorderRadius.circular(2)
      ),
      child: Row(
        children: const [
          Text('Default', style: TextStyle(
              color: Colors.white, fontSize: 13
          )),
          SizedBox(
            width: 4,
          ),
          Icon(Icons.done, color: Colors.white, size: 11)
        ],
      ),
    );
  }

  Widget createRatingBar({double rating=5, double size=24}){
    if(rating < 0){
      rating = 0;
    } else if(rating>5){
      rating = 5;
    }

    bool _absolute = false;
    int _fullStar = 0;
    int _emptyStar = 0;

    if(rating == 0 || rating == 1 || rating == 2 || rating == 3 || rating == 4 || rating == 5){
      _absolute = true;
    } else {
      double _dec = (rating - int.parse(rating.toString().substring(0,1)));
      if(_dec > 0 && _dec < 1){
        if(_dec >= 0.25 && _dec <= 0.75){
          _absolute = false;
        } else {
          _absolute = true;
          if(_dec < 0.25){
            _emptyStar = 1;
          } else if(_dec > 0.75){
            _fullStar = 1;
          }
        }
      }
    }
    return Row(
      children: [
        for(int i=1;i<=rating+_fullStar;i++) Icon(Icons.star, color: Colors.yellow[700], size: size),
        !_absolute?Icon(Icons.star_half, color: Colors.yellow[700], size: size):const SizedBox.shrink(),
        for(int i=1;i<=(5-rating+_emptyStar);i++) Icon(Icons.star_border, color: Colors.yellow[700], size: size),
      ],
    );
  }

  Widget customNotifIcon({int count=0, Color notifColor=Colors.grey, Color labelColor=Colors.pinkAccent, double notifSize=24, double labelSize=14, String position='right'}) {
    double? posLeft;
    double? posRight = 0;
    if(position == 'left'){
      posLeft = 0;
      posRight = null;
    }
    return Stack(
      children: <Widget>[
        Icon(Icons.notifications, color: notifColor, size: notifSize),
        Positioned(
          left: posLeft,
          right: posRight,
          child: Container(
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: labelColor,
              borderRadius: BorderRadius.circular(labelSize),
            ),
            constraints: BoxConstraints(
              minWidth: labelSize,
              minHeight: labelSize,
            ),
            child: Center(
              child: Text(
                count.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget buildProgressIndicator(lastData) {
    if(lastData==false){
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Opacity(
            opacity: 1,
            child: Container(
              height: 20,
              width: 20,
              margin: const EdgeInsets.all(5),
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(PRIMARY_COLOR),
                strokeWidth: 2.0,
              ),
            ),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }


  BackgroundImageDecoration createIntroBackgroundWidget() {
    return BackgroundImageDecoration(
      image: const AssetImage("assets/images/logo/logo.png"),
      colorFilter: ColorFilter.mode(
        Colors.black.withOpacity(0.6),
        BlendMode.darken,
      ),
      fit: BoxFit.cover,
      opacity: 1.0,
    );
  }


  Widget createIntroLogoWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
          margin: EdgeInsets.fromLTRB(
              0, MediaQuery.of(context).size.height / 10, 0, 0),
          alignment: Alignment.topCenter,
          child: SvgPicture.asset(
            'assets/images/logo/logo.svg',
            semanticsLabel: 'Urmy Logo',
            color: urmyLogoColor,
            width: MediaQuery.of(context).size.height/5,
          )),
    );
  }

  Widget createBackground(BuildContext context, Widget widget) {
    return Stack(
      children: <Widget>[
        // top blue background gradient
        Container(
          height: MediaQuery.of(context).size.height / 2.5,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [urmyGradientTop, urmyGradientMiddleTop,urmyGradientMiddleBottom,urmyGradientBottom],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                stops: [0.1, 0.4, 0.6, 0.9,],
              )),
        ),
        // set your logo here
        Container(
            margin: EdgeInsets.fromLTRB(
                0, MediaQuery.of(context).size.height / 10, 0, 0),
            alignment: Alignment.topCenter,
            child: SvgPicture.asset(
                'assets/images/logo/logo.svg',
                semanticsLabel: 'Urmy Logo',
                color: urmyLogoColor,
                width: MediaQuery.of(context).size.height/5,
            )),
        widget
      ],
    );
  }

  Widget createBackgroundWithoutLogo(BuildContext context, Widget widget) {
    return Stack(
      children: <Widget>[
        // top blue background gradient
        Container(
          height: MediaQuery.of(context).size.height / 2.5,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [urmyGradientTop, urmyGradientMiddleTop,urmyGradientMiddleBottom,urmyGradientBottom],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.1, 0.4, 0.6, 0.9,],
              )),
        ),
        widget
      ],
    );
  }

  Widget createCard(BuildContext context, Widget widget){
    return  Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      margin: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.width/10, MediaQuery.of(context).size.height / 3.5 - 72, MediaQuery.of(context).size.width/10, 0),
      color: urmyCardColor,
      child: Container(
          margin: const EdgeInsets.fromLTRB(24, 0, 24, 20),
          child: widget),
    );
  }

  Widget createProfileCard(BuildContext context, Widget widget){
    Size size = MediaQuery.of(context).size;
    return  Card(
      semanticContainer: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      margin: EdgeInsets.fromLTRB(size.width/12, 5, size.width/12, 5),
      color: urmyCardColor,
      child: Container(
          child: widget),
    );
  }

  Future showNormalDialog(BuildContext context, String title, String content){
    return showDialog(context: context, builder: (BuildContext context) {
     return  AlertDialog(
        title: Text(title),
        titleTextStyle: const TextStyle(
            fontSize: urmyAlertTitleFontSize,
            fontWeight: urmyAlertTitleFontWeight,
            color: urmyAlertTitleColor),
        content: Text(content),
        contentTextStyle: const TextStyle(
          fontSize: urmyAlertTextFontSize,
          fontWeight: urmyAlertTextFontWeight,
          color: urmyAlertTextColor
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('global.confirm', style: TextStyle(
              fontWeight: urmyAlertActionFontWeight,
              fontSize: urmyAlertActionFontSize,
              color: urmyAlertActionColor
            ),).tr(),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],

      );
    });
  }

  Future showDialogWithFunc(BuildContext context, String content, void function){
    return showDialog(context: context, builder: (BuildContext context) {
      return  AlertDialog(
        content: Text(content),
        contentTextStyle: const TextStyle(
            fontSize: urmyAlertTextFontSize,
            fontWeight: urmyAlertTextFontWeight,
            color: urmyAlertTextColor
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('global.confirm', style: TextStyle(
                fontWeight: urmyAlertActionFontWeight,
                fontSize: urmyAlertActionFontSize,
                color: urmyAlertActionColor
            ),).tr(),
            onPressed: () {
              function;
              Navigator.pop(context);
            },
          ),
        ],

      );
    });
  }

  ButtonStyle urmyButtonStyle() {
    return ButtonStyle(
      backgroundColor:
      MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) => urmyMainColor,
      ),
      overlayColor: MaterialStateProperty.all(
          Colors.transparent),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          )),
      elevation: MaterialStateProperty.all(2.0),
    );
  }

  Widget urmyButtonLoading(){
    return const SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        valueColor:
        AlwaysStoppedAnimation<Color>(
          Colors.white,
        ),
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget urmyButtonText(String content){
    return Text(
      content,
      style: const TextStyle(
          fontWeight: urmyButtonFontWeight,
          fontSize: urmyButtonTextFontSize, color: urmyButtonTextColor),
      textAlign: TextAlign.center,
    );
  }

  Widget customIndex(BuildContext context,int maxindex ,int currentindex ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(4.0),
            color: urmyTextColor,
            child: Text("$currentindex/$maxindex",
              style: const TextStyle(
                  fontSize: urmySubTextFontSize,
                  fontWeight: urmySubTextFontWeight, color: urmyButtonTextColor
              ),),
          ),
        ),
      ),
    );
  }

  Widget customlogo(Color color){
    const String assetName = 'assets/images/logo/logo.svg';
    return SvgPicture.asset(
        assetName,
        semanticsLabel: 'Urmy Logo',
        color: color,
    );
  }



  Widget createCircularPercentageIndicator(double radius, double linewidth, double fontsize, double grade) {
    if (grade > 9) {
      return  CircularPercentIndicator(
        radius: radius,
        lineWidth: linewidth,
        percent: grade*0.1,
        center: Text("${(grade*100).round()/10}%", style: TextStyle(fontSize: fontsize, fontWeight: urmyContentFontWeight, color: urmyPercentColor),),
        progressColor: urmyMainColor,
      );
    } else if (grade > 7) {
      return  CircularPercentIndicator(
        radius: radius,
        lineWidth: linewidth,
        percent: grade*0.1,
        center: Text("${(grade*100).round()/10}%", style: TextStyle(fontSize: fontsize, fontWeight: urmyContentFontWeight, color: urmyPercentColor),),
        progressColor: Colors.green,
      );
    } else if(grade > 4) {
      return  CircularPercentIndicator(
        radius: radius,
        lineWidth: linewidth,
        percent: grade*0.1,
        center: Text("${(grade*100).round()/10}%", style: TextStyle(fontSize: fontsize, fontWeight: urmyContentFontWeight, color: urmyPercentColor),),
        progressColor: Colors.yellow,
      );
    } else {
      return  CircularPercentIndicator(
        radius: radius,
        lineWidth: linewidth,
        percent: grade*0.1,
        center: Text("${(grade*100).round()/10}%", style: TextStyle(fontSize: fontsize, fontWeight: urmyContentFontWeight, color: urmyPercentColor),),
        progressColor: Colors.red,
      );
    }

  }

}