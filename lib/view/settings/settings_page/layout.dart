import 'package:avaz_app/view/settings/setting_model.dart/keyboard_setting.dart';
import 'package:flutter/material.dart';

import '../../../services/data_base_service.dart';
import '../../../util/app_color_constants.dart';
import '../radio_button.dart';
import '../setting_widget.dart';

// ignore: must_be_immutable
class Layout extends StatefulWidget {
  Layout({super.key, this.keyboardSettingModel, required this.dataBaseService});
  final DataBaseService dataBaseService;
  KeyboardSettingModel? keyboardSettingModel;
  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  List<RadioButtonModel> radioList = [
    RadioButtonModel(name: "ENGLISH (QWE)", select: true),
    RadioButtonModel(name: "ENGLISH (ABC)"),
  ];

  void radioData(String value) {
    value = value.toLowerCase().replaceAll(" ", "_");
    for (var item in radioList) {
      item.select = item.name.toLowerCase().replaceAll(" ", "_") == value;

      if (item.select) {
        widget.keyboardSettingModel!.layout = value;
        widget.dataBaseService
            .keyboardSettingUpdate(widget.keyboardSettingModel!);
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    radioData(widget.keyboardSettingModel!.layout!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(15),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text("Keyboard Layout Settings",
                  style: TextStyle(
                      color: AppColorConstants.buttonColorBlue2,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 20,
              ),
              RadioButton(
                  physics: const NeverScrollableScrollPhysics(),
                  onTap: (value) {
                    radioData(value);
                    setState(() {});
                  },
                  radioList: radioList),
              Expanded(
                flex: 3,
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: SettingWidget(
                      text: "HIGHLIGHT VOWELS",
                      isSwitch: true,
                      switchValue:
                          widget.keyboardSettingModel!.highlightVowels!,
                      onSwitchChanged: (value) {
                        widget.keyboardSettingModel!.highlightVowels = value;
                        widget.dataBaseService.keyboardSettingUpdate(
                            widget.keyboardSettingModel!);
                        setState(() {});
                      }),
                ),
              ),
            ]));
  }
}
