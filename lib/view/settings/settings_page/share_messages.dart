import 'package:flutter/material.dart';

import '../../../util/app_color_constants.dart';
import '../radio_button.dart';
import '../setting_widget.dart';

class ShareMessages extends StatefulWidget {
  const ShareMessages({super.key});

  @override
  State<ShareMessages> createState() => _ShareMessagesState();
}

class _ShareMessagesState extends State<ShareMessages> {
  List<RadioButtonModel> radioList = [
    RadioButtonModel(name: "Image", select: true),
    RadioButtonModel(name: "Text"),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(15),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text("Share Settings",
                  style: TextStyle(
                      color: AppColorConstants.buttonColorBlue2,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: SettingWidget(
                  text: "Share Messages",
                  isSwitch: true,
                  switchValue: false,
                  onSwitchChanged: (value) {},
                ),
              ),
              RadioButton(
                  onTap: () {
                    setState(() {});
                  },
                  radioList: radioList),
            ]));
  }
}
