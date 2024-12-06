import 'package:flutter/material.dart';

import '../../../util/app_color_constants.dart';
import '../setting_widget.dart';
import '../title_widget.dart';

class Prediction extends StatefulWidget {
  const Prediction({super.key});

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
                        switchValue: true,
                        onSwitchChanged: (value) {},
                      ),
                      SettingWidget(
                        text: "Predict with pictures",
                        isSwitch: true,
                        switchValue: true,
                        onSwitchChanged: (value) {},
                      ),
                      const TitleWidget(text: "WHAT TO PREDICT"),
                      SettingWidget(
                        text: "Next Word",
                        isSwitch: true,
                        switchValue: true,
                        onSwitchChanged: (value) {},
                      ),
                      SettingWidget(
                        text: "Current word",
                        isSwitch: true,
                        switchValue: true,
                        onSwitchChanged: (value) {},
                      ),
                      SettingWidget(
                        text: "Phonetic match",
                        isSwitch: true,
                        switchValue: true,
                        onSwitchChanged: (value) {},
                      ),
                    ]),
              ),
            ),
          ],
        ));
  }
}
