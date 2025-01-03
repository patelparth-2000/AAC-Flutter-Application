import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../common/common_image_button.dart';
import '../../model/get_category_modal.dart';
import '../../services/data_base_service.dart';
import '../../util/app_color_constants.dart';
import '../edit_file/edit_file_screen.dart';
import '../settings/setting_model/keyboard_setting.dart';

class SaveScreen extends StatefulWidget {
  const SaveScreen(
      {super.key,
      required this.dataBaseService,
      required this.onTextValue,
      required this.onSpace,
      required this.flutterTts,
      required this.saveAllText,
      this.keyboardSettingModel,
      this.keyboradShow});
  final DataBaseService dataBaseService;
  final Function(String) onTextValue;
  final Function() onSpace;
  final FlutterTts flutterTts;
  final Function() saveAllText;
  final KeyboardSettingModel? keyboardSettingModel;
  final Function(bool, bool, bool)? keyboradShow;
  @override
  State<SaveScreen> createState() => _SaveScreenState();
}

class _SaveScreenState extends State<SaveScreen> {
  List<GetCategoryModal> getCategoryModalList = [];
  @override
  void initState() {
    super.initState();
    getDataFromDatabse();
  }

  void getDataFromDatabse() async {
    var categoryData = await widget.dataBaseService.getFavoritesTable();
    addCategoryData(categoryData);
    setState(() {});
  }

  void addCategoryData(categoryData) async {
    getCategoryModalList.clear();
    if (categoryData != null && categoryData is List) {
      for (var item in categoryData) {
        if (item is Map<String, dynamic>) {
          if (item["delete_status"] != "1") {
            Map<String, dynamic> modifiableItem =
                Map<String, dynamic>.from(item);
            getCategoryModalList.add(GetCategoryModal.fromJson(modifiableItem));
          }
        }
      }
    }
  }

  void showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColorConstants.keyBoardBackColor,
        surfaceTintColor: AppColorConstants.keyBoardBackColor,
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(5)),
        title: const Text("Warning"),
        content: const Text(
          "Are you sure you wish to delete\nthe selected folder",
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 100,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: AppColorConstants.white,
                  borderRadius: BorderRadius.circular(5)),
              child: const Text(
                "Close",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColorConstants.imageTextButtonColor),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 100,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: AppColorConstants.imageTextButtonColor,
                  borderRadius: BorderRadius.circular(5)),
              child: const Text(
                "Ok",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColorConstants.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void categoryFavourite(String name) async {
    int? lastId = await widget.dataBaseService.getLastAddedItemId(
        "favourite_table".replaceAll(" ", "_").toLowerCase());

    Map<String, dynamic> commonCategoryData = {
      "id": lastId != null ? (lastId + 1) : 1,
      "type": "category",
      "color": null,
      "lang": "1",
      "name": name,
      "image": null,
      "slug": name.replaceAll(" ", "_").toLowerCase(),
      "created_by": null,
      "status": "active",
      "delete_status": "0",
      "lang_name": {"id": 1, "name": "English"}
    };
    await _insertApiResponseToDatabase(
        commonCategoryData, "favourite_table", "type", "id");
    voiceFavourite(name);
  }

  Future<void> voiceFavourite(String name) async {
    bool isExists = await widget.dataBaseService
        .checkIfTableExistsOrNot(name.replaceAll(" ", "_").toLowerCase());
    int? lastId;
    if (isExists) {
      lastId = await widget.dataBaseService
          .getLastAddedItemId(name.replaceAll(" ", "_").toLowerCase());
    }
    Map<String, dynamic> commonVoiceData = {
      "id": lastId != null ? (lastId + 1) : 1,
      "type": "voice",
      "lang": "1",
      "category_id": null,
      "sub_category_id": null,
      "name": widget.saveAllText(),
      "code": null,
      "image": null,
      "slug": widget.saveAllText().replaceAll(" ", "_").toLowerCase(),
      "voice_file": null,
      "created_by": 1,
      "status": "active",
      "delete_status": "0",
      "category": null,
      "lang_name": {"id": 1, "name": "English"},
      "subcategory": null
    };

    // Insert data into the database
    await _insertApiResponseToDatabase(
      commonVoiceData,
      name.replaceAll(" ", "_").toLowerCase(),
      "type",
      "id",
    );
    if (widget.keyboradShow != null) {
      widget.keyboradShow!(true, true, false);
    }
  }

  Future<void> _insertApiResponseToDatabase(Map<String, dynamic> apiData,
      String tableName, String uniqueType, String uniqueId) async {
    final dbService = DataBaseService.instance;
    // Dynamically create a table based on API data
    await dbService.createTablesFromApiData(
      tableName: tableName, // Define your table name
      apiData: apiData,
      uniqueType: uniqueType,
      uniqueId: uniqueId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColorConstants.keyBoardBackColor,
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Text(
            'Saving "${widget.saveAllText()}" to Favourites',
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 25, color: AppColorConstants.imageTextButtonColor),
          ),
          const SizedBox(
            height: 30,
          ),
          const Text(
            'Choose a Folder:',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 25, color: AppColorConstants.imageTextButtonColor),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            color: AppColorConstants.imageTextButtonColor,
            padding: const EdgeInsets.all(5),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 5,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < getCategoryModalList.length; i++)
                    if (i != 0)
                      Stack(
                        children: [
                          CommonImageButton(
                            width: 110,
                            backgroundColor:
                                AppColorConstants.keyBoardBackColorGreen,
                            buttonIconColor:
                                AppColorConstants.imageTextButtonColor,
                            buttonTextColor:
                                AppColorConstants.imageTextButtonColor,
                            iscolorChange: false,
                            isHorizontal: true,
                            isImageShow: true,
                            vertical: 12,
                            imageSize: 20,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            buttonName: getCategoryModalList[i].name,
                            onTap: () {
                              voiceFavourite(getCategoryModalList[i].slug!);
                              setState(() {});
                            },
                          ),
                        ],
                      )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'or Create a Folder:',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 25, color: AppColorConstants.imageTextButtonColor),
          ),
          CommonImageButton(
            width: 150,
            buttonIcon: Icons.folder,
            betweenGap: 5,
            backgroundColor: AppColorConstants.keyBoardBackColorGreen,
            borderColor: AppColorConstants.keyBoardBackColorGreen,
            buttonIconColor: AppColorConstants.imageTextButtonColor,
            buttonTextColor: AppColorConstants.imageTextButtonColor,
            iscolorChange: false,
            isHorizontal: true,
            isImageShow: true,
            vertical: 6,
            imageSize: 25,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            buttonName: "New Folder",
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditFileScreen(
                      rename: categoryFavourite,
                      dataBaseService: widget.dataBaseService,
                      flutterTts: widget.flutterTts,
                      keyboardSettingModel: widget.keyboardSettingModel,
                    ),
                  ));
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
