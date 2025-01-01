// ignore_for_file: file_names

import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:avaz_app/common/common.dart';
import 'package:avaz_app/services/data_base_service.dart';
import 'package:avaz_app/util/dimensions.dart';
import 'package:avaz_app/view/test/test2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

import '../../common/common_image_button.dart';
import '../../model/get_category_modal.dart';
import '../../model/search_table_model.dart';
import '../../services/bulk_api_data.dart';
import '../../util/app_color_constants.dart';
import '../drawer/drawer_screen.dart';
import '../grid_data/grid_date_screen.dart';
import '../keyboard/keyboard_screen.dart';
import '../settings/setting_model/account_setting_model.dart';
import '../settings/setting_model/audio_setting.dart';
import '../settings/setting_model/general_setting.dart';
import '../settings/setting_model/keyboard_setting.dart';
import '../settings/setting_model/picture_appearance_setting_model.dart';
import '../settings/setting_model/picture_behaviour_setting_model.dart';
import '../settings/setting_model/touch_setting.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AudioPlayer player = AudioPlayer();
  final GlobalKey<NavigatorState> _dashboradNavigatorKey =
      GlobalKey<NavigatorState>();
  final FlutterTts flutterTts = FlutterTts();
  final dbService = DataBaseService.instance;
  bool _canExit = false;
  bool isKeyBoardShow = false;
  bool isSearchOpen = false;
  final TextEditingController _mainTextFieldController =
      TextEditingController();
  final List<Map<String, dynamic>> _widgetList = [];
  late ScrollController _scrollController;
  List<GetCategoryModal> getCategoryModalList = [];
  List<SearchTableModel> searchTable = [];
  String firstTableName = "category_table";
  List<String> tableNames = [];
  AccountSettingModel? accountSettingModel = AccountSettingModel();
  PictureAppearanceSettingModel? pictureAppearanceSettingModel =
      PictureAppearanceSettingModel();
  PictureBehaviourSettingModel? pictureBehaviourSettingModel =
      PictureBehaviourSettingModel();
  KeyboardSettingModel? keyboardSettingModel = KeyboardSettingModel();
  AudioSettingModel? audioSettingModel = AudioSettingModel();
  GeneralSettingModel? generalSettingModel = GeneralSettingModel();
  TouchSettingModel? touchSettingModel = TouchSettingModel();
  bool isLoading = false;
  List<String> sidebarShow = [];

  void getSettingData() async {
    setState(() {
      isLoading = true;
    });
    sidebarShow.clear();
    accountSettingModel = await dbService.accountSettingFetch();
    pictureAppearanceSettingModel =
        await dbService.pictureAppearanceSettingFetch();
    pictureBehaviourSettingModel =
        await dbService.pictureBehaviourSettingFetch();
    keyboardSettingModel = await dbService.keyboardSettingFetch();
    audioSettingModel = await dbService.audioSettingFetch();
    generalSettingModel = await dbService.generalSettingFetch();
    touchSettingModel = await dbService.touchSettingFetch();
    sidebarShow =
        pictureAppearanceSettingModel!.sideNavigationBarButton!.split(",");
    setState(() {
      isLoading = false;
    });
  }

  void refreshSettingData() async {
    sidebarShow.clear();
    accountSettingModel = await dbService.accountSettingFetch();
    pictureAppearanceSettingModel =
        await dbService.pictureAppearanceSettingFetch();
    pictureBehaviourSettingModel =
        await dbService.pictureBehaviourSettingFetch();
    keyboardSettingModel = await dbService.keyboardSettingFetch();
    audioSettingModel = await dbService.audioSettingFetch();
    generalSettingModel = await dbService.generalSettingFetch();
    touchSettingModel = await dbService.touchSettingFetch();
    sidebarShow =
        pictureAppearanceSettingModel!.sideNavigationBarButton!.split(",");
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    BulkApiData.getCategory(context);
    directoryPath();
    getDataFromDatabse();
    getSettingData();
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
    player.dispose();
    super.dispose();
  }

  void getDataFromDatabse() async {
    tableNames.clear();
    tableNames.add(firstTableName);
    var categoryData = await dbService.getCategoryTable();
    adddata(categoryData);
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
            bool isExists = await dbService.checkIfTableExistsOrNot(
                getCategoryModal.slug!.replaceAll("-", "_"));
            if (isExists) {
              await searchCategoryTable(
                  getCategoryModal.name!, getCategoryModal.slug!);
            }
          } else if (getCategoryModal.type == "sub_categories") {
            bool isExists = await dbService.checkIfTableExistsOrNot(
                getCategoryModal.slug!.replaceAll("-", "_"));
            if (isExists) {
              await searchCategoryTable(
                  getCategoryModal.name!, getCategoryModal.slug!);
            }
          } else {
            searchTable.add(SearchTableModel(voice: getCategoryModal.name!));
          }
        }
      }
    }
  }

  Future<void> searchCategoryTable(String name, String slug,
      {String? subName, String? subSlug}) async {
    // ignore: prefer_typing_uninitialized_variables
    var categoryTableData;
    if (subName != null && subSlug != null) {
      categoryTableData =
          await dbService.getTablesData(subSlug.replaceAll("-", "_").trim());
    } else {
      categoryTableData =
          await dbService.getTablesData(slug.replaceAll("-", "_").trim());
    }
    if (categoryTableData != null && categoryTableData is List) {
      for (var item in categoryTableData) {
        if (item is Map<String, dynamic>) {
          Map<String, dynamic> modifiableItem = Map<String, dynamic>.from(item);
          GetCategoryModal getSubCategoryModal =
              GetCategoryModal.fromJson(modifiableItem);
          if (getSubCategoryModal.type == "sub_categories") {
            bool isExists = await dbService.checkIfTableExistsOrNot(
                getSubCategoryModal.slug!.replaceAll("-", "_"));
            if (isExists) {
              await searchCategoryTable(name, slug,
                  subName: getSubCategoryModal.name,
                  subSlug: getSubCategoryModal.slug);
            }
          } else {
            if (subName != null && subSlug != null) {
              searchTable.add(SearchTableModel(
                  voice: getSubCategoryModal.name!,
                  category: name,
                  categorySlug: slug,
                  subCategory: subName,
                  subCategorySlug: subSlug));
            } else {
              searchTable.add(SearchTableModel(
                  voice: getSubCategoryModal.name!,
                  category: name,
                  categorySlug: slug));
            }
          }
        }
      }
    }
  }

  void changeTablesBaseSearch(SearchTableModel searchTable) async {
    tableNames.clear();
    tableNames.add(firstTableName);
    if (searchTable.categorySlug != null) {
      tableNames.add(searchTable.categorySlug!);
    }
    if (searchTable.subCategorySlug != null) {
      tableNames.add(searchTable.subCategorySlug!);
    }

    bool isExists = await dbService.checkIfTableExistsOrNot(tableNames.last);
    if (isExists) {
      var categoryData = await dbService.getTablesData(tableNames.last);
      adddata(categoryData);
    }
    setState(() {});
  }

  void changeTables(String slug) async {
    for (var datalist in getCategoryModalList) {
      if (datalist.type == "category") {
        if (slug == datalist.slug) {
          hexString = datalist.color;
        }
      }
    }
    bool isExists =
        await dbService.checkIfTableExistsOrNot(slug.replaceAll("-", "_"));
    if (isExists) {
      tableNames.add(slug.replaceAll("-", "_"));
      var categoryData = await dbService.getTablesData(tableNames.last);
      adddata(categoryData);
    }
    setState(() {});
  }

  void reversTables() async {
    if (tableNames.length > 1) {
      tableNames.removeLast();
      var categoryData = await dbService.getTablesData(tableNames.last);
      if (tableNames.length == 1) {
        hexString = null;
      }
      adddata(categoryData);
    }
    setState(() {});
  }

  void adddata(categoryData) async {
    bool imageExists = false;
    getCategoryModalList.clear();
    if (categoryData != null && categoryData is List) {
      for (var item in categoryData) {
        if (item is Map<String, dynamic>) {
          Map<String, dynamic> modifiableItem = Map<String, dynamic>.from(item);
          imageExists = await _checkImageExists(modifiableItem);
          modifiableItem["imagePath"] = imagePath;
          if (!imageExists) {
            modifiableItem["image"] = null;
          }
          getCategoryModalList.add(GetCategoryModal.fromJson(modifiableItem));
        }
      }
    }
    sortCategoryModalList();
  }

  void refreshGirdData() async {
    if (tableNames.isNotEmpty) {
      var categoryData = await dbService.getTablesData(tableNames.last);
      adddata(categoryData);
    }
    setState(() {});
  }

  String imagePath = "";

  Future<void> directoryPath() async {
    final dbService = DataBaseService.instance;
    imagePath = await dbService.directoryPath();
    setState(() {});
  }

  bool _imageExists = false;

  Future<bool> _checkImageExists(Map<String, dynamic> getCategoryModal) async {
    if (getCategoryModal["image"] != null &&
        getCategoryModal["image"] != "null") {
      String fullPath = "$imagePath${getCategoryModal["image"]}";
      File file = File(fullPath);
      _imageExists = await file.exists();
    } else {
      _imageExists = false;
    }
    setState(() {});
    return _imageExists;
  }

  Future<void> playAudio(String audioPath) async {
    try {
      await stopAudio();
      // Play the new audio if the path is not null
      await player.play(DeviceFileSource(audioPath));
    } catch (e) {
      // ignore: avoid_print
      print("Error playing audio: $e");
    }
  }

  Future<void> stopAudio() async {
    if (player.state == PlayerState.playing) {
      await player.stop();
    }
  }

  String? hexString;

  Color hexToBordorColor(String? type) {
    Color color = type == "voice"
        ? AppColorConstants.keyBoardBackColor
        : type == "sub_categories"
            ? AppColorConstants.keyBoardBackColorPink
            : AppColorConstants.keyBoardBackColorGreen;
    if (hexString == null) {
      return color;
    }
    final buffer = StringBuffer();
    if (hexString!.length == 6 || hexString!.length == 7) buffer.write('ff');
    buffer.write(hexString!.replaceFirst('#', ''));
    color = Color(int.parse(buffer.toString(), radix: 16));
    return color;
  }

  void sortCategoryModalList() {
    getCategoryModalList.sort((a, b) {
      const typeOrder = {
        'category': 0,
        'sub_categories': 1,
        'voice': 2,
      };
      return (typeOrder[a.type] ?? 3).compareTo(typeOrder[b.type] ?? 3);
    });
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
        key: _scaffoldKey,
        endDrawer: Drawer(
          backgroundColor: Colors.transparent,
          shape: const BeveledRectangleBorder(),
          width: Dimensions.screenWidth * 0.6,
          child: DrawerScreen(
            isSearchOpen: isSearchOpen,
            isKeyBoardShow: !isKeyBoardShow,
            flutterTts: flutterTts,
            scaffoldKey: _scaffoldKey,
            refreshSettingData: refreshSettingData,
            refreshGirdData: refreshGirdData,
            dashboradNavigatorKey: _dashboradNavigatorKey,
            searchChangeTable: changeTablesBaseSearch,
            searchList: searchTable,
          ),
        ),
        backgroundColor: AppColorConstants.topRowBackground,
        body: isLoading
            ? const Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: AppColorConstants.imageTextButtonColor,
                      semanticsLabel: 'Circular progress indicator',
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Loading....",
                        style: TextStyle(
                            color: AppColorConstants.buttonColorBlue2,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            : Row(
                children: [
                  Expanded(
                    child: Navigator(
                      key: _dashboradNavigatorKey,
                      onGenerateRoute: (settings) {
                        return MaterialPageRoute(
                          builder: (_) => Column(
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
                                    if (pictureAppearanceSettingModel!
                                        .massageBox!)
                                      CommonImageButton(
                                        stopAudio: stopAudio,
                                        isImageShow: true,
                                        isTextShow: true,
                                        vertical: 0,
                                        height: 50,
                                        flutterTts: flutterTts,
                                        text: !isKeyBoardShow
                                            ? "Pictures"
                                            : "Keyboard",
                                        onTap: () {
                                          isKeyBoardShow = !isKeyBoardShow;
                                          setState(() {});
                                        },
                                        horizontal: 2,
                                        width: 75,
                                        buttonName: isKeyBoardShow
                                            ? "Pictures"
                                            : "Keyboard",
                                        buttonIcon: isKeyBoardShow
                                            ? Icons.photo
                                            : Icons.keyboard_alt,
                                      ),
                                    if (pictureAppearanceSettingModel!
                                        .massageBox!)
                                      const SizedBox(
                                        width: 10,
                                      ),
                                    if (pictureAppearanceSettingModel!
                                        .massageBox!)
                                      Expanded(
                                        child: Container(
                                          height: 50,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 0, vertical: 5),
                                          decoration: BoxDecoration(
                                              color: AppColorConstants.white,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: SizedBox(
                                                  height: 50,
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    controller:
                                                        _scrollController,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount:
                                                        _widgetList.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Center(
                                                          child:
                                                              _widgetList[index]
                                                                  ["widget"]);
                                                    },
                                                  ),
                                                ),
                                              ),
                                              if (_widgetList.isNotEmpty)
                                                for (int i = 0; i < 4; i++)
                                                  Row(
                                                    children: [
                                                      CommonImageButton(
                                                        stopAudio: stopAudio,
                                                        isImageShow: true,
                                                        isTextShow: true,
                                                        vertical: 0,
                                                        horizontal: 0,
                                                        width: 45,
                                                        height: 45,
                                                        isSpeak: textFieldButtonNameList[
                                                                            i]
                                                                        ["name"]
                                                                    .toString()
                                                                    .toLowerCase() ==
                                                                "speak"
                                                            ? false
                                                            : true,
                                                        backgroundColor:
                                                            AppColorConstants
                                                                .white,
                                                        buttonIconColor:
                                                            AppColorConstants
                                                                .imageTextButtonColor,
                                                        buttonIcon:
                                                            textFieldButtonNameList[
                                                                i]["icon"],
                                                        imageSize: 25,
                                                        buttonName:
                                                            textFieldButtonNameList[
                                                                i]["name"],
                                                        textStyle: const TextStyle(
                                                            color: AppColorConstants
                                                                .imageTextButtonColor,
                                                            fontSize: 10),
                                                        onTap: () {
                                                          onTextfieldButton(i);
                                                        },
                                                      ),
                                                      SizedBox(
                                                        width: Dimensions
                                                                .screenWidth *
                                                            0.004,
                                                      ),
                                                    ],
                                                  ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    if (isKeyBoardShow ||
                                        (pictureAppearanceSettingModel!
                                                .sideNavigationBarPosition! ==
                                            "left") ||
                                        !pictureAppearanceSettingModel!
                                            .sideNavigationBar!)
                                      if (pictureAppearanceSettingModel!
                                          .massageBox!)
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: CommonImageButton(
                                            stopAudio: stopAudio,
                                            isImageShow: true,
                                            isTextShow: true,
                                            vertical: 0,
                                            height: 50,
                                            width: 75,
                                            text: "Menu",
                                            flutterTts: flutterTts,
                                            buttonIcon: Icons.menu,
                                            buttonName: "Menu",
                                            onTap: () {
                                              isSearchOpen = false;
                                              setState(() {});
                                              _scaffoldKey.currentState
                                                  ?.openEndDrawer();
                                            },
                                          ),
                                        ),
                                    if (!pictureAppearanceSettingModel!
                                            .massageBox! &&
                                        !pictureAppearanceSettingModel!
                                            .sideNavigationBar!)
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: CommonImageButton(
                                                stopAudio: stopAudio,
                                                isImageShow: true,
                                                isTextShow: true,
                                                vertical: 0,
                                                height: 30,
                                                width: 75,
                                                imageSize: 10,
                                                buttonIcon: Icons.menu,
                                                buttonName: "Menu",
                                                flutterTts: flutterTts,
                                                text: "Menu",
                                                fontSize: 10,
                                                onTap: () {
                                                  isSearchOpen = false;
                                                  setState(() {});
                                                  _scaffoldKey.currentState
                                                      ?.openEndDrawer();
                                                },
                                              ),
                                            ),
                                          ],
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
                                    if (!isKeyBoardShow &&
                                        (pictureAppearanceSettingModel!
                                                .sideNavigationBarPosition! ==
                                            "left") &&
                                        pictureAppearanceSettingModel!
                                            .sideNavigationBar!)
                                      sideBar(),
                                    Expanded(
                                      child: isKeyBoardShow
                                          ? KeyboardScreen(
                                              flutterTts: flutterTts,
                                              onAdd: _addNewWidget,
                                              onSpace: onSpace,
                                              deleteLast: removeLastCharacter,
                                              onTextValue: addTextFieldValue,
                                              accountSettingModel:
                                                  accountSettingModel,
                                              audioSettingModel:
                                                  audioSettingModel,
                                              generalSettingModel:
                                                  generalSettingModel,
                                              keyboardSettingModel:
                                                  keyboardSettingModel,
                                              pictureAppearanceSettingModel:
                                                  pictureAppearanceSettingModel,
                                              pictureBehaviourSettingModel:
                                                  pictureBehaviourSettingModel,
                                              touchSettingModel:
                                                  touchSettingModel,
                                            )
                                          : GridDateScreen(
                                              hexToBordorColor:
                                                  hexToBordorColor,
                                              stopAudio: stopAudio,
                                              flutterTts: flutterTts,
                                              getCategoryModalList:
                                                  getCategoryModalList,
                                              playAudio: playAudio,
                                              onAdd: _addNewWidget,
                                              changeTable: changeTables,
                                              accountSettingModel:
                                                  accountSettingModel,
                                              audioSettingModel:
                                                  audioSettingModel,
                                              generalSettingModel:
                                                  generalSettingModel,
                                              keyboardSettingModel:
                                                  keyboardSettingModel,
                                              pictureAppearanceSettingModel:
                                                  pictureAppearanceSettingModel,
                                              pictureBehaviourSettingModel:
                                                  pictureBehaviourSettingModel,
                                              touchSettingModel:
                                                  touchSettingModel,
                                            ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  if (!isKeyBoardShow &&
                      (pictureAppearanceSettingModel!
                              .sideNavigationBarPosition! ==
                          "right") &&
                      pictureAppearanceSettingModel!.sideNavigationBar!)
                    sideBar()
                ],
              ),
      ),
    );
  }

  Widget sideBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      color: AppColorConstants.topRowBackground,
      child: Column(
        children: [
          if (pictureAppearanceSettingModel!.sideNavigationBarPosition! ==
                  "right" ||
              !pictureAppearanceSettingModel!.massageBox!)
            CommonImageButton(
              stopAudio: stopAudio,
              isImageShow: true,
              isTextShow: true,
              vertical: 0,
              height: 50,
              width: 75,
              flutterTts: flutterTts,
              text: "Menu",
              buttonIcon: Icons.menu,
              buttonName: "Menu",
              onTap: () {
                isSearchOpen = false;
                setState(() {});
                _scaffoldKey.currentState?.openEndDrawer();
              },
            ),
          if (pictureAppearanceSettingModel!.sideNavigationBarPosition! ==
                  "right" ||
              !pictureAppearanceSettingModel!.massageBox!)
            const SizedBox(
              height: 10,
            ),
          for (int i = 0; i < sideButtonNameList.length; i++)
            for (int j = 0; j < sidebarShow.length; j++)
              if (sidebarShow[j] == sideButtonNameList[i]["slug"])
                Expanded(
                  child: Column(
                    children: [
                      CommonImageButton(
                        stopAudio: stopAudio,
                        isImageShow: true,
                        isTextShow: true,
                        vertical: 0,
                        height:
                            Dimensions.screenHeight * 0.8 / sidebarShow.length,
                        width: 75,
                        imageSize: 135 / sidebarShow.length,
                        textStyle: TextStyle(
                            color: AppColorConstants.imageTextColor,
                            fontSize: 90 / sidebarShow.length),
                        buttonIcon: sideButtonNameList[i]["icon"],
                        buttonName: sideButtonNameList[i]["name"],
                        flutterTts: flutterTts,
                        text: sideButtonNameList[i]["name"],
                        onTap: () async {
                          Future.delayed(const Duration(milliseconds: 20))
                              .whenComplete(() {
                            if (sideButtonNameList[i]["name"] == "Go back") {
                              reversTables();
                            } else if (sideButtonNameList[i]["name"] ==
                                "Home") {
                              getDataFromDatabse();
                            } else if (sideButtonNameList[i]["name"] ==
                                "Search") {
                              isSearchOpen = true;
                              setState(() {});
                              _scaffoldKey.currentState?.openEndDrawer();
                            }
                          });
                        },
                      ),
                      if (i != 5)
                        SizedBox(
                          height: Dimensions.screenHeight *
                              0.012 /
                              sidebarShow.length,
                        )
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> sideButtonNameList = [
    {
      "slug": "go_back",
      "name": "Go back",
      "icon": Icons.keyboard_backspace_sharp
    },
    {"slug": "home", "name": "Home", "icon": Icons.home},
    {"slug": "quick", "name": "Quick", "icon": Icons.spatial_tracking_outlined},
    {"slug": "core_words", "name": "Core words", "icon": Icons.cyclone_rounded},
    {"slug": "previous_page", "name": "Up", "icon": Icons.upload},
    {"slug": "next_page", "name": "Down", "icon": Icons.download_sharp},
    {"slug": "search_words", "name": "Search", "icon": Icons.search},
    {
      "slug": "alert",
      "name": "Alert",
      "icon": Icons.notifications_active_sharp
    },
    {
      "slug": "i_made_a_mistake",
      "name": "Mistake",
      "icon": Icons.warning_rounded
    },
  ];

  List<Map<String, dynamic>> textFieldButtonNameList = [
    {"name": "Speak", "icon": Icons.spatial_tracking_outlined},
    {"name": "Delete", "icon": Icons.backspace_rounded},
    {"name": "Clear", "icon": Icons.delete_forever_outlined},
    {"name": "Share", "icon": Icons.share},
  ];

  void onTextfieldButton(int i) async {
    await stopAudio();
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
    } else if (textFieldButtonNameList[i]["name"] == "Speak") {
      await flutterTts.awaitSpeakCompletion(true);
      Future.delayed(const Duration(seconds: 1)).whenComplete(
        () {
          readAllText();
        },
      );
    } else if (textFieldButtonNameList[i]["name"] == "Share") {
      Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => const MyHomePage(title: "hello boys"),
          ));
    }

    setState(() {});
  }

  void _addNewWidget(text, String? image, {String? audioFile}) async {
    await stopAudio();
    setState(() {
      _widgetList.add({
        'widget': Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (image != null &&
                    image != "null" &&
                    pictureAppearanceSettingModel!.pictureMassageBox!)
                  Image.file(
                    File(image),
                    height: 20,
                    width: 20,
                  ),
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

  bool _isNewWidget = true;

  void addTextFieldValue(String text) async {
    await stopAudio();
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
      scrollLastItem();
    });
  }

  void removeLastCharacter() async {
    await stopAudio();
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
      _mainTextFieldController.clear();
      scrollLastItem();
    });
  }

  // void readAllText() {
  //   String allText = _widgetList
  //       .map((widget) {
  //         if (widget["widget"] is Container) {
  //           var child = widget["widget"].child;
  //           if (child is Column) {
  //             return child.children
  //                 .whereType<Text>()
  //                 .map((textWidget) => (textWidget).data)
  //                 .join(" ");
  //           } else if (child is Text) {
  //             return child.data;
  //           }
  //         }
  //         return "";
  //       })
  //       .where((text) => text!.isNotEmpty)
  //       .join(" ");
  //   speakToText(allText, flutterTts);
  // }

  void readAllText() async {
    for (var item in _widgetList) {
      // Check if audio is present
      String? audioFile = item['audio'];
      if (audioFile != null && audioFile.isNotEmpty) {
        await playAudioFile(audioFile); // Play the audio file
      } else {
        // Process text from the widget
        var widget = item['widget'];
        if (widget is Container) {
          String textInColumn = "";
          var child = widget.child;
          if (child is Column) {
            textInColumn = child.children
                .whereType<Text>()
                .map((textWidget) => textWidget.data ?? "")
                .join(" ");
          } else if (child is Text) {
            textInColumn = child.data ?? "";
          }
          if (textInColumn.isNotEmpty) {
            await speakToText(
                textInColumn.trim(), flutterTts); // Speak the text
          }
        }
      }
    }
  }

  Future<void> playAudioFile(String audioFile) async {
    final completer = Completer<void>();
    player.onPlayerComplete.listen((event) {
      completer.complete(); // Complete the future when playback finishes
    });
    await player.play(DeviceFileSource(audioFile));
    await completer.future; // Wait until audio playback completes
  }

  Future<void> speakToText(String text, FlutterTts flutterTts) async {
    await flutterTts.speak(text);
    await flutterTts.awaitSpeakCompletion(true); // Wait for speech to finish
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
