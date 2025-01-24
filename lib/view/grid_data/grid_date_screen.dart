import 'package:avaz_app/util/app_color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';

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
      required this.hexToBordorColor,
      required this.gridScrollController,
      required this.changePosition});
  final FlutterTts flutterTts;
  final List<GetCategoryModal> getCategoryModalList;
  final Function(String text, String? image, {String? audioFile}) onAdd;
  final Function(String slug) changeTable;
  final Function(String audioPath) playAudio;
  final Function(String type) hexToBordorColor;
  final Function() changePosition;
  final AccountSettingModel? accountSettingModel;
  final PictureAppearanceSettingModel? pictureAppearanceSettingModel;
  final PictureBehaviourSettingModel? pictureBehaviourSettingModel;
  final KeyboardSettingModel? keyboardSettingModel;
  final AudioSettingModel? audioSettingModel;
  final GeneralSettingModel? generalSettingModel;
  final TouchSettingModel? touchSettingModel;
  final Function()? stopAudio;
  final Function(int? id, {int? rowNumber, int? pinValue})? onLongTap;
  final ScrollController gridScrollController;

  @override
  State<GridDateScreen> createState() => _GridDateScreenState();
}

class _GridDateScreenState extends State<GridDateScreen> {
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
    double draggerWidth = gridList.firstWhere(
      (element) =>
          element["count"] ==
          widget.pictureAppearanceSettingModel!.picturePerScreenCount!,
      orElse: () => {"width": null},
    )["width"];
    double draggerHeight = gridList.firstWhere(
      (element) =>
          element["count"] ==
          widget.pictureAppearanceSettingModel!.picturePerScreenCount!,
      orElse: () =>
          {"height": null}, // Provide a default value if no match is found
    )["height"];
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
        child:
            /* GridView.builder(
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
      ), */
            widget.getCategoryModalList.isEmpty
                ? SizedBox(
                    width: Dimensions.screenWidth,
                  )
                : DraggableGridViewBuilder(
                    controller: widget.gridScrollController,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: count, // Number of columns
                      childAspectRatio: ratio, // Aspect ratio
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                    ),
                    physics: const ScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    isOnlyLongPress: false, // Enable drag on long press
                    dragFeedback: (context, index) {
                      // Ensure the drag feedback has the same size as the original item
                      var getCategoryData = widget.getCategoryModalList[index];
                      return Material(
                        color: Colors.transparent, // Transparent background
                        child: SizedBox(
                          height: draggerHeight,
                          width: draggerWidth,
                          child: CommonZoomAnimationWidget(
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
                            pictureAppearanceSettingModel:
                                widget.pictureAppearanceSettingModel,
                            pictureBehaviourSettingModel:
                                widget.pictureBehaviourSettingModel,
                            touchSettingModel: widget.touchSettingModel,
                            flutterTts: widget.flutterTts,
                            onAdd: widget.onAdd,
                            changeTable: widget.changeTable,
                            getCategoryModal: getCategoryData,
                          ),
                        ),
                      );
                    },
                    children: widget.getCategoryModalList
                        .asMap()
                        .entries
                        .map((entry) {
                      var getCategoryData = entry.value;
                      return DraggableGridItem(
                        isDraggable: getCategoryData.pinItem == 0,
                        child: CommonZoomAnimationWidget(
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
                          pictureAppearanceSettingModel:
                              widget.pictureAppearanceSettingModel,
                          pictureBehaviourSettingModel:
                              widget.pictureBehaviourSettingModel,
                          touchSettingModel: widget.touchSettingModel,
                          flutterTts: widget.flutterTts,
                          onAdd: widget.onAdd,
                          changeTable: widget.changeTable,
                          getCategoryModal: getCategoryData,
                        ),
                      );
                    }).toList(),
                    dragCompletion: (List<DraggableGridItem> list,
                        int beforeIndex, int afterIndex) {
                      final movedItem =
                          widget.getCategoryModalList.removeAt(beforeIndex);
                      widget.getCategoryModalList.insert(afterIndex, movedItem);
                      widget.changePosition();
                    },
                  ));
  }
}
