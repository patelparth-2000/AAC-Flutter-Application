import 'package:avaz_app/util/app_color_constants.dart';
import 'package:flutter/material.dart';

import '../../../services/data_base_service.dart';
import '../radio_button.dart';
import '../setting_model/picture_appearance_setting_model.dart';

// ignore: must_be_immutable
class TestSize extends StatefulWidget {
  TestSize(
      {super.key,
      required this.dataBaseService,
      this.pictureAppearanceSettingModel,
      required this.refreshSettingData});
  final DataBaseService dataBaseService;
  PictureAppearanceSettingModel? pictureAppearanceSettingModel;
  final Function() refreshSettingData;

  @override
  State<TestSize> createState() => _TestSizeState();
}

class _TestSizeState extends State<TestSize> {
  List<RadioButtonModel> radioList = [
    RadioButtonModel(name: "No text (only picture)"),
    RadioButtonModel(name: "Small"),
    RadioButtonModel(name: "Medium", select: true),
    RadioButtonModel(name: "Large"),
    RadioButtonModel(name: "Only text (no picture)"),
  ];

  void radioData(String value) {
    value = value.toLowerCase().replaceAll(" ", "_");
    for (var item in radioList) {
      item.select = item.name.toLowerCase().replaceAll(" ", "_") == value;

      if (item.select) {
        widget.pictureAppearanceSettingModel!.textSize = value;
        widget.dataBaseService.pictureAppearanceSettingUpdate(
            widget.pictureAppearanceSettingModel!);
      }
    }
    setState(() {});
    widget.refreshSettingData();
  }

  @override
  void initState() {
    super.initState();
    radioData(widget.pictureAppearanceSettingModel!.textSize!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(15),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text("Pictures Per Screen (Grid Size)",
                  style: TextStyle(
                      color: AppColorConstants.buttonColorBlue2,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 20,
              ),
              RadioButton(
                  onTap: (value) {
                    radioData(value);
                    setState(() {});
                  },
                  radioList: radioList),
            ]));
  }
}
