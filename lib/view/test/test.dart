import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import '../../common/common.dart';
import '../../common/common_image_button.dart';
import '../../util/app_color_constants.dart';
import '../../util/dimensions.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  final FlutterTts flutterTts = FlutterTts();
  bool _canExit = false;
  bool isKeyBoardShow = false;
  final TextEditingController _mainTextFieldController =
      TextEditingController();
  final List<Widget> _widgetList = [];

  @override
  void initState() {
    super.initState();
    setDefaultEngineAndLanguage();
  }

  Future<void> setDefaultEngineAndLanguage() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      // ignore: avoid_print
      print("Default engine: $engine");
    }

    // Set default language
    await flutterTts.setLanguage("en-US");

    // Optionally set other TTS parameters
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    setState(() {});
  }

  @override
  void dispose() {
    _mainTextFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _canExit,
      onPopInvokedWithResult: (value, popdata) async {
        if (_canExit) {
          return;
        } else {
          scaffoldMessengerMessage(
            context: context,
            message: 'back_massage'.tr,
          );
          _canExit = true;
          Timer(const Duration(seconds: 2), () {
            _canExit = false;
          });
        }
      },
      child: Scaffold(
        backgroundColor: AppColorConstants.topRowBackground,
        body: Column(
          children: [
            Container(
              color: AppColorConstants.topRowBackground,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  CommonImageButton(
                    isImageShow: true,
                    isTextShow: true,
                    vertical: 0,
                    height: 50,
                    onTap: () {
                      isKeyBoardShow = !isKeyBoardShow;
                      setState(() {});
                      Future.delayed(const Duration(milliseconds: 10))
                          .whenComplete(() {
                        speakToText(isKeyBoardShow ? "Pictures" : "Keyboard",
                            flutterTts);
                      });
                    },
                    horizontal: 2,
                    width: 75,
                    buttonName: isKeyBoardShow ? "Pictures" : "Keyboard",
                    buttonIcon:
                        isKeyBoardShow ? Icons.photo : Icons.keyboard_alt,
                  ),
                  Expanded(
                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          color: AppColorConstants.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: _widgetList.length,
                                itemBuilder: (context, index) {
                                  return Center(child: _widgetList[index]);
                                },
                              ),
                            ),
                          ),
                          for (int i = 0; i < 4; i++)
                            Row(
                              children: [
                                CommonImageButton(
                                  isImageShow: true,
                                  isTextShow: true,
                                  vertical: 0,
                                  horizontal: 0,
                                  width: 45,
                                  height: 45,
                                  backgroundColor: AppColorConstants.white,
                                  buttonIconColor:
                                      AppColorConstants.imageTextButtonColor,
                                  buttonIcon: textFieldButtonNameList[i]
                                      ["icon"],
                                  imageSize: 25,
                                  buttonName: textFieldButtonNameList[i]
                                      ["name"],
                                  textStyle: const TextStyle(
                                      color: AppColorConstants
                                          .imageTextButtonColor,
                                      fontSize: 10),
                                  onTap: () {
                                    speakToText(
                                        textFieldButtonNameList[i]["name"],
                                        flutterTts);
                                    if (textFieldButtonNameList[i]["name"] ==
                                        "Delete") {
                                      if (_mainTextFieldController
                                          .text.isNotEmpty) {
                                        _mainTextFieldController.text =
                                            _mainTextFieldController.text
                                                .substring(
                                                    0,
                                                    _mainTextFieldController
                                                            .text.length -
                                                        1);
                                      } else if (_widgetList.isNotEmpty) {
                                        _widgetList.removeLast();
                                      }
                                    } else if (textFieldButtonNameList[i]
                                            ["name"] ==
                                        "Clear") {
                                      _mainTextFieldController.clear();
                                      _widgetList.clear();
                                    } else if (textFieldButtonNameList[i]
                                            ["name"] ==
                                        "Speak") {
                                      speakToText(_mainTextFieldController.text,
                                          flutterTts);
                                    } else if (textFieldButtonNameList[i]
                                            ["name"] ==
                                        "Share") {
                                      // Add your share functionality here
                                    }
                                    setState(() {});
                                  },
                                ),
                                SizedBox(
                                  width: Dimensions.screenWidth * 0.004,
                                )
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                  CommonImageButton(
                    isImageShow: true,
                    isTextShow: true,
                    vertical: 0,
                    height: 50,
                    width: 75,
                    buttonIcon: Icons.menu,
                    buttonName: "Menu",
                    onTap: () {
                      speakToText("Menu", flutterTts);
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  // Expanded(
                  //   child: isKeyBoardShow
                  //       ? KeyboardScreen(
                  //           flutterTts: flutterTts,
                  //           onAdd: _addTextToField,
                  //           onSpace: _addNewWidget,
                  //         )
                  //       : GridDateScreen(
                  //           flutterTts: flutterTts,
                  //           onAdd: _addTextToField,
                  //         ),
                  // ),
                  if (!isKeyBoardShow)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      color: AppColorConstants.topRowBackground,
                      child: Column(
                        children: [
                          for (int i = 0; i < 6; i++)
                            Column(
                              children: [
                                CommonImageButton(
                                  isImageShow: true,
                                  isTextShow: true,
                                  vertical: 0,
                                  height: Dimensions.screenHeight * 0.12,
                                  width: 75,
                                  imageSize: 25,
                                  textStyle: const TextStyle(
                                      color: AppColorConstants.imageTextColor,
                                      fontSize: 12),
                                  buttonIcon: sideButtonNameList[i]["icon"],
                                  buttonName: sideButtonNameList[i]["name"],
                                  onTap: () {
                                    speakToText(sideButtonNameList[i]["name"],
                                        flutterTts);
                                  },
                                ),
                                if (i != 5)
                                  SizedBox(
                                    height: Dimensions.screenHeight * 0.012,
                                  )
                              ],
                            ),
                        ],
                      ),
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> sideButtonNameList = [
    {"name": "Go back", "icon": Icons.keyboard_backspace_sharp},
    {"name": "Home", "icon": Icons.home},
    {"name": "Quick", "icon": Icons.spatial_tracking_outlined},
    {"name": "Up", "icon": Icons.upload},
    {"name": "Down", "icon": Icons.download_sharp},
    {"name": "Search", "icon": Icons.search},
  ];

  List<Map<String, dynamic>> textFieldButtonNameList = [
    {"name": "Speak", "icon": Icons.spatial_tracking_outlined},
    {"name": "Delete", "icon": Icons.backspace_rounded},
    {"name": "Clear", "icon": Icons.delete_forever_outlined},
    {"name": "Share", "icon": Icons.share},
  ];
}

void speakToText(String text, FlutterTts flutterTts) async {
  if (text.isNotEmpty) {
    await flutterTts.speak(text);
  }
}
