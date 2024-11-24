import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../common/common.dart';
import '../../common/common_image_button.dart';
import '../../util/app_color_constants.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen(
      {super.key, required this.scaffoldKey, required this.flutterTts});
  final GlobalKey<ScaffoldState> scaffoldKey;
  final FlutterTts flutterTts;
  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: CommonImageButton(
            backgroundColor: AppColorConstants.keyBoardBackColor,
            borderColor: AppColorConstants.keyBoardBackColor,
            isImageShow: true,
            vertical: 0,
            height: 50,
            onTap: () {
              speakToText("Close", widget.flutterTts);
              widget.scaffoldKey.currentState?.closeEndDrawer();
            },
            horizontal: 2,
            buttonIconColor: AppColorConstants.black,
            width: 75,
            imageSize: 35,
            borderRadius: const BorderRadiusDirectional.horizontal(
                start: Radius.circular(5)),
            buttonIcon: Icons.close,
          ),
        ),
        Expanded(
          child: Container(
            color: AppColorConstants.keyBoardBackColor,
            child: const Row(
              children: [
                Column(
                  children: [
                    Text("Menu+")
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
