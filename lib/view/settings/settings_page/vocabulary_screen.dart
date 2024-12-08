import 'package:flutter/material.dart';

import '../../../services/data_base_service.dart';
import '../../../util/app_color_constants.dart';
import '../radio_button.dart';
import '../setting_model.dart/picture_behaviour_setting_model.dart';

// ignore: must_be_immutable
class VocabularyScreen extends StatefulWidget {
  VocabularyScreen(
      {super.key,
      this.pictureBehaviourSettingModel,
      required this.dataBaseService});
  final DataBaseService dataBaseService;
  PictureBehaviourSettingModel? pictureBehaviourSettingModel;
  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  List<RadioButtonModel> radioList = [
    RadioButtonModel(name: "ROOT SCREEN", select: true),
    RadioButtonModel(name: "QUICK"),
    RadioButtonModel(name: "GETTING STARTED"),
    RadioButtonModel(name: "BASIC"),
    RadioButtonModel(name: "ADVANCED"),
    RadioButtonModel(name: "CORE WORDS"),
    RadioButtonModel(name: "OTHER LANGUAGES"),
  ];

  void radioData(String value) {
    value = value.toLowerCase().replaceAll(" ", "_");
    for (var item in radioList) {
      item.select = item.name.toLowerCase().replaceAll(" ", "_") == value;

      if (item.select) {
        widget.pictureBehaviourSettingModel!.vocabularyHome = value;
        widget.dataBaseService
            .pictureBehaviourSettingUpdate(widget.pictureBehaviourSettingModel!);
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    radioData(widget.pictureBehaviourSettingModel!.vocabularyHome!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(15),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text("Home Screen Vocabulary Settings",
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
