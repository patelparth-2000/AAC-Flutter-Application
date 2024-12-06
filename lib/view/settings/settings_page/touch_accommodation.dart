import 'package:avaz_app/view/settings/setting_widget.dart';
import 'package:flutter/material.dart';

import '../../../util/app_color_constants.dart';

class TouchAccommodation extends StatefulWidget {
  const TouchAccommodation({super.key});

  @override
  State<TouchAccommodation> createState() => _TouchAccommodationState();
}

class _TouchAccommodationState extends State<TouchAccommodation> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(15),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text("Touch Accommodations Settings",
                  style: TextStyle(
                      color: AppColorConstants.buttonColorBlue2,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 20,
              ),
              SettingWidget(
                text: "Enable Touch Accommodations",
                isSwitch: true,
                switchValue: false,
                onSwitchChanged: (value) {},
              )
            ]));
  }
}
