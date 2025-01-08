/* import 'package:avaz_app/common/common_text_to_speak.dart';
import 'package:avaz_app/util/app_color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../common/common_image_button.dart';
import '../../common/common_zoom_animation_widget.dart';

class GridDateScreen extends StatefulWidget {
  const GridDateScreen(
      {super.key, required this.flutterTts, required this.onAdd});
  final FlutterTts flutterTts;
  final Function(String, String) onAdd;

  @override
  State<GridDateScreen> createState() => _GridDateScreenState();
}

class _GridDateScreenState extends State<GridDateScreen> {
  List<String> gridList = [
    "hello",
    "ok",
    "bye",
    "how",
    "where",
    "why",
    "which",
    "done",
    "finish",
    "sport",
    "game",
    "cap",
    "fish",
    "cat",
    "dog",
    "cow",
    "egg",
    "apple",
    "banana",
    "not",
    "eat",
    "play"
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      color: AppColorConstants.white,
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6, // Number of columns in the grid
            childAspectRatio: 6 / 5, // Aspect ratio of the grid items
            mainAxisSpacing: 5,
            crossAxisSpacing: 5),
        shrinkWrap: true,
        itemCount: gridList.length,
        itemBuilder: (context, index) {
          var data = gridList[index];
          return CommonZoomAnimationWidget(
            onTap: () {},
            child: CommonTextToSpeak(
              flutterTts: widget.flutterTts,
              text: data,
              onTap: () {
                widget.onAdd(data, "assets/grid_icons/$data-image.png");
              },
              child: CommonImageButton(
                  buttonImage: "assets/grid_icons/$data-image.png",
                  imageSize: 55,
                  isImageShow: true,
                  backgroundColor: AppColorConstants.keyBoardBackColor,
                  borderColor: AppColorConstants.keyBoardBackColor,
                  textStyle: const TextStyle(
                      color: AppColorConstants.keyBoardTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                  buttonIconColor: null,
                  buttonName: data),
            ),
          );
        },
      ),
    );
  }
}
 */
import 'package:avaz_app/util/app_color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../common/common_zoom_animation_widget.dart';
import '../../model/get_category_modal.dart';
import '../../util/dimensions.dart';
import '../settings/setting_model/account_setting_model.dart';
import '../settings/setting_model/audio_setting.dart';
import '../settings/setting_model/general_setting.dart';
import '../settings/setting_model/keyboard_setting.dart';
import '../settings/setting_model/picture_appearance_setting_model.dart';
import '../settings/setting_model/picture_behaviour_setting_model.dart';
import '../settings/setting_model/touch_setting.dart';

class GridDateScreen extends StatefulWidget {
  const GridDateScreen(
      {super.key,
      required this.flutterTts,
      required this.onAdd,
      required this.getCategoryModalList,
      required this.changeTable,
      this.accountSettingModel,
      this.pictureAppearanceSettingModel,
      this.pictureBehaviourSettingModel,
      this.keyboardSettingModel,
      this.audioSettingModel,
      this.generalSettingModel,
      this.touchSettingModel,
      required this.playAudio,
      this.stopAudio,
      this.onLongTap,
      required this.hexToBordorColor});
  final FlutterTts flutterTts;
  final List<GetCategoryModal> getCategoryModalList;
  final Function(String text, String? image, {String? audioFile}) onAdd;
  final Function(String slug) changeTable;
  final Function(String audioPath) playAudio;
  final Function(String type) hexToBordorColor;
  final AccountSettingModel? accountSettingModel;
  final PictureAppearanceSettingModel? pictureAppearanceSettingModel;
  final PictureBehaviourSettingModel? pictureBehaviourSettingModel;
  final KeyboardSettingModel? keyboardSettingModel;
  final AudioSettingModel? audioSettingModel;
  final GeneralSettingModel? generalSettingModel;
  final TouchSettingModel? touchSettingModel;
  final Function()? stopAudio;
  final Function(int? id,{int? rowNumber})? onLongTap;

  @override
  State<GridDateScreen> createState() => _GridDateScreenState();
}

