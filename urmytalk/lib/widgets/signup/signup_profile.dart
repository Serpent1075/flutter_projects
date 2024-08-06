import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:urmytalk/provider/urmytalk_signup_provider.dart';
import 'package:urmytalk/provider/providers.dart';
import 'package:urmytalk/widgets/wigets.dart';

class UrMyTalkSignUpProfilePage extends ConsumerStatefulWidget {
  static const String routeName = '/urmyregisterprofile';

  const UrMyTalkSignUpProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<UrMyTalkSignUpProfilePage> createState() => _UrMyTalkSignUpProfilePageState();
}

class _UrMyTalkSignUpProfilePageState extends ConsumerState<UrMyTalkSignUpProfilePage> {

  final _globalWidget = GlobalWidget();
  late String name, introduction;
  final GlobalKey<FormState> _registerProfileFormKey = GlobalKey<FormState>();
  static const int maxindex=6;
  static const int currentindex=3;
  late String? imagePath = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }



  Widget buildBody(SignUpState signupState) {
    return  Form(
        key: _registerProfileFormKey,
        child: _globalWidget.createBackground(context, formListview(context, signupState))
      );
  }

  ListView formListview(BuildContext context, SignUpState signupState) {
    return ListView(
      children: <Widget>[
        _globalWidget.createCard(context, urmysignup_emailtWidget(signupState)),
        const SizedBox(
          height: urmyParagraphPadding,
        ),
      ],
    );
  }

  Widget urmysignup_emailtWidget(SignUpState signupState) {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: urmyTitlePadding ,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: const Text(
                'signup.profile.title',
                style: TextStyle(
                    color: urmyMainColor,
                    fontSize: urmyTitleFontSize,
                    fontWeight: urmyTitleFontWeight),
              ).tr(),
            ),
            _globalWidget.customIndex(context, maxindex,currentindex),
          ],
        ),

        const SizedBox(
          height: urmyTitlePadding,
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: const Text(
            'signup.profile.subtitle',
            style: TextStyle(
                color: urmyLabelColor,
                fontSize: urmysubTitleFontSize,
                fontWeight: urmysubTitleFontWeight
            ),
          ).tr(),
        ),
        const SizedBox(
          height: urmyDefaultPadding,
        ),
        signupState.imageFilePath == null || signupState.imageFilePath!.isEmpty
            ? GestureDetector(
          child: Image.asset('assets/images/native_profile.png', height: 200),
          onTap: (){
            takePhoto(ImageSource.gallery);
          },
        )
            : GestureDetector(
          child: SizedBox(
            height: 200,
            width: 200,
            child: Image.file(File(signupState.imageFilePath!)),
          ),
          onTap: (){
            takePhoto(ImageSource.gallery);
          },
        ),
        const SizedBox(
          height: urmyDefaultPadding,
        ),
        TextFormField(
            cursorColor: urmyLabelColor,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
                focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: urmyUnderlineInActiveColor)),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: urmyUnderlineActiveColor),
                ),
                labelText: 'signup.profile.nameinput'.tr(),
                labelStyle: const TextStyle(
                    fontSize: urmyContentFontSize,
                    fontWeight: urmyContentFontWeight,
                    color: urmyTextColor)),
            onSaved: (value) => name = value!
        ),
        const SizedBox(
          height: urmyDefaultPadding,
        ),
        TextFormField(
            cursorColor: urmyLabelColor,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: urmyUnderlineInActiveColor)),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: urmyUnderlineActiveColor),
              ),
              labelText: 'signup.profile.introinput'.tr(),
              labelStyle: const TextStyle(
                  fontSize: urmyContentFontSize,
                  fontWeight: urmyContentFontWeight,
                  color: urmyTextColor),

            ),
            onSaved: (value) => introduction = value!
        ),
        const SizedBox(
          height: urmyParagraphPadding,
        ),
        SizedBox(
          width: double.maxFinite,
          child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) => urmyMainColor,
                ),
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                ),
              ),
              onPressed: () {
                final form = _registerProfileFormKey.currentState;
                if (form!.validate()) {
                  form.save();
                }

                if (name.isEmpty || introduction.isEmpty) {
                  _globalWidget.showNormalDialog(context, "signup.profile.dialogtitle".tr(), "signup.profile.dialogmsg".tr());
                } else {
                  _registerEmail();
                  Navigator.pushNamed(context, UrMyTalkSignUpBirthDatePage.routeName);
                }

              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: const Text(
                  'signup.profile.submitbutton',
                  style: TextStyle(
                      fontWeight: urmyButtonFontWeight,
                      fontSize: urmyButtonTextFontSize,
                      color: urmyButtonTextColor),
                  textAlign: TextAlign.center,
                ).tr(),
              )
          ),
        ),
      ],
    );
  }

  _registerEmail() async {
    //setState(() => _autovalidateMode = AutovalidateMode.always);
    final form = _registerProfileFormKey.currentState;
    if (!form!.validate()) {
      return false;
    }
    form.save();
    await ref.read(signupProvider.notifier).signupProfile(base64.encode(utf8.encode(name)), base64.encode(utf8.encode(introduction)), imagePath!);
  }

  Future<void> takePhoto(ImageSource source) async {
    await requestPremission();
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
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
        ref.read(signupProvider.notifier).setProfilePicPath(imagePath!);
      }
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



  Future<void> requestPremission() async {
    var permission = Platform.isAndroid
        ? Permission.storage
        : Permission.photos;

    var permissionStatus = await permission.request();

    if(permissionStatus.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Widget build(BuildContext context) {
    final signupWatch = ref.watch(signupStateProvider);

    if(ref.read(appConfigProvider.notifier).state.buildFlavor == 'dev') {
      if(signupWatch.imageFilePath != null){
        print("Image File Path: ${signupWatch.imageFilePath}");
      }
    }
    return Scaffold(
      appBar: _globalWidget.customAppBar(context),
      backgroundColor: Colors.white,
      body: _globalWidget.customConsumerWidget(
          buildBody(ref.watch(signupStateProvider))
      ),
    );
  }
}