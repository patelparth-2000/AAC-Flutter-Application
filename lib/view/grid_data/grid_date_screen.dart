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

import '../../common/common.dart';
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

class GridDateScreen extends StatelessWidget {
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
      required this.hexToBordorColor,
      required this.gridScrollController});
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
  final Function(int? id, {int? rowNumber})? onLongTap;
  final ScrollController gridScrollController;

  @override
  Widget build(BuildContext context) {
    double ratio = gridList.firstWhere(
      (element) =>
          element["count"] ==
          pictureAppearanceSettingModel!.picturePerScreenCount!,
      orElse: () =>
          {"ratio": 1.0}, // Provide a default value if no match is found
    )["ratio"];
    int count = gridList.firstWhere(
      (element) =>
          element["count"] ==
          pictureAppearanceSettingModel!.picturePerScreenCount!,
      orElse: () => {"item": 6}, // Provide a default value if no match is found
    )["item"];
    double imageSize = gridList.firstWhere(
      (element) =>
          element["count"] ==
          pictureAppearanceSettingModel!.picturePerScreenCount!,
      orElse: () => {
        "image": Dimensions.screenHeight * 0.1
      }, // Provide a default value if no match is found
    )["image"];
    double textSize = gridList.firstWhere(
      (element) =>
          element["count"] ==
          pictureAppearanceSettingModel!.picturePerScreenCount!,
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
        controller: gridScrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: count, // Number of columns in the grid
            childAspectRatio: ratio, // Aspect ratio of the grid items
            mainAxisSpacing: 5,
            crossAxisSpacing: 5),
        shrinkWrap: true,
        itemCount: getCategoryModalList.length,
        itemBuilder: (context, index) {
          var getCategoryData = getCategoryModalList[index];
          return CommonZoomAnimationWidget(
            hexToBordorColor: hexToBordorColor,
            onLongTap: onLongTap,
            stopAudio: stopAudio,
            playAudio: playAudio,
            imageSize: imageSize,
            textSize: textSize,
            accountSettingModel: accountSettingModel,
            audioSettingModel: audioSettingModel,
            generalSettingModel: generalSettingModel,
            keyboardSettingModel: keyboardSettingModel,
            pictureAppearanceSettingModel: pictureAppearanceSettingModel,
            pictureBehaviourSettingModel: pictureBehaviourSettingModel,
            touchSettingModel: touchSettingModel,
            flutterTts: flutterTts,
            onAdd: onAdd,
            changeTable: changeTable,
            getCategoryModal: getCategoryData,
          );
        },
      ),
    );
  }
}
