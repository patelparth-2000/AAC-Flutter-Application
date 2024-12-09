import 'package:flutter/material.dart';

import '../../../services/data_base_service.dart';
import '../../../util/app_color_constants.dart';
import '../radio_button.dart';
import '../setting_model.dart/audio_setting.dart';

// ignore: must_be_immutable
class WhatToSpeak extends StatefulWidget {
  WhatToSpeak(
      {super.key,
      this.audioSettingModel,
      required this.dataBaseService,
      required this.refreshSettingData});
  final DataBaseService dataBaseService;
  AudioSettingModel? audioSettingModel;
  final Function() refreshSettingData;
  @override
  State<WhatToSpeak> createState() => _WhatToSpeakState();
}

class _WhatToSpeakState extends State<WhatToSpeak> {
  List<RadioButtonModel> radioList = [
    RadioButtonModel(name: "Speak Everything", select: true),
    RadioButtonModel(name: "Speak Words"),
    RadioButtonModel(name: "Speak only message box"),
  ];

  void radioData(String value) {
    value = value.toLowerCase().replaceAll(" ", "_");
    for (var item in radioList) {
      item.select = item.name.toLowerCase().replaceAll(" ", "_") == value;

      if (item.select) {
        widget.audioSettingModel!.whatToSpeak = value;
        widget.dataBaseService.audioSettingUpdate(widget.audioSettingModel!);
      }
    }
    setState(() {});
    widget.refreshSettingData();
  }

  @override
  void initState() {
    super.initState();
    radioData(widget.audioSettingModel!.whatToSpeak!);
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
