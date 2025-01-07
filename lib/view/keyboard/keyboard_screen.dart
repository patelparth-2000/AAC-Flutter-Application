import 'package:avaz_app/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../common/common_image_button.dart';
import '../../model/get_category_modal.dart';
import '../../model/search_table_model.dart';
import '../../services/data_base_service.dart';
import '../../util/app_color_constants.dart';
import '../settings/setting_model/account_setting_model.dart';
import '../settings/setting_model/audio_setting.dart';
import '../settings/setting_model/general_setting.dart';
import '../settings/setting_model/keyboard_setting.dart';
import '../settings/setting_model/picture_appearance_setting_model.dart';
import '../settings/setting_model/picture_behaviour_setting_model.dart';
import '../settings/setting_model/touch_setting.dart';
import 'favorites_screen.dart';
import 'save_screen.dart';

class KeyboardScreen extends StatefulWidget {
  const KeyboardScreen(
      {super.key,
      required this.flutterTts,
      required this.onAdd,
      required this.onTextValue,
      required this.onSpace,
      required this.deleteLast,
      this.accountSettingModel,
      this.pictureAppearanceSettingModel,
      this.pictureBehaviourSettingModel,
      this.keyboardSettingModel,
      this.audioSettingModel,
      this.generalSettingModel,
      this.touchSettingModel,
      required this.dataBaseService,
      this.isMain = true,
      this.keyboradShow,
      this.isSave = false,
      this.isFavorite = false,
      this.isSaveEnable = false,
      this.saveAllText,
      required this.suggetionSearch});
  final FlutterTts flutterTts;
  final Function(String, String?) onAdd;
  final Function(String, {bool isKeyboard}) onTextValue;
  final Function() onSpace;
  final Function() deleteLast;
  final Function()? saveAllText;
  final Function(bool, bool, bool)? keyboradShow;
  final bool isMain;
  final bool isSave;
  final bool isFavorite;
  final bool isSaveEnable;
  final DataBaseService dataBaseService;
  final AccountSettingModel? accountSettingModel;
  final PictureAppearanceSettingModel? pictureAppearanceSettingModel;
  final PictureBehaviourSettingModel? pictureBehaviourSettingModel;
  final KeyboardSettingModel? keyboardSettingModel;
  final AudioSettingModel? audioSettingModel;
  final GeneralSettingModel? generalSettingModel;
  final TouchSettingModel? touchSettingModel;
  final String suggetionSearch;

  @override
  State<KeyboardScreen> createState() => _KeyboardScreenState();
}

