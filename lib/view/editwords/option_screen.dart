import 'package:avaz_app/util/dimensions.dart';
import 'package:avaz_app/view/editwords/edit_words_screen.dart';
import 'package:flutter/material.dart';

import '../../common/common.dart';
import '../../common/common_image_button.dart';
import '../../util/app_color_constants.dart';
import '../drawer/drawer_screen.dart';
import '../settings/setting_model/touch_setting.dart';

// ignore: must_be_immutable
class OptionScreen extends StatelessWidget {
  OptionScreen(
      {super.key, required this.refreshGirdData, this.touchSettingModel});
  final Function() refreshGirdData;
  final TouchSettingModel? touchSettingModel;
  List<DrawerModel> drawerData = [
    DrawerModel(
      name: "Category",
    ),
    DrawerModel(name: "Sub Category", isShow: false),
    DrawerModel(
      name: "Voice",
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.keyBoardBackColor,
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Close",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColorConstants.buttonColorBlue1),
                    ),
                  ),
                ),
                const Text(
                  "Select what you want to add",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColorConstants.buttonColorBlue1),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () {
                      // addData(context);
                    },
                    child: const Text(
                      "",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColorConstants.buttonColorBlue1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          dividerWidget(height: 0.5),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < drawerData.length; i++)
                  if (drawerData[i].isShow)
                    Column(
                      children: [
                        CommonImageButton(
                          touchSettingModel: touchSettingModel,
                          width: Dimensions.screenWidth * 0.2,
                          isHorizontal: true,
                          text: drawerData[i].name,
                          buttonName: drawerData[i].name,
                          buttonIcon: drawerData[i].imageData,
                          horizontal: 10,
                          vertical: 10,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          fontWeight: FontWeight.bold,
                          onTap: () {
                            bool isCategory = false;
                            bool isSubCategory = false;
                            String name = "Voice";
                            if (drawerData[i]
                                    .name
                                    .toLowerCase()
                                    .replaceAll(" ", "_") ==
                                "category") {
                              isCategory = true;
                              isSubCategory = false;
                              name = "Category";
                            } else if (drawerData[i]
                                    .name
                                    .toLowerCase()
                                    .replaceAll(" ", "_") ==
                                "sub_category") {
                              isCategory = false;
                              isSubCategory = true;
                              name = "Sub Category";
                            }
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditWordsScreen(
                                    refreshGirdData: refreshGirdData,
                                    isCategory: isCategory,
                                    isSubCategory: isSubCategory,
                                    name: name,
                                    touchSettingModel: touchSettingModel,
                                  ),
                                ));
                          },
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
