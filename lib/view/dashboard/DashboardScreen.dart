// ignore_for_file: file_names

import 'dart:async';
import 'package:avaz_app/common/common.dart';
import 'package:avaz_app/util/dimensions.dart';
import 'package:avaz_app/view/test/test2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

import '../../common/common_image_button.dart';
import '../../util/app_color_constants.dart';
import '../grid_data/grid_date_screen.dart';
import '../keyboard/keyboard_screen.dart';

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
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
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
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _canExit ? true : false,
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
                        speakToText(!isKeyBoardShow ? "Pictures" : "Keyboard",
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
                                controller: _scrollController,
                                scrollDirection: Axis.horizontal,
                                itemCount: _widgetList.length,
                                itemBuilder: (context, index) {
                                  return Center(child: _widgetList[index]);
                                },
                              ),
                            ),
                          ),
                          if (_widgetList.isNotEmpty)
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
                                      onTextfieldButton(i);
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
                  Expanded(
                    child: isKeyBoardShow
                        ? KeyboardScreen(
                            flutterTts: flutterTts,
                            onAdd: _addNewWidget,
                            onSpace: onSpace,
                            deleteLast: removeLastCharacter,
                            onTextValue: addTextFieldValue,
                          )
                        : GridDateScreen(
                            flutterTts: flutterTts,
                            onAdd: _addNewWidget,
                          ),
                  ),
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

  void onTextfieldButton(int i) {
    speakToText(textFieldButtonNameList[i]["name"], flutterTts);
    if (textFieldButtonNameList[i]["name"] == "Delete") {
      _isNewWidget = true;
      _mainTextFieldController.clear();
      if (_widgetList.isNotEmpty) {
        _widgetList.removeLast();
      }
    } else if (textFieldButtonNameList[i]["name"] == "Clear") {
      _isNewWidget = true;
      _mainTextFieldController.clear();
      _widgetList.clear();
    } else if (textFieldButtonNameList[i]["name"] == "Speak") {
      readAllText();
    } else if (textFieldButtonNameList[i]["name"] == "Share") {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MyHomePage(title: "hello boys"),
          ));
    }

    setState(() {});
  }

  void _addNewWidget(text, String? icon) {
    setState(() {
      _widgetList.add(Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null)
                Image.asset(
                  icon,
                  height: 20,
                  width: 20,
                ),
              Text("$text"),
            ],
          )));
      _isNewWidget = true;
      _mainTextFieldController.clear();
      scrollLastItem();
    });
  }

  bool _isNewWidget = true;

  void addTextFieldValue(String text) {
    setState(() {
      if (_isNewWidget) {
        _mainTextFieldController.text = text;
        _widgetList.add(Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            child: Text(_mainTextFieldController.text)));
        _isNewWidget = false;
      } else {
        _mainTextFieldController.text += text;
        if (_widgetList.isNotEmpty &&
            _widgetList.last is Container &&
            (_widgetList.last as Container).child is Text) {
          // var lastWidget = _widgetList.last as Container;
          // var lastText = lastWidget.child as Text;
          _widgetList[_widgetList.length - 1] = Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              child: Text(_mainTextFieldController.text));
        }
      }
      scrollLastItem();
    });
  }

  void removeLastCharacter() {
    setState(() {
      if (_mainTextFieldController.text.isNotEmpty) {
        _mainTextFieldController.text = _mainTextFieldController.text
            .substring(0, _mainTextFieldController.text.length - 1);
        if (_widgetList.isNotEmpty &&
            _widgetList.last is Container &&
            (_widgetList.last as Container).child is Text) {
          _widgetList[_widgetList.length - 1] = Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              child: Text(_mainTextFieldController.text));
        }
      }
      scrollLastItem();
    });
  }

  void onSpace() {
    setState(() {
      _isNewWidget = true;
      _mainTextFieldController.clear();
      scrollLastItem();
    });
  }

  void readAllText() {
    String allText = _widgetList
        .map((widget) {
          if (widget is Container) {
            var child = widget.child;
            if (child is Column) {
              return child.children
                  .whereType<Text>()
                  .map((textWidget) => (textWidget).data)
                  .join(" ");
            } else if (child is Text) {
              return child.data;
            }
          }
          return "";
        })
        .where((text) => text!.isNotEmpty)
        .join(" ");
    speakToText(allText, flutterTts);
  }

  void scrollLastItem() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