class _KeyboardScreenState extends State<KeyboardScreen> {
  List<String> suggestionList = ["I", "Yes", "Your", "it", "the"];
  List<Map<String, dynamic>> keyBoardList1 = [
    {
      "name": "q",
      "Cname": "Q",
      "normal": "a",
      "Cnormal": "A",
      "number": "1",
      "Ncolor": AppColorConstants.blue100,
      "icon": null
    },
    {
      "name": "w",
      "Cname": "W",
      "normal": "b",
      "Cnormal": "B",
      "number": "2",
      "icon": null
    },
    {
      "name": "e",
      "Cname": "E",
      "normal": "c",
      "Cnormal": "C",
      "number": "3",
      "color": AppColorConstants.blue100,
      "icon": null
    },
    {
      "name": "r",
      "Cname": "R",
      "normal": "d",
      "Cnormal": "D",
      "number": "4",
      "icon": null
    },
    {
      "name": "t",
      "Cname": "T",
      "normal": "e",
      "Cnormal": "E",
      "number": "5",
      "Ncolor": AppColorConstants.blue100,
      "icon": null
    },
    {
      "name": "y",
      "Cname": "Y",
      "normal": "f",
      "Cnormal": "F",
      "number": "6",
      "icon": null
    },
    {
      "name": "u",
      "Cname": "U",
      "normal": "g",
      "Cnormal": "G",
      "number": "7",
      "color": AppColorConstants.blue100,
      "icon": null
    },
    {
      "name": "i",
      "Cname": "I",
      "normal": "h",
      "Cnormal": "H",
      "number": "8",
      "color": AppColorConstants.blue100,
      "icon": null
    },
    {
      "name": "o",
      "Cname": "O",
      "normal": "i",
      "Cnormal": "I",
      "number": "9",
      "color": AppColorConstants.blue100,
      "Ncolor": AppColorConstants.blue100,
      "icon": null
    },
    {
      "name": "p",
      "Cname": "P",
      "normal": "j",
      "Cnormal": "J",
      "number": "0",
      "icon": null
    },
    // {
    //   "name": "delete",
    //   "Cname": "delete",
    //   "number": "delete",
    //   "icon": Icons.backspace_rounded,
    //   "action": "delete"
    // },
  ];
  List<Map<String, dynamic>> keyBoardList2 = [
    {
      "name": "a",
      "Cname": "A",
      "normal": "k",
      "Cnormal": "K",
      "number": "@",
      "color": AppColorConstants.blue100,
      "icon": null
    },
    {
      "name": "s",
      "Cname": "S",
      "normal": "l",
      "Cnormal": "L",
      "number": "#",
      "icon": null
    },
    {
      "name": "d",
      "Cname": "D",
      "normal": "m",
      "Cnormal": "M",
      "number": "\$",
      "icon": null
    },
    {
      "name": "f",
      "Cname": "F",
      "normal": "n",
      "Cnormal": "N",
      "number": "&",
      "icon": null
    },
    {
      "name": "g",
      "Cname": "G",
      "normal": "o",
      "Cnormal": "O",
      "number": "*",
      "Ncolor": AppColorConstants.blue100,
      "icon": null
    },
    {
      "name": "h",
      "Cname": "H",
      "normal": "p",
      "Cnormal": "P",
      "number": "(",
      "icon": null
    },
    {
      "name": "j",
      "Cname": "J",
      "normal": "q",
      "Cnormal": "Q",
      "number": ")",
      "icon": null
    },
    {
      "name": "k",
      "Cname": "K",
      "normal": "r",
      "Cnormal": "R",
      "number": "'",
      "icon": null
    },
    {
      "name": "l",
      "Cname": "L",
      "normal": "s",
      "Cnormal": "S",
      "number": "\"",
      "icon": null
    },
    // {
    //   "name": "next",
    //   "Cname": "next",
    //   "number": "next",
    //   "icon": Icons.backspace_rounded,
    //   "action": "next"
    // },
  ];
  List<Map<String, dynamic>> keyBoardList3 = [
    {
      "name": "caps",
      "Cname": "caps",
      "number": "caps",
      "icon": Icons.upload,
      "action": "caps"
    },
    {
      "name": "z",
      "Cname": "Z",
      "normal": "t",
      "Cnormal": "T",
      "number": "%",
      "icon": null
    },
    {
      "name": "x",
      "Cname": "X",
      "normal": "u",
      "Cnormal": "U",
      "number": "-",
      "Ncolor": AppColorConstants.blue100,
      "icon": null
    },
    {
      "name": "c",
      "Cname": "C",
      "normal": "v",
      "Cnormal": "V",
      "number": "+",
      "icon": null
    },
    {
      "name": "v",
      "Cname": "V",
      "normal": "w",
      "Cnormal": "W",
      "number": "=",
      "icon": null
    },
    {
      "name": "b",
      "Cname": "B",
      "normal": "x",
      "Cnormal": "X",
      "number": "/",
      "icon": null
    },
    {
      "name": "n",
      "Cname": "N",
      "normal": "y",
      "Cnormal": "Y",
      "number": ";",
      "icon": null
    },
    {
      "name": "m",
      "Cname": "M",
      "normal": "z",
      "Cnormal": "Z",
      "number": ":",
      "icon": null
    },
    {
      "name": ",",
      "Cname": "!",
      "normal": ",",
      "Cnormal": "!",
      "number": "!",
      "icon": null
    },
    {
      "name": ".",
      "Cname": "?",
      "normal": ".",
      "Cnormal": "?",
      "number": "?",
      "icon": null
    },
    // {
    //   "name": "delete",
    //   "Cname": "delete",
    //   "number": "delete",
    //   "icon": Icons.settings_backup_restore_outlined,
    //   "action": "delete"
    // },
    {
      "name": "next",
      "Cname": "next",
      "number": "next",
      "icon": Icons.backspace_rounded,
      "action": "next"
    },
  ];

