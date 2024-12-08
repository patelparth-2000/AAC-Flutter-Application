import 'package:flutter/material.dart';

import '../../../services/data_base_service.dart';
import '../../../util/app_color_constants.dart';
import '../setting_model.dart/keyboard_setting.dart';
import '../setting_widget.dart';
import '../title_widget.dart';

// ignore: must_be_immutable
class Prediction extends StatefulWidget {
  Prediction(
      {super.key, this.keyboardSettingModel, required this.dataBaseService});
  final DataBaseService dataBaseService;
  KeyboardSettingModel? keyboardSettingModel;
  @override
  State<Prediction> createState() => _PredictionState();
}

class _PredictionState extends State<Prediction> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text("Prediction Settings",
                style: TextStyle(
                    color: AppColorConstants.buttonColorBlue2,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const TitleWidget(text: "PREDICTION"),
                      SettingWidget(
                          text: "Prediction",
                          isSwitch: true,
                          switchValue: widget.keyboardSettingModel!.prediction!,
                          onSwitchChanged: (value) {
                            widget.keyboardSettingModel!.prediction = value;
                            widget.dataBaseService.keyboardSettingUpdate(
                                widget.keyboardSettingModel!);
                            setState(() {});
                          }),
                      SettingWidget(
                          text: "Predict with pictures",
                          isSwitch: true,
                          switchValue: widget
                              .keyboardSettingModel!.predictionWithPictures!,
                          onSwitchChanged: (value) {
                            widget.keyboardSettingModel!
                                .predictionWithPictures = value;
                            widget.dataBaseService.keyboardSettingUpdate(
                                widget.keyboardSettingModel!);
                            setState(() {});
                          }),
                      const TitleWidget(text: "WHAT TO PREDICT"),
                      SettingWidget(
                          text: "Next Word",
                          isSwitch: true,
                          switchValue: widget.keyboardSettingModel!.nextWord!,
                          onSwitchChanged: (value) {
                            widget.keyboardSettingModel!.nextWord = value;
                            widget.dataBaseService.keyboardSettingUpdate(
                                widget.keyboardSettingModel!);
                            setState(() {});
                          }),
                      SettingWidget(
                          text: "Current word",
                          isSwitch: true,
                          switchValue:
                              widget.keyboardSettingModel!.currentWord!,
                          onSwitchChanged: (value) {
                            widget.keyboardSettingModel!.currentWord = value;
                            widget.dataBaseService.keyboardSettingUpdate(
                                widget.keyboardSettingModel!);
                            setState(() {});
                          }),
                      SettingWidget(
                          text: "Phonetic match",
                          isSwitch: true,
                          switchValue:
                              widget.keyboardSettingModel!.phoneticMatch!,
                          onSwitchChanged: (value) {
                            widget.keyboardSettingModel!.phoneticMatch = value;
                            widget.dataBaseService.keyboardSettingUpdate(
                                widget.keyboardSettingModel!);
                            setState(() {});
                          }),
                    ]),
              ),
            ),
          ],
        ));
  }
}
