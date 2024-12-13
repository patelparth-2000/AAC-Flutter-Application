import 'package:avaz_app/view/settings/radio_button.dart';
import 'package:flutter/material.dart';

import '../../../services/data_base_service.dart';
import '../../../util/app_color_constants.dart';
import '../setting_model.dart/picture_appearance_setting_model.dart';

// ignore: must_be_immutable
class PicturesGridSize extends StatefulWidget {
  PicturesGridSize(
      {super.key,
      required this.dataBaseService,
      this.pictureAppearanceSettingModel,
      required this.refreshSettingData});
  final DataBaseService dataBaseService;
  PictureAppearanceSettingModel? pictureAppearanceSettingModel;
  final Function() refreshSettingData;

  @override
  State<PicturesGridSize> createState() => _PicturesGridSizeState();
}

class _PicturesGridSizeState extends State<PicturesGridSize> {
  List<RadioButtonModel> radioList = [
    RadioButtonModel(name: "Very Small (77 pictures)"),
    RadioButtonModel(name: "Small (60 pictures)"),
    RadioButtonModel(name: "Small (40 pictures)"),
    RadioButtonModel(name: "Small (24 pictures)"),
    RadioButtonModel(name: "Normal (15 pictures)"),
    RadioButtonModel(name: "Large (8 pictures)"),
    RadioButtonModel(name: "Large (4 pictures)"),
    RadioButtonModel(name: "Large (3 pictures)"),
    RadioButtonModel(name: "Extra-Large (2 pictures)"),
    RadioButtonModel(name: "Huge (1 pictures)"),
  ];

  void radioData(String value) {
    value = value.toLowerCase().replaceAll(" ", "_");
    for (var item in radioList) {
      item.select = item.name.toLowerCase().replaceAll(" ", "_") == value;

      if (item.select) {
        final numberMatch = RegExp(r'\d+').firstMatch(item.name);
        final pictureCount =
            numberMatch != null ? int.parse(numberMatch.group(0)!) : 0;
        widget.pictureAppearanceSettingModel!.picturePerScreen = value;
        widget.pictureAppearanceSettingModel!.picturePerScreenCount =
            pictureCount;
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
    radioData(widget.pictureAppearanceSettingModel!.picturePerScreen!);
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
