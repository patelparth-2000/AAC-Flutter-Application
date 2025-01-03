import 'package:flutter/material.dart';

import '../../../util/app_color_constants.dart';
import '../setting_widget.dart';
import '../title_widget.dart';

class AccSupport extends StatefulWidget {
  const AccSupport({super.key});

  @override
  State<AccSupport> createState() => _AccSupportState();
}

class _AccSupportState extends State<AccSupport> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(15),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Support",
                style: TextStyle(
                    color: AppColorConstants.buttonColorBlue2,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            SizedBox(
              height: 20,
            ),
            TitleWidget(
              text: "Touch Voz SUPPORT",
            ),
            SettingWidget(
              text: "Join Touch Voz User Group on WhatsApp",
              isArrow: false,
            ),
            SettingWidget(
              text: "View Touch Voz FAQs",
              isArrow: false,
            ),
            SettingWidget(
              text: "Contact us via WhatsApp",
              isArrow: false,
            ),
            SettingWidget(
              text: "Contact us via Email",
              isArrow: false,
            ),
          ],
        ));
  }
}
