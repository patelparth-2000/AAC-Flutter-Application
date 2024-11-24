import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../common/common.dart';
import '../../common/common_image_button.dart';
import '../../util/app_color_constants.dart';

class KeyboardScreen extends StatefulWidget {
  const KeyboardScreen(
      {super.key,
      required this.flutterTts,
      required this.onAdd,
      required this.onTextValue,
      required this.onSpace,
      required this.deleteLast});
  final FlutterTts flutterTts;
  final Function(String, String?) onAdd;
  final Function(String) onTextValue;
  final Function() onSpace;
  final Function() deleteLast;

  @override
  State<KeyboardScreen> createState() => _KeyboardScreenState();
}

class _KeyboardScreenState extends State<KeyboardScreen> {
  List<String> suggestionList = ["I", "Yes", "Your", "it", "the"];
  List<Map<String, dynamic>> keyBoardList1 = [
    {"name": "q", "Cname": "Q", "number": "1", "icon": null},
    {"name": "w", "Cname": "W", "number": "2", "icon": null},
    {"name": "e", "Cname": "E", "number": "3", "icon": null},
    {"name": "r", "Cname": "R", "number": "4", "icon": null},
    {"name": "t", "Cname": "T", "number": "5", "icon": null},
    {"name": "y", "Cname": "Y", "number": "6", "icon": null},
    {"name": "u", "Cname": "U", "number": "7", "icon": null},
    {"name": "i", "Cname": "I", "number": "8", "icon": null},
    {"name": "o", "Cname": "O", "number": "9", "icon": null},
    {"name": "p", "Cname": "P", "number": "0", "icon": null},
    {
      "name": "delete",
      "Cname": "delete",
      "number": "delete",
      "icon": Icons.backspace_rounded,
      "action": "delete"
    },
  ];
  List<Map<String, dynamic>> keyBoardList2 = [
    {"name": "a", "Cname": "A", "number": "@", "icon": null},
    {"name": "s", "Cname": "S", "number": "#", "icon": null},
    {"name": "d", "Cname": "D", "number": "\$", "icon": null},
    {"name": "f", "Cname": "F", "number": "&", "icon": null},
    {"name": "g", "Cname": "G", "number": "*", "icon": null},
    {"name": "h", "Cname": "H", "number": "(", "icon": null},
    {"name": "j", "Cname": "J", "number": ")", "icon": null},
    {"name": "k", "Cname": "K", "number": "'", "icon": null},
    {"name": "l", "Cname": "L", "number": "\"", "icon": null},
    {
      "name": "next",
      "Cname": "next",
      "number": "next",
      "icon": Icons.backspace_rounded,
      "action": "next"
    },
  ];
  List<Map<String, dynamic>> keyBoardList3 = [
    {
      "name": "caps",
      "Cname": "caps",
      "number": "caps",
      "icon": Icons.upload,
      "action": "caps"
    },
    {"name": "z", "Cname": "Z", "number": "%", "icon": null},
    {"name": "x", "Cname": "X", "number": "-", "icon": null},
    {"name": "c", "Cname": "C", "number": "+", "icon": null},
    {"name": "v", "Cname": "V", "number": "=", "icon": null},
    {"name": "b", "Cname": "B", "number": "/", "icon": null},
    {"name": "n", "Cname": "N", "number": ";", "icon": null},
    {"name": "m", "Cname": "M", "number": ":", "icon": null},
    {"name": ",", "Cname": "!", "number": "!", "icon": null},
    {"name": ".", "Cname": "?", "number": "?", "icon": null},
    {
      "name": "delete",
      "Cname": "delete",
      "number": "delete",
      "icon": Icons.settings_backup_restore_outlined,
      "action": "delete"
    },
  ];