class _GridDateScreenState extends State<GridDateScreen> {
  List<dynamic> gridList = [
    {
      "count": 77,
      "item": 11,
      "ratio": 1.3,
      "image": Dimensions.screenHeight * 0.05,
      "text": Dimensions.screenHeight * 0.01
    },
    {
      "count": 60,
      "item": 10,
      "ratio": 1.3,
      "image": Dimensions.screenHeight * 0.05,
      "text": Dimensions.screenHeight * 0.01
    },
    {
      "count": 40,
      "item": 8,
      "ratio": 1.3,
      "image": Dimensions.screenHeight * 0.08,
      "text": Dimensions.screenHeight * 0.03
    },
    {
      "count": 24,
      "item": 6,
      "ratio": 1.3,
      "image": Dimensions.screenHeight * 0.1,
      "text": Dimensions.screenHeight * 0.05
    },
    {
      "count": 15,
      "item": 5,
      "ratio": 1.3,
      "image": Dimensions.screenHeight * 0.1,
      "text": Dimensions.screenHeight * 0.05
    },
    {
      "count": 8,
      "item": 4,
      "ratio": 1.2,
      "image": Dimensions.screenHeight * 0.2,
      "text": Dimensions.screenHeight * 0.07
    },
    {
      "count": 4,
      "item": 2,
      "ratio": 2.4,
      "image": Dimensions.screenHeight * 0.2,
      "text": Dimensions.screenHeight * 0.07
    },
    {
      "count": 3,
      "item": 3,
      "ratio": 0.8,
      "image": Dimensions.screenHeight * 0.3,
      "text": Dimensions.screenHeight * 0.1
    },
    {
      "count": 2,
      "item": 2,
      "ratio": 1.2,
      "image": Dimensions.screenHeight * 0.3,
      "text": Dimensions.screenHeight * 0.1
    },
    {
      "count": 1,
      "item": 1,
      "ratio": 2.4,
      "image": Dimensions.screenHeight * 0.3,
      "text": Dimensions.screenHeight * 0.1
    },
  ];

  @override
  Widget build(BuildContext context) {
    double ratio = gridList.firstWhere(
      (element) =>
          element["count"] ==
          widget.pictureAppearanceSettingModel!.picturePerScreenCount!,
      orElse: () =>
          {"ratio": 1.0}, // Provide a default value if no match is found
    )["ratio"];
    int count = gridList.firstWhere(
      (element) =>
          element["count"] ==
          widget.pictureAppearanceSettingModel!.picturePerScreenCount!,
      orElse: () => {"item": 6}, // Provide a default value if no match is found
    )["item"];
    double imageSize = gridList.firstWhere(
      (element) =>
          element["count"] ==
          widget.pictureAppearanceSettingModel!.picturePerScreenCount!,
      orElse: () => {
        "image": Dimensions.screenHeight * 0.1
      }, // Provide a default value if no match is found
    )["image"];
    double textSize = gridList.firstWhere(
      (element) =>
          element["count"] ==
          widget.pictureAppearanceSettingModel!.picturePerScreenCount!,
      orElse: () => {
        "text": Dimensions.screenHeight * 0.05
      }, // Provide a default value if no match is found
    )["text"];
    return Container(
      height: double.infinity,
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      color: AppColorConstants.white,
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: count, // Number of columns in the grid
            childAspectRatio: ratio, // Aspect ratio of the grid items
            mainAxisSpacing: 5,
            crossAxisSpacing: 5),
        shrinkWrap: true,
        itemCount: widget.getCategoryModalList.length,
        itemBuilder: (context, index) {
          var getCategoryData = widget.getCategoryModalList[index];
          return CommonZoomAnimationWidget(
            hexToBordorColor: widget.hexToBordorColor,
            onLongTap: widget.onLongTap,
            stopAudio: widget.stopAudio,
            playAudio: widget.playAudio,
            imageSize: imageSize,
            textSize: textSize,
            accountSettingModel: widget.accountSettingModel,
            audioSettingModel: widget.audioSettingModel,
            generalSettingModel: widget.generalSettingModel,
            keyboardSettingModel: widget.keyboardSettingModel,
            pictureAppearanceSettingModel: widget.pictureAppearanceSettingModel,
            pictureBehaviourSettingModel: widget.pictureBehaviourSettingModel,
            touchSettingModel: widget.touchSettingModel,
            flutterTts: widget.flutterTts,
            onAdd: widget.onAdd,
            changeTable: widget.changeTable,
            getCategoryModal: getCategoryData,
          );
        },
      ),
    );
  }
}
