import 'package:flutter/material.dart';

import '../../../util/app_color_constants.dart';
import '../radio_button.dart';
import '../setting_widget.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  List<RadioButtonModel> radioList = [
    RadioButtonModel(name: "ENGLISH (QWE)", select: true),
    RadioButtonModel(name: "ENGLISH (ABC)"),
  ];
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
                  onTap: () {
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
                    switchValue: false,
                    onSwitchChanged: (value) {},
                  ),
                ),
              ),
            ]));
  }
}
