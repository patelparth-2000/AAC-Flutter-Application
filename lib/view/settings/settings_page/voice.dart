import 'package:flutter/material.dart';

import '../../../services/data_base_service.dart';
import '../../../util/app_color_constants.dart';
import '../setting_model/audio_setting.dart';
import '../setting_widget.dart';
import '../title_widget.dart';

// ignore: must_be_immutable
class Voice extends StatefulWidget {
  Voice(
      {super.key,
      this.audioSettingModel,
      required this.dataBaseService,
      required this.refreshSettingData});
  final DataBaseService dataBaseService;
  AudioSettingModel? audioSettingModel;
  final Function() refreshSettingData;
  @override
  State<Voice> createState() => _VoiceState();
}

class _VoiceState extends State<Voice> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text("Speech Settings",
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
                      const TitleWidget(text: "SPEECH SERVICE"),
                      const SizedBox(height: 10),
                      const Text(
                        "Priya - English (IN) a Premium voice",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.italic,
                          color: AppColorConstants.imageTextButtonColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const SettingWidget(
                        text: "Default Voice",
                      ),
                      const SettingWidget(
                        text: "Premium Voice by ReadSpeaker",
                      ),
                      SettingWidget(
                        text: "EXPRESSIVE TONES",
                        isSwitch: true,
                        switchValue: false,
                        isTextTitle: true,
                        onSwitchChanged: (value) {
                          widget.refreshSettingData();
                        },
                      ),
                    ]),
              ),
            ),
          ],
        ));
  }
}
