import 'package:flutter/material.dart';

import '../../../services/data_base_service.dart';
import '../../../util/app_color_constants.dart';
import '../setting_model.dart/picture_behaviour_setting_model.dart';
import '../setting_widget.dart';
import '../title_widget.dart';

// ignore: must_be_immutable
class Grammar extends StatefulWidget {
  Grammar(
      {super.key,
      this.pictureBehaviourSettingModel,
      required this.dataBaseService});
  final DataBaseService dataBaseService;
  PictureBehaviourSettingModel? pictureBehaviourSettingModel;
  @override
  State<Grammar> createState() => _GrammarState();
}

class _GrammarState extends State<Grammar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text("Grammar Settings",
                style: TextStyle(
                    color: AppColorConstants.buttonColorBlue2,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 20,
            ),
            const TitleWidget(
              text: "GRAMMAR SETTING",
            ),
            SettingWidget(
                text: "Grammar",
                isSwitch: true,
                switchValue: widget.pictureBehaviourSettingModel!.grammar!,
                onSwitchChanged: (value) {
                  widget.pictureBehaviourSettingModel!.grammar = value;
                  widget.dataBaseService.pictureBehaviourSettingUpdate(
                     widget.pictureBehaviourSettingModel!);
                  setState(() {});
                }),
            SettingWidget(
                text: "Show Word froms in Picture Grid",
                isSwitch: true,
                switchValue:
                    widget.pictureBehaviourSettingModel!.grammarPictureGrid!,
                onSwitchChanged: (value) {
                  widget.pictureBehaviourSettingModel!.grammarPictureGrid =
                      value;
                  widget.dataBaseService.pictureBehaviourSettingUpdate(
                      widget.pictureBehaviourSettingModel!);
                  setState(() {});
                }),
          ],
        ));
  }
}
