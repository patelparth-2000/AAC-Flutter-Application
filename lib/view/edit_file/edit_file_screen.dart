// ignore_for_file: file_names

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../common/common_image_button.dart';
import '../../services/data_base_service.dart';
import '../../util/app_color_constants.dart';
import '../../util/dimensions.dart';
import '../keyboard/keyboard_screen.dart';
import '../settings/setting_model/keyboard_setting.dart';
import '../settings/setting_model/touch_setting.dart';

class EditFileScreen extends StatefulWidget {
  const EditFileScreen(
      {super.key,
      required this.dataBaseService,
      required this.flutterTts,
      this.keyboardSettingModel,
      required this.rename,
      this.touchSettingModel});
  final DataBaseService dataBaseService;
  final FlutterTts flutterTts;
  final KeyboardSettingModel? keyboardSettingModel;
  final Function(String) rename;
  final TouchSettingModel? touchSettingModel;

  @override
  EditFileScreenState createState() => EditFileScreenState();
}

class EditFileScreenState extends State<EditFileScreen> {
  bool isKeyBoardShow = false;
  bool isSearchOpen = false;
  final TextEditingController _mainTextFieldController =
      TextEditingController();
  final List<Map<String, dynamic>> _widgetList = [];
  late ScrollController _scrollController;
  String keyboardSuggtionText = "";

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.topRowBackground,
      body: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
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
                        touchSettingModel: widget.touchSettingModel,
                        isImageShow: true,
                        isTextShow: true,
                        vertical: 0,
                        height: 50,
                        text: "Cancle",
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {});
                        },
                        horizontal: 2,
                        width: 75,
                        buttonName: "Cancle",
                        buttonIcon: Icons.cancel,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          height: 50,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 5),
                          decoration: BoxDecoration(
                              color: AppColorConstants.white,
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            children: [
                              if (_widgetList.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.only(left: 3.0),
                                  child: Text("Enter Name for folder..."),
                                ),
                              Expanded(
                                child: SizedBox(
                                  height: 50,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    controller: _scrollController,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _widgetList.length,
                                    itemBuilder: (context, index) {
                                      return Center(
                                          child: _widgetList[index]["widget"]);
                                    },
                                  ),
                                ),
                              ),
                              if (_widgetList.isNotEmpty)
                                for (int i = 0;
                                    i < textFieldButtonNameList.length;
                                    i++)
                                  Row(
                                    children: [
                                      CommonImageButton(
                                        touchSettingModel:
                                            widget.touchSettingModel,
                                        isImageShow: true,
                                        isTextShow: true,
                                        vertical: 0,
                                        horizontal: 0,
                                        width: 45,
                                        height: 45,
                                        isSpeak: textFieldButtonNameList[i]
                                                        ["name"]
                                                    .toString()
                                                    .toLowerCase() ==
                                                "speak"
                                            ? false
                                            : true,
                                        backgroundColor:
                                            AppColorConstants.white,
                                        buttonIconColor: AppColorConstants
                                            .imageTextButtonColor,
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
                                      ),
                                    ],
                                  ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: CommonImageButton(
                          touchSettingModel: widget.touchSettingModel,
                          isImageShow: true,
                          isTextShow: true,
                          vertical: 0,
                          height: 50,
                          width: 75,
                          text: "Save",
                          buttonIcon: Icons.save,
                          buttonName: "Save",
                          onTap: () {
                            widget.rename(readAllText());
                            Navigator.pop(context);
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: KeyboardScreen(
                        dataBaseService: widget.dataBaseService,
                        flutterTts: widget.flutterTts,
                        onAdd: _addNewWidget,
                        onSpace: onSpace,
                        deleteLast: removeLastCharacter,
                        onTextValue: addTextFieldValue,
                        keyboardSettingModel: widget.keyboardSettingModel,
                        isMain: false,
                        suggetionSearch: keyboardSuggtionText,
                      )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isNewWidget = true;

  void addTextFieldValue(String text, {bool isKeyboard = false}) async {
    setState(() {
      if (_isNewWidget) {
        _mainTextFieldController.text = text;
        _widgetList.add({
          "widget": Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              child: Text(_mainTextFieldController.text))
        });
        _isNewWidget = false;
      } else {
        _mainTextFieldController.text += text;
        if (_widgetList.isNotEmpty &&
            _widgetList.last["widget"] is Container &&
            (_widgetList.last["widget"] as Container).child is Text) {
          // var lastWidget = _widgetList.last as Container;
          // var lastText = lastWidget.child as Text;
          _widgetList[_widgetList.length - 1]["widget"] = Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              child: Text(_mainTextFieldController.text));
        }
      }
      keyboardSuggtionText = _mainTextFieldController.text;
      scrollLastItem();
    });
  }

  List<Map<String, dynamic>> textFieldButtonNameList = [
    {"name": "Delete", "icon": Icons.backspace_rounded},
    {"name": "Clear", "icon": Icons.delete_forever_outlined},
  ];

  void onTextfieldButton(int i) async {
    // speakToText(textFieldButtonNameList[i]["name"], flutterTts);
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
    }

    setState(() {});
  }

  void _addNewWidget(text, String? image, {String? audioFile}) async {
    setState(() {
      _widgetList.add({
        'widget': Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("$text"),
              ],
            )),
        'audio': audioFile,
      });
      // _widgetList.add();
      _isNewWidget = true;
      _mainTextFieldController.clear();
      scrollLastItem();
    });
  }

  String readAllText() {
    String textInColumn = "";
    for (var item in _widgetList) {
      var widget = item['widget'];
      if (widget is Container) {
        var child = widget.child;
        if (child is Column) {
          textInColumn += child.children
              .whereType<Text>()
              .map((textWidget) => textWidget.data ?? "")
              .join(" ");
        } else if (child is Text) {
          textInColumn += child.data ?? "";
        }
        textInColumn += " ";
      }
    }
    return textInColumn;
  }

  void removeLastCharacter() async {
    setState(() {
      if (_mainTextFieldController.text.isNotEmpty) {
        _mainTextFieldController.text = _mainTextFieldController.text
            .substring(0, _mainTextFieldController.text.length - 1);
        if (_widgetList.isNotEmpty &&
            _widgetList.last["widget"] is Container &&
            (_widgetList.last["widget"] as Container).child is Text) {
          _widgetList[_widgetList.length - 1]["widget"] = Container(
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
      keyboardSuggtionText = "";
      _mainTextFieldController.clear();
      scrollLastItem();
    });
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