  bool isCapsOn = false;
  bool isNumberOn = false;
  List<GetCategoryModal> getCategoryModalList = [];
  List<SearchTableModel> searchTable = [];
  List<SearchTableModel> filteredSearchList = [];
  List<String> keyboardSuggestionList = [];

  @override
  void initState() {
    super.initState();
    getDataFromDatabse();
  }

  void getDataFromDatabse() async {
    var categoryData = await widget.dataBaseService.getFavoritesTable();
    searchVoice(categoryData);
    setState(() {});
  }

  void searchVoice(var categoryData) async {
    if (categoryData != null && categoryData is List) {
      for (var item in categoryData) {
        if (item is Map<String, dynamic>) {
          Map<String, dynamic> modifiableItem = Map<String, dynamic>.from(item);
          GetCategoryModal getCategoryModal =
              GetCategoryModal.fromJson(modifiableItem);
          if (getCategoryModal.type == "category") {
            bool isExists = await widget.dataBaseService
                .checkIfTableExistsOrNot(
                    getCategoryModal.slug!.replaceAll("-", "_"));
            if (isExists) {
              getVoiceData(getCategoryModal);
            }
          }
        }
      }
    }
  }

  void getVoiceData(GetCategoryModal getvoicedata) async {
    var categoryData =
        await widget.dataBaseService.getTablesData(getvoicedata.slug!);
    addVoiceData(categoryData);
  }

  void addVoiceData(categoryData) async {
    if (categoryData != null && categoryData is List) {
      for (var item in categoryData) {
        if (item is Map<String, dynamic>) {
          if (item["delete_status"] != "1") {
            Map<String, dynamic> modifiableItem =
                Map<String, dynamic>.from(item);
            GetCategoryModal getCategoryModal =
                GetCategoryModal.fromJson(modifiableItem);
            searchTable.add(SearchTableModel(voice: getCategoryModal.name!));
          }
        }
      }
    }
    filteredSearchList = searchTable;
  }

