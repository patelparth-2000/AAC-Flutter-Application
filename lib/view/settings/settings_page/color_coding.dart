import 'package:flutter/material.dart';

import '../../../services/data_base_service.dart';
import '../../../util/app_color_constants.dart';
import '../radio_button.dart';
import '../setting_model.dart/picture_appearance_setting_model.dart';

// ignore: must_be_immutable
class ColorCoding extends StatefulWidget {
  ColorCoding(
      {super.key,
      required this.dataBaseService,
      this.pictureAppearanceSettingModel,
      required this.refreshSettingData});
  final DataBaseService dataBaseService;
  PictureAppearanceSettingModel? pictureAppearanceSettingModel;
  final Function() refreshSettingData;
  @override
  State<ColorCoding> createState() => _ColorCodingState();
}

class _ColorCodingState extends State<ColorCoding> {
  List<RadioButtonModel> radioList = [
    RadioButtonModel(name: "Don't Colour code"),
    RadioButtonModel(name: "Colour code background"),
    RadioButtonModel(name: "colour code stripe"),
  ];

  void radioData(String value) {
    value = value.toLowerCase().replaceAll(" ", "_");
    for (var item in radioList) {
      item.select = item.name.toLowerCase().replaceAll(" ", "_") == value;

      if (item.select) {
        widget.pictureAppearanceSettingModel!.colorCoding = value;
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
    radioData(widget.pictureAppearanceSettingModel!.colorCoding!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(15),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text("Colour Codings Settings",
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
