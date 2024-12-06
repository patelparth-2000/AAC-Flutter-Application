import 'package:flutter/material.dart';

import '../../../util/app_color_constants.dart';
import '../setting_widget.dart';
import '../title_widget.dart';

class Grammar extends StatefulWidget {
  const Grammar({super.key});

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
              switchValue: false,
              onSwitchChanged: (value) {},
            ),
            SettingWidget(
              text: "Show Word froms in Picture Grid",
              isSwitch: true,
              switchValue: true,
              onSwitchChanged: (value) {},
            ),
          ],
        ));
  }
}
