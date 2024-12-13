import 'package:flutter/material.dart';

import '../../../services/data_base_service.dart';
import '../../../util/app_color_constants.dart';
import '../radio_button.dart';
import '../setting_model.dart/picture_behaviour_setting_model.dart';

// ignore: must_be_immutable
class WordOnSelection extends StatefulWidget {
  WordOnSelection(
      {super.key,
      this.pictureBehaviourSettingModel,
      required this.dataBaseService,
      required this.refreshSettingData});
  final DataBaseService dataBaseService;
  PictureBehaviourSettingModel? pictureBehaviourSettingModel;
  final Function() refreshSettingData;

  @override
  State<WordOnSelection> createState() => _WordOnSelectionState();
}

class _WordOnSelectionState extends State<WordOnSelection> {
  List<RadioButtonModel> radioList = [
    RadioButtonModel(name: "Don't enlarge"),
    RadioButtonModel(name: "Enlarge slowly"),
    RadioButtonModel(name: "Enlarge at normal speed", select: true),
    RadioButtonModel(name: "Enlarge quickly"),
  ];

  void radioData(String value) {
    value = value.toLowerCase().replaceAll(" ", "_");
    for (var item in radioList) {
      item.select = item.name.toLowerCase().replaceAll(" ", "_") == value;

      if (item.select) {
        widget.pictureBehaviourSettingModel!.wordOnSelection = value;
        widget.dataBaseService.pictureBehaviourSettingUpdate(
            widget.pictureBehaviourSettingModel!);
      }
    }
    setState(() {});
    widget.refreshSettingData();
  }

  @override
  void initState() {
    super.initState();
    radioData(widget.pictureBehaviourSettingModel!.wordOnSelection!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(15),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text("Enlarge speed Settings",
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
