import 'package:avaz_app/common/common_image_button.dart';
import 'package:avaz_app/util/dimensions.dart';
import 'package:avaz_app/view/edit_file/edit_file_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../model/get_category_modal.dart';
import '../../services/data_base_service.dart';
import '../../util/app_color_constants.dart';
import '../settings/setting_model/keyboard_setting.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen(
      {super.key,
      required this.dataBaseService,
      required this.onTextValue,
      required this.onSpace,
      required this.flutterTts,
      this.keyboardSettingModel});
  final DataBaseService dataBaseService;
  final Function(String) onTextValue;
  final Function() onSpace;
  final FlutterTts flutterTts;
  final KeyboardSettingModel? keyboardSettingModel;
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<GetCategoryModal> getCategoryModalList = [];
  List<GetCategoryModal> getVoiceModalList = [];
  int indexID = 1;
  int index = 0;
  int editIndex = -1;
  List<int> editList = [];
  bool isEdit = false;
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
    getVoiceData(getCategoryModalList[index]);
  }

  void getVoiceData(GetCategoryModal getvoicedata) async {
    var categoryData =
        await widget.dataBaseService.getTablesData(getvoicedata.slug!);
    addVoiceData(categoryData);
    setState(() {});
  }

  void renameFolder(String name) async {
    await widget.dataBaseService.renameItem(editIndex, name);
    getDataFromDatabse();
    setState(() {});
  }

  void addVoiceData(categoryData) async {
    getVoiceModalList.clear();
    if (categoryData != null && categoryData is List) {
      for (var item in categoryData) {
        if (item is Map<String, dynamic>) {
          if (item["delete_status"] != "1") {
            Map<String, dynamic> modifiableItem =
                Map<String, dynamic>.from(item);
            getVoiceModalList.add(GetCategoryModal.fromJson(modifiableItem));
          }
        }
      }
    }
  }

  void deleteItem() async {
    for (var id in editList) {
      await widget.dataBaseService
          .deleteItem(id, getCategoryModalList[index].slug);
    }
    getVoiceData(getCategoryModalList[index]);
    setState(() {});
  }

  void deleteFolder() async {
    await widget.dataBaseService.deleteItem(editIndex, null);
    indexID = 1;
    getDataFromDatabse();
    setState(() {});
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
              if (editList.isNotEmpty) {
                deleteItem();
              }
              if (editIndex != -1) {
                deleteFolder();
              }
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColorConstants.keyBoardBackColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEdit ? "Edit" : "Favourites",
                  style: const TextStyle(
                      fontSize: 20,
                      color: AppColorConstants.imageTextButtonColor,
                      fontWeight: FontWeight.w900),
                ),
                Text(
                  isEdit
                      ? "Select an item to edit"
                      : "Select the Messages to add to your sentence",
                  style: const TextStyle(
                      fontSize: 20,
                      color: AppColorConstants.imageTextButtonColor),
                ),
                if (!isEdit)
                  CommonImageButton(
                    buttonIcon: Icons.edit,
                    isHorizontal: true,
                    isImageShow: true,
                    vertical: 3,
                    fontSize: 18,
                    buttonName: "Edit",
                    onTap: () {
                      isEdit = true;
                      setState(() {});
                    },
                  )
                else
                  Row(
                    spacing: 4,
                    children: [
                      CommonImageButton(
                        buttonIcon: Icons.delete,
                        isHorizontal: true,
                        isImageShow: true,
                        vertical: 3,
                        fontSize: 15,
                        buttonName: "Delete",
                        buttonIconColor: editIndex != -1 || editList.isNotEmpty
                            ? AppColorConstants.white
                            : AppColorConstants.icons,
                        buttonTextColor: editIndex != -1 || editList.isNotEmpty
                            ? AppColorConstants.white
                            : AppColorConstants.icons,
                        onTap: () {
                          if (editIndex == -1 && editList.isEmpty) {
                            return;
                          }
                          showErrorDialog();
                        },
                      ),
                      CommonImageButton(
                        buttonIcon: Icons.edit,
                        isHorizontal: true,
                        isImageShow: true,
                        vertical: 3,
                        fontSize: 15,
                        buttonName: "Rename",
                        buttonIconColor: editIndex != -1
                            ? AppColorConstants.white
                            : AppColorConstants.icons,
                        buttonTextColor: editIndex != -1
                            ? AppColorConstants.white
                            : AppColorConstants.icons,
                        onTap: () {
                          if (editIndex == -1 && editList.isEmpty) {
                            return;
                          }
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditFileScreen(
                                  dataBaseService: widget.dataBaseService,
                                  flutterTts: widget.flutterTts,
                                  keyboardSettingModel:
                                      widget.keyboardSettingModel,
                                  rename: renameFolder,
                                ),
                              ));
                        },
                      ),
                      CommonImageButton(
                        buttonIcon: Icons.cancel,
                        isHorizontal: true,
                        isImageShow: true,
                        vertical: 3,
                        fontSize: 15,
                        buttonName: "Exit",
                        onTap: () {
                          isEdit = false;
                          editIndex = -1;
                          editList.clear();
                          setState(() {});
                        },
                      ),
                    ],
                  )
              ],
            ),
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
                    Stack(
                      children: [
                        CommonImageButton(
                          width: 110,
                          buttonIcon:
                              indexID.toString() == getCategoryModalList[i].id
                                  ? Icons.folder_special_rounded
                                  : null,
                          textwidth: 70,
                          backgroundColor:
                              AppColorConstants.keyBoardBackColorGreen,
                          buttonIconColor:
                              AppColorConstants.imageTextButtonColor,
                          buttonTextColor:
                              AppColorConstants.imageTextButtonColor,
                          iscolorChange: false,
                          isHorizontal: true,
                          isImageShow: true,
                          vertical:
                              indexID.toString() == getCategoryModalList[i].id
                                  ? 10
                                  : 12,
                          imageSize: 20,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          buttonName: getCategoryModalList[i].name,
                          onTap: () {
                            index = i;
                            indexID = int.parse(getCategoryModalList[i].id!);
                            getVoiceData(getCategoryModalList[i]);
                            if (isEdit) {
                              editIndex = indexID;
                              editList.clear();
                            }
                            setState(() {});
                          },
                        ),
                        if (isEdit)
                          Positioned(
                            right: 3,
                            child: Icon(
                              editIndex.toString() == getCategoryModalList[i].id
                                  ? Icons.check_circle
                                  : Icons.radio_button_off,
                              color: AppColorConstants.imageTextButtonColor,
                              size: 15,
                            ),
                          )
                      ],
                    )
                ],
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 75),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 3.5,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  crossAxisCount: 4),
              itemCount: getVoiceModalList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var voiceData = getVoiceModalList[index];
                return Stack(
                  children: [
                    CommonImageButton(
                      backgroundColor: AppColorConstants.imageTextButtonColor,
                      buttonTextColor: AppColorConstants.white,
                      iscolorChange: false,
                      isHorizontal: true,
                      imageSize: 20,
                      horizontal: 0,
                      vertical: 0,
                      textheight: 50,
                      textwidth: Dimensions.screenWidth * .188,
                      fontSize: 12,
                      buttonName: voiceData.name,
                      onTap: () {
                        if (isEdit) {
                          editIndex = -1;
                          for (var id in editList) {
                            if (id == int.parse(voiceData.id!)) {
                              editList.remove(id);
                              setState(() {});
                              return;
                            }
                          }
                          editList.add(int.parse(voiceData.id!));
                          setState(() {});
                          return;
                        }
                        widget.onTextValue(voiceData.name!);
                        widget.onSpace();
                        setState(() {});
                      },
                    ),
                    if (isEdit)
                      Positioned(
                        right: 3,
                        child: Icon(
                          editList.contains(int.parse(voiceData.id!))
                              ? Icons.check_circle
                              : Icons.radio_button_off,
                          color: AppColorConstants.keyBoardBackColor,
                          size: 15,
                        ),
                      )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
