import 'package:flutter/material.dart';

import '../../../services/data_base_service.dart';
import '../../../util/app_color_constants.dart';
import '../radio_button.dart';
import '../setting_model/keyboard_setting.dart';

// ignore: must_be_immutable
class KeysOnSelection extends StatefulWidget {
  KeysOnSelection(
      {super.key,
      this.keyboardSettingModel,
      required this.dataBaseService,
      required this.refreshSettingData});
  final DataBaseService dataBaseService;
  KeyboardSettingModel? keyboardSettingModel;
  final Function() refreshSettingData;
  @override
  State<KeysOnSelection> createState() => _KeysOnSelectionState();
}

class _KeysOnSelectionState extends State<KeysOnSelection> {
  List<RadioButtonModel> radioList = [
    RadioButtonModel(name: "Don't enlarge", select: true),
    RadioButtonModel(name: "Enlarge slowly"),
    RadioButtonModel(name: "Enlarge at normal speed"),
    RadioButtonModel(name: "Enlarge quickly"),
  ];

  void radioData(String value) {
    value = value.toLowerCase().replaceAll(" ", "_");
    for (var item in radioList) {
      item.select = item.name.toLowerCase().replaceAll(" ", "_") == value;

      if (item.select) {
        widget.keyboardSettingModel!.enlargeSpeed = value;
        widget.dataBaseService
            .keyboardSettingUpdate(widget.keyboardSettingModel!);
      }
    }
    setState(() {});
    widget.refreshSettingData();
  }

  @override
  void initState() {
    super.initState();
    radioData(widget.keyboardSettingModel!.enlargeSpeed!);
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
