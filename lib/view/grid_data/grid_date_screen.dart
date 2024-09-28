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

class GridDateScreen extends StatefulWidget {
  const GridDateScreen(
      {super.key,
      required this.flutterTts,
      required this.onAdd,
      required this.getCategoryModalList});
  final FlutterTts flutterTts;
  final List<GetCategoryModal> getCategoryModalList;
  final Function(String text, String? image) onAdd;

  @override
  State<GridDateScreen> createState() => _GridDateScreenState();
}

class _GridDateScreenState extends State<GridDateScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
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
        itemCount: widget.getCategoryModalList.length,
        itemBuilder: (context, index) {
          var data = widget.getCategoryModalList[index];
          return CommonZoomAnimationWidget(
            flutterTts: widget.flutterTts,
            text: data.name.toString(),
            image: null,
            onAdd: widget.onAdd,
            type: data.type.toString(),
            slug: data.slug.toString(),
            // onNavigationChange: getDataFromDatabse,
          );
        },
      ),
    );
  }
}