  void _filterSearchList() {
    keyboardSuggestionList.clear();
    Future.delayed(const Duration(milliseconds: 50)).whenComplete(
      () {
        final query = widget.suggetionSearch.toLowerCase();
        setState(() {
          final filteredItems = searchTable
              .where((item) => item.voice.toLowerCase().startsWith(query))
              .toList();
          filteredSearchList = filteredItems
              .toSet()
              .take(5)
              .toList(); // Remove duplicates and limit to 5 items
          for (var element in filteredSearchList) {
            keyboardSuggestionList.add(element.voice);
          }
        });
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isSave) {
      return SaveScreen(
        flutterTts: widget.flutterTts,
        dataBaseService: widget.dataBaseService,
        onTextValue: widget.onTextValue,
        onSpace: widget.onSpace,
        keyboardSettingModel: widget.keyboardSettingModel,
        saveAllText: widget.saveAllText!,
        keyboradShow: widget.keyboradShow,
        touchSettingModel: widget.touchSettingModel,
      );
    }
    if (widget.isFavorite) {
      return FavoritesScreen(
        flutterTts: widget.flutterTts,
        dataBaseService: widget.dataBaseService,
        onTextValue: widget.onTextValue,
        onSpace: widget.onSpace,
        keyboardSettingModel: widget.keyboardSettingModel,
        touchSettingModel: widget.touchSettingModel,
      );
    }
    return Column(
      children: [
        SizedBox(
          height: 50,
          width: double.infinity,
          child: Row(
            children: [
              CommonImageButton(
                touchSettingModel: widget.touchSettingModel,
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
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.suggetionSearch.isNotEmpty &&
                          keyboardSuggestionList.isNotEmpty
                      ? keyboardSuggestionList.length
                      : suggestionList.length,
                  itemBuilder: (context, index) {
                    var data = widget.suggetionSearch.isNotEmpty &&
                            keyboardSuggestionList.isNotEmpty
                        ? keyboardSuggestionList[index]
                        : suggestionList[index];
                    return CommonImageButton(
                      touchSettingModel: widget.touchSettingModel,
                      width: Dimensions.screenWidth * 0.165,
                      flutterTts: widget.flutterTts,
                      text: data,
                      onTap: () {
                        if (widget.suggetionSearch.isNotEmpty) {
                          widget.onTextValue(data, isKeyboard: true);
                          Future.delayed(const Duration(milliseconds: 20))
                              .whenComplete(() {
                            widget.onSpace();
                          });
                        } else {
                          widget.onAdd(data, null);
                        }
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
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      width: 10,
                    );
                  },
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              CommonImageButton(
                touchSettingModel: widget.touchSettingModel,
                text: "forward",
                isImageShow: true,
                vertical: 10,
                buttonIcon: Icons.arrow_forward,
              )
            ],
          ),
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
                    childAspectRatio: 1.25, // Aspect ratio of the grid items
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5),
                shrinkWrap: true,
                itemCount: keyBoardList1.length,
                itemBuilder: (context, index) {
                  var data = keyBoardList1[index];
                  return CommonImageButton(
                    touchSettingModel: widget.touchSettingModel,
                    flutterTts: widget.flutterTts,
                    text: isNumberOn
                        ? data["number"]
                        : widget.keyboardSettingModel!.layout == "english_(qwe)"
                            ? isCapsOn
                                ? data["Cname"]
                                : data["name"]
                            : isCapsOn
                                ? data["Cnormal"]
                                : data["normal"],
                    onTap: data["action"] != null
                        ? () {
                            widget.deleteLast();
                          }
                        : () {
                            widget.onTextValue(
                              isNumberOn
                                  ? data["number"]
                                  : widget.keyboardSettingModel!.layout ==
                                          "english_(qwe)"
                                      ? isCapsOn
                                          ? data["Cname"]
                                          : data["name"]
                                      : isCapsOn
                                          ? data["Cnormal"]
                                          : data["normal"],
                            );
                            _filterSearchList();
                          },
                    isImageShow: data["action"] != null ? true : false,
                    isTextShow: data["action"] != null ? false : true,
                    iscolorChange: false,
                    backgroundColor: widget
                            .keyboardSettingModel!.highlightVowels!
                        ? widget.keyboardSettingModel?.layout == "english_(qwe)"
                            ? (data["color"] ??
                                AppColorConstants.keyBoardBackColor)
                            : (data["Ncolor"] ??
                                AppColorConstants.keyBoardBackColor)
                        : AppColorConstants.keyBoardBackColor,
                    borderColor: widget.keyboardSettingModel!.highlightVowels!
                        ? widget.keyboardSettingModel?.layout == "english_(qwe)"
                            ? (data["color"] ??
                                AppColorConstants.keyBoardBackColor)
                            : (data["Ncolor"] ??
                                AppColorConstants.keyBoardBackColor)
                        : AppColorConstants.keyBoardBackColor,
                    textStyle: const TextStyle(
                        color: AppColorConstants.keyBoardTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                    buttonIconColor: AppColorConstants.keyBoardTextColor,
                    buttonName: isNumberOn
                        ? data["number"]
                        : widget.keyboardSettingModel!.layout == "english_(qwe)"
                            ? isCapsOn
                                ? data["Cname"]
                                : data["name"]
                            : isCapsOn
                                ? data["Cnormal"]
                                : data["normal"],
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
                    childAspectRatio: 1.25, // Aspect ratio of the grid items
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5),
                shrinkWrap: true,
                itemCount: keyBoardList2.length,
                itemBuilder: (context, index) {
                  var data = keyBoardList2[index];
                  return CommonImageButton(
                    touchSettingModel: widget.touchSettingModel,
                    text: isNumberOn
                        ? data["number"]
                        : widget.keyboardSettingModel!.layout == "english_(qwe)"
                            ? isCapsOn
                                ? data["Cname"]
                                : data["name"]
                            : isCapsOn
                                ? data["Cnormal"]
                                : data["normal"],
                    flutterTts: widget.flutterTts,
                    onTap: data["action"] != null
                        ? () {
                            widget.deleteLast();
                          }
                        : () {
                            widget.onTextValue(
                              isNumberOn
                                  ? data["number"]
                                  : widget.keyboardSettingModel!.layout ==
                                          "english_(qwe)"
                                      ? isCapsOn
                                          ? data["Cname"]
                                          : data["name"]
                                      : isCapsOn
                                          ? data["Cnormal"]
                                          : data["normal"],
                            );
                            _filterSearchList();
                          },
                    isImageShow: data["action"] != null ? true : false,
                    isTextShow: data["action"] != null ? false : true,
                    iscolorChange: false,
                    backgroundColor: widget
                            .keyboardSettingModel!.highlightVowels!
                        ? widget.keyboardSettingModel?.layout == "english_(qwe)"
                            ? (data["color"] ??
                                AppColorConstants.keyBoardBackColor)
                            : (data["Ncolor"] ??
                                AppColorConstants.keyBoardBackColor)
                        : AppColorConstants.keyBoardBackColor,
                    borderColor: widget.keyboardSettingModel!.highlightVowels!
                        ? widget.keyboardSettingModel?.layout == "english_(qwe)"
                            ? (data["color"] ??
                                AppColorConstants.keyBoardBackColor)
                            : (data["Ncolor"] ??
                                AppColorConstants.keyBoardBackColor)
                        : AppColorConstants.keyBoardBackColor,
                    textStyle: const TextStyle(
                        color: AppColorConstants.keyBoardTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                    buttonIconColor: AppColorConstants.keyBoardTextColor,
                    buttonName: isNumberOn
                        ? data["number"]
                        : widget.keyboardSettingModel!.layout == "english_(qwe)"
                            ? isCapsOn
                                ? data["Cname"]
                                : data["name"]
                            : isCapsOn
                                ? data["Cnormal"]
                                : data["normal"],
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
                    childAspectRatio: 1.1, // Aspect ratio of the grid items
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5),
                shrinkWrap: true,
                itemCount: keyBoardList3.length,
                itemBuilder: (context, index) {
                  var data = keyBoardList3[index];
                  return CommonImageButton(
                    touchSettingModel: widget.touchSettingModel,
                    onTap: data["action"] != null
                        ? () {
                            if (data["action"] != null) {
                              if (data["action"] == "caps") {
                                isCapsOn = !isCapsOn;
                                // speakToText(isCapsOn ? "Capital" : "Small",
                                //     widget.flutterTts);
                              } else {
                                widget.deleteLast();
                              }
                            }
                            setState(() {});
                          }
                        : () {
                            widget.onTextValue(
                              isNumberOn
                                  ? data["number"]
                                  : widget.keyboardSettingModel!.layout ==
                                          "english_(qwe)"
                                      ? isCapsOn
                                          ? data["Cname"]
                                          : data["name"]
                                      : isCapsOn
                                          ? data["Cnormal"]
                                          : data["normal"],
                            );
                            _filterSearchList();
                          },
                    flutterTts: widget.flutterTts,
                    text: data["action"] != null
                        ? null
                        : isNumberOn
                            ? data["number"]
                            : widget.keyboardSettingModel!.layout ==
                                    "english_(qwe)"
                                ? isCapsOn
                                    ? data["Cname"]
                                    : data["name"]
                                : isCapsOn
                                    ? data["Cnormal"]
                                    : data["normal"],
                    isImageShow: data["action"] != null ? true : false,
                    isTextShow: data["action"] != null ? false : true,
                    iscolorChange: false,
                    backgroundColor: widget
                            .keyboardSettingModel!.highlightVowels!
                        ? widget.keyboardSettingModel?.layout == "english_(qwe)"
                            ? (data["color"] ??
                                AppColorConstants.keyBoardBackColor)
                            : (data["Ncolor"] ??
                                AppColorConstants.keyBoardBackColor)
                        : AppColorConstants.keyBoardBackColor,
                    borderColor: widget.keyboardSettingModel!.highlightVowels!
                        ? widget.keyboardSettingModel?.layout == "english_(qwe)"
                            ? (data["color"] ??
                                AppColorConstants.keyBoardBackColor)
                            : (data["Ncolor"] ??
                                AppColorConstants.keyBoardBackColor)
                        : AppColorConstants.keyBoardBackColor,
                    textStyle: const TextStyle(
                        color: AppColorConstants.keyBoardTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                    buttonIconColor: AppColorConstants.keyBoardTextColor,
                    buttonName: isNumberOn
                        ? data["number"]
                        : widget.keyboardSettingModel!.layout == "english_(qwe)"
                            ? isCapsOn
                                ? data["Cname"]
                                : data["name"]
                            : isCapsOn
                                ? data["Cnormal"]
                                : data["normal"],
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
                  if (widget.isMain)
                    CommonImageButton(
                      width: 110,
                      height: 60,
                      touchSettingModel: widget.touchSettingModel,
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
                      text: "Favorites",
                      flutterTts: widget.flutterTts,
                      onTap: () {
                        if (widget.keyboradShow != null) {
                          widget.keyboradShow!(true, true, false);
                        }
                        setState(() {});
                      },
                    ),
                  const SizedBox(
                    width: 5,
                  ),
                  if (!widget.isMain)
                    const SizedBox(
                      width: 190,
                    ),
                  if (widget.isMain)
                    CommonImageButton(
                      width: 80,
                      height: 60,
                      touchSettingModel: widget.touchSettingModel,
                      backgroundColor: AppColorConstants.keyBoardBackColor,
                      borderColor: AppColorConstants.keyBoardBackColor,
                      isHorizontal: true,
                      buttonIcon: Icons.save,
                      buttonIconColor: widget.isSaveEnable
                          ? AppColorConstants.keyBoardTextColor
                          : AppColorConstants.icons,
                      textStyle: TextStyle(
                          color: widget.isSaveEnable
                              ? AppColorConstants.keyBoardTextColor
                              : AppColorConstants.icons,
                          fontWeight: FontWeight.bold,
                          fontSize: 10),
                      buttonName: "Save",
                      text: "Save",
                      flutterTts: widget.flutterTts,
                      onTap: () {
                        if (widget.keyboradShow != null &&
                            widget.isSaveEnable) {
                          widget.keyboradShow!(true, false, true);
                        }
                        setState(() {});
                      },
                    ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: CommonImageButton(
                      height: 60,
                      vertical: 10,
                      touchSettingModel: widget.touchSettingModel,
                      backgroundColor: AppColorConstants.keyBoardBackColor,
                      borderColor: AppColorConstants.keyBoardBackColor,
                      isHorizontal: true,
                      textStyle: const TextStyle(
                          color: AppColorConstants.keyBoardTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 10),
                      buttonName: "",
                      text: "Space",
                      flutterTts: widget.flutterTts,
                      onTap: () {
                        widget.onSpace();
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  CommonImageButton(
                    height: 60,
                    width: 80,
                    touchSettingModel: widget.touchSettingModel,
                    backgroundColor: AppColorConstants.keyBoardBackColor,
                    borderColor: AppColorConstants.keyBoardBackColor,
                    isHorizontal: true,
                    textStyle: const TextStyle(
                        color: AppColorConstants.keyBoardTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    buttonName: isNumberOn ? "ABC" : "?123",
                    text: isNumberOn ? "Alphabet" : "Number",
                    flutterTts: widget.flutterTts,
                    onTap: () {
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
                    touchSettingModel: widget.touchSettingModel,
                    backgroundColor: AppColorConstants.keyBoardBackColor,
                    borderColor: AppColorConstants.keyBoardBackColor,
                    isHorizontal: true,
                    buttonIcon: Icons.notifications_active_rounded,
                    buttonIconColor: AppColorConstants.keyBoardTextColor,
                    text: "Alarm",
                    flutterTts: widget.flutterTts,
                    onTap: () {},
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