  bool isCapsOn = false;
  bool isNumberOn = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CommonImageButton(
              flutterTts: widget.flutterTts,
              text: "back",
              isImageShow: true,
              vertical: 10,
              buttonIcon: Icons.arrow_back,
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        suggestionList.length, // Number of columns in the grid
                    childAspectRatio: 8 / 3, // Aspect ratio of the grid items
                    mainAxisSpacing: 11,
                    crossAxisSpacing: 11),
                shrinkWrap: true,
                itemCount: suggestionList.length,
                itemBuilder: (context, index) {
                  var data = suggestionList[index];
                  return CommonImageButton(
                    flutterTts: widget.flutterTts,
                    text: data,
                    onTap: () {
                      widget.onAdd(data, null);
                    },
                    backgroundColor: AppColorConstants.keyBoardBackColor,
                    borderColor: AppColorConstants.keyBoardBackColor,
                    textStyle: const TextStyle(
                        color: AppColorConstants.keyBoardTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                    buttonIconColor: AppColorConstants.keyBoardTextColor,
                    buttonName: data,
                  );
                },
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            CommonImageButton(
              text: "forward",
              isImageShow: true,
              vertical: 10,
              buttonIcon: Icons.arrow_forward,
            )
          ],
        ),
        const SizedBox(
          height: 7,
        ),
        Container(
          color: AppColorConstants.white,
          child: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        keyBoardList1.length, // Number of columns in the grid
                    childAspectRatio: 9 / 8, // Aspect ratio of the grid items
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5),
                shrinkWrap: true,
                itemCount: keyBoardList1.length,
                itemBuilder: (context, index) {
                  var data = keyBoardList1[index];
                  return CommonImageButton(
                    flutterTts: widget.flutterTts,
                    text: isNumberOn
                        ? data["number"]
                        : isCapsOn
                            ? data["Cname"]
                            : data["name"],
                    onTap: data["action"] != null
                        ? () {
                            widget.deleteLast();
                          }
                        : () {
                            widget.onTextValue(isNumberOn
                                ? data["number"]
                                : isCapsOn
                                    ? data["Cname"]
                                    : data["name"]);
                          },
                    isImageShow: data["action"] != null ? true : false,
                    isTextShow: data["action"] != null ? false : true,
                    backgroundColor: AppColorConstants.keyBoardBackColor,
                    borderColor: AppColorConstants.keyBoardBackColor,
                    textStyle: const TextStyle(
                        color: AppColorConstants.keyBoardTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                    buttonIconColor: AppColorConstants.keyBoardTextColor,
                    buttonName: isNumberOn
                        ? data["number"]
                        : isCapsOn
                            ? data["Cname"]
                            : data["name"],
                    buttonIcon: data["icon"],
                  );
                },
              ),
              const SizedBox(
                height: 5,
              ),
              GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        keyBoardList2.length, // Number of columns in the grid
                    childAspectRatio: 9 / 8, // Aspect ratio of the grid items
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5),
                shrinkWrap: true,
                itemCount: keyBoardList2.length,
                itemBuilder: (context, index) {
                  var data = keyBoardList2[index];
                  return CommonImageButton(
                    text: isNumberOn
                        ? data["number"]
                        : isCapsOn
                            ? data["Cname"]
                            : data["name"],
                    flutterTts: widget.flutterTts,
                    onTap: data["action"] != null
                        ? () {
                            widget.deleteLast();
                          }
                        : () {
                            widget.onTextValue(isNumberOn
                                ? data["number"]
                                : isCapsOn
                                    ? data["Cname"]
                                    : data["name"]);
                          },
                    isImageShow: data["action"] != null ? true : false,
                    isTextShow: data["action"] != null ? false : true,
                    backgroundColor: AppColorConstants.keyBoardBackColor,
                    borderColor: AppColorConstants.keyBoardBackColor,
                    textStyle: const TextStyle(
                        color: AppColorConstants.keyBoardTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                    buttonIconColor: AppColorConstants.keyBoardTextColor,
                    buttonName: isNumberOn
                        ? data["number"]
                        : isCapsOn
                            ? data["Cname"]
                            : data["name"],
                    buttonIcon: data["icon"],
                  );
                },
              ),
              const SizedBox(
                height: 5,
              ),
              GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        keyBoardList3.length, // Number of columns in the grid
                    childAspectRatio: 9 / 8, // Aspect ratio of the grid items
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5),
                shrinkWrap: true,
                itemCount: keyBoardList3.length,
                itemBuilder: (context, index) {
                  var data = keyBoardList3[index];
                  return CommonImageButton(
                    onTap: data["action"] != null
                        ? () {
                            if (data["action"] != null) {
                              if (data["action"] == "caps") {
                                isCapsOn = !isCapsOn;
                                speakToText(isCapsOn ? "Capital" : "Small",
                                    widget.flutterTts);
                              }
                            } else {
                              widget.deleteLast();
                            }
                            setState(() {});
                          }
                        : () {
                            widget.onTextValue(isNumberOn
                                ? data["number"]
                                : isCapsOn
                                    ? data["Cname"]
                                    : data["name"]);
                          },
                    flutterTts: widget.flutterTts,
                    text: isNumberOn
                        ? data["number"]
                        : isCapsOn
                            ? data["Cname"]
                            : data["name"],
                    isImageShow: data["action"] != null ? true : false,
                    isTextShow: data["action"] != null ? false : true,
                    backgroundColor: AppColorConstants.keyBoardBackColor,
                    borderColor: AppColorConstants.keyBoardBackColor,
                    textStyle: const TextStyle(
                        color: AppColorConstants.keyBoardTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                    buttonIconColor: AppColorConstants.keyBoardTextColor,
                    buttonName: isNumberOn
                        ? data["number"]
                        : isCapsOn
                            ? data["Cname"]
                            : data["name"],
                    buttonIcon: data["icon"],
                  );
                },
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 5,
                  ),
                  CommonImageButton(
                    width: 110,
                    height: 60,
                    backgroundColor: AppColorConstants.keyBoardBackColor,
                    borderColor: AppColorConstants.keyBoardBackColor,
                    isHorizontal: true,
                    buttonIcon: Icons.folder_copy,
                    buttonIconColor: AppColorConstants.keyBoardTextColor,
                    textStyle: const TextStyle(
                        color: AppColorConstants.keyBoardTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 10),
                    buttonName: "Favorites",
                    onTap: () {
                      speakToText("Favorites", widget.flutterTts);
                    },
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  CommonImageButton(
                    width: 80,
                    height: 60,
                    backgroundColor: AppColorConstants.keyBoardBackColor,
                    borderColor: AppColorConstants.keyBoardBackColor,
                    isHorizontal: true,
                    buttonIcon: Icons.save,
                    buttonIconColor: AppColorConstants.keyBoardTextColor,
                    textStyle: const TextStyle(
                        color: AppColorConstants.keyBoardTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 10),
                    buttonName: "Save",
                    onTap: () {
                      speakToText("Save", widget.flutterTts);
                    },
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: CommonImageButton(
                      height: 60,
                      vertical: 10,
                      backgroundColor: AppColorConstants.keyBoardBackColor,
                      borderColor: AppColorConstants.keyBoardBackColor,
                      isHorizontal: true,
                      textStyle: const TextStyle(
                          color: AppColorConstants.keyBoardTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 10),
                      buttonName: "",
                      onTap: () {
                        widget.onSpace();
                        speakToText("Space", widget.flutterTts);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  CommonImageButton(
                    height: 60,
                    width: 80,
                    backgroundColor: AppColorConstants.keyBoardBackColor,
                    borderColor: AppColorConstants.keyBoardBackColor,
                    isHorizontal: true,
                    textStyle: const TextStyle(
                        color: AppColorConstants.keyBoardTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    buttonName: isNumberOn ? "ABC" : "?123",
                    onTap: () {
                      speakToText(isNumberOn ? "Alphabet" : "Number",
                          widget.flutterTts);
                      isNumberOn = !isNumberOn;
                      setState(() {});
                    },
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  CommonImageButton(
                    height: 60,
                    width: 80,
                    backgroundColor: AppColorConstants.keyBoardBackColor,
                    borderColor: AppColorConstants.keyBoardBackColor,
                    isHorizontal: true,
                    buttonIcon: Icons.notifications_active_rounded,
                    buttonIconColor: AppColorConstants.keyBoardTextColor,
                    onTap: () {
                      speakToText("Alarm", widget.flutterTts);
                    },
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        )
      ],
    );
  }
}
