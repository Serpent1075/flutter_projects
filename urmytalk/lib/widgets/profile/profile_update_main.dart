import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_io/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/widgets/wigets.dart';
import 'package:urmytalk/provider/providers.dart';

class UrMyTalkUpdateMainProfilePage extends ConsumerStatefulWidget {
  const UrMyTalkUpdateMainProfilePage({Key? key}) : super(key: key);
  static const String routeName = '/urmyupdatemainprofilepage';

  @override
  ConsumerState<UrMyTalkUpdateMainProfilePage> createState() => _UrMyTalkUpdateMainProfilePageState();
}

class _UrMyTalkUpdateMainProfilePageState extends ConsumerState<UrMyTalkUpdateMainProfilePage> {

  late String imagePath;
  final _globalWidget = GlobalWidget();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildBody(SignInState signinState) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _createAccountInformation(signinState),
        _createListMenu(context, signinState.mbti, 0,"profile.update.mbti.subtitle".tr()),
        Divider(height: 0, color: Colors.grey[400]),
        _createListMenu(context, signinState.birthdate, 1,"profile.update.birthdate.subtitle".tr()),
        Divider(height: 0, color: Colors.grey[400]),
        _createListMenu(context, "${signinState.country}, ${signinState.statevalue}, ${signinState.city}", 2,"profile.update.residence.subtitle".tr()),
        Divider(height: 0, color: Colors.grey[400]),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 18, 0, 0),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              signout();
              //Navigator.pop(context, (route) => false);

            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.power_settings_new, size: 20, color: ASSENT_COLOR),
                const SizedBox(width: 8),
                const Text('profile.update.main.signout',
                    style: TextStyle(fontSize: 15, color: ASSENT_COLOR)).tr(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void signout() {
    ref.read(signinProvider.notifier).signout();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(signinStateProvider, (SignInState? previous, SignInState? next) {
      if (next!.profileupdateerr.isNotEmpty) {
        if (next.error == "updateprofile") {
          _globalWidget.showDialogWithFunc(context, 'profile.update.birthdate.toomanyerr'.tr(), ref.read(signinProvider.notifier).setErrorEmpty());
        }else if(next!.error.isNotEmpty) {
          _globalWidget.showDialogWithFunc(context, 'profile.update.birthdate.err'.tr(), ref.read(signinProvider.notifier).setErrorEmpty());
        }
      }

      if(!next!.authenticated && previous!.authenticated != next.authenticated) {
        Navigator.pushNamedAndRemoveUntil(context, UrMyTalkSignInPage.routeName, (route) => false);
      }
    });

    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: urmyIconColor, //change your color here
          ),
          elevation: 0,
          title: const Text(
            'Account',
            style: TextStyle(
                fontWeight: urmyTitleFontWeight,
                fontSize: urmyTitleFontSize,
                color: urmyMainColor
            ),
          ),
          backgroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          actions: [

          ],
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                color: Colors.grey[100],
                height: 1.0,
              )),
        ),
        body: _globalWidget.customConsumerWidget(
            buildBody(ref.watch(signinStateProvider))
        ),
    );
  }

  Widget _createAccountInformation(SignInState signinState) {
    final double profilePictureSize = MediaQuery.of(context).size.width / 6;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
              onTap: () {
                takePhoto(ImageSource.gallery);
              },
              child: signinState.imageFilePath == null || signinState.imageFilePath!.isEmpty
                  ? Image.asset('assets/images/native_profile.png', height: profilePictureSize)
                  : SizedBox(
              width: profilePictureSize,
              height: profilePictureSize,
              child: _globalWidget.profilePic(
                context: context,
                profileurl: signinState.contentUrl,
                uuid: signinState.uuid,
                profilelist: signinState.imageFilePath!.last,
                size: ProfilePic200,
                borderredi: const BorderRadius.all(Radius.circular(10.0)),
                shape: BoxShape.rectangle
              ),
                ),
            ),


          const SizedBox(
            width: urmyDefaultPadding,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, UrMyTalkUpdateNameProfilePage.routeName);
                  },
                  child: Row(
                    children: [
                      Text(signinState.name,
                          style: const TextStyle(
                              color: urmyLabelColor,
                              fontSize: urmysubTitleFontSize,
                              fontWeight: urmysubTitleFontWeight
                          )),
                      const SizedBox(
                        width: 8,
                      ),
                      const Icon(Icons.chevron_right, size: urmyIconSize, color: urmyIconColor)
                    ],
                  ),
                ),
                const SizedBox(
                  height: urmyContentPadding,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, UrMyTalkUpdateDescriptionProfilePage.routeName);
                  },
                  child: Row(
                    children: [
                      Text(signinState.description.trim(),
                          style: const TextStyle(
                              color: urmyTextColor,
                              fontSize: urmyContentFontSize,
                              fontWeight: urmyContentFontWeight
                          ),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        maxLines: 1,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Icon(Icons.chevron_right, size: urmyIconSize, color: urmyIconColor)
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _createListMenu(BuildContext context, String menuTitle, int index, String type) {
    menuTitle = menuTitle.trim();
    menuTitle = menuTitle.replaceAll(", ,", "");
    if (menuTitle.length <4){
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _navigateTo(context, index);
        },
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 18, 0, 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(type,
                    style: const TextStyle(
                        fontWeight: urmyContentFontWeight,
                        fontSize: urmyContentFontSize,
                        color: urmyTextColor
                    )),
              ),
              const Icon(Icons.chevron_right, size: urmyIconSize, color: urmyIconColor),
            ],
          ),
        ),
      );
    } else {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _navigateTo(context, index);
        },
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 18, 0, 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(menuTitle,
                    style: const TextStyle(
                        fontWeight: urmyContentFontWeight,
                        fontSize: urmyContentFontSize,
                        color: urmyTextColor)),
              ),
              const Icon(Icons.chevron_right, size: urmyIconSize, color: urmyIconColor),
            ],
          ),
        ),
      );
    }
  }

  void _navigateTo(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, UrMyTalkUpdateMBTIProfilePage.routeName);
        break;
      case 1:
        Navigator.pushNamed(
            context, UrMyTalkUpdateBirthdateProfilePage.routeName);
        break;
      case 2:
        Navigator.pushNamed(
            context, UrMyTalkUpdateResidenceProfilePage.routeName);
        break;
    }
  }


  Future<void> takePhoto(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(
          source: source,
          maxWidth: 600,
          maxHeight: 600
      );
      if (pickedFile != null) {
        final croppedFilepath = await _cropImage(pickedFile.path);
        if (croppedFilepath == '') {
          _globalWidget.profileDialog("Need to be cropped");
        } else {
          setState(() {
            imagePath = croppedFilepath;
          });
          ref.read(signinProvider.notifier).updateProfileImage(imagePath);
        }
      }
    } catch (e) {

    }
  }

  Future<String> _cropImage(String filePath) async {
    final CroppedFile? cropedFile = await ImageCropper().cropImage(
      sourcePath: filePath,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      uiSettings: [
        AndroidUiSettings(
            hideBottomControls: true,
            toolbarTitle: 'Cropper',
            toolbarColor: urmyMainColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if(cropedFile != null) {
      return cropedFile.path;
    }
    return '';
  }

}
