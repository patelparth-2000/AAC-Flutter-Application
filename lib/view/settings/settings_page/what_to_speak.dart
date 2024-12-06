import 'package:flutter/material.dart';

import '../../../util/app_color_constants.dart';
import '../radio_button.dart';

class WhatToSpeak extends StatefulWidget {
  const WhatToSpeak({super.key});

  @override
  State<WhatToSpeak> createState() => _WhatToSpeakState();
}

class _WhatToSpeakState extends State<WhatToSpeak> {
  List<RadioButtonModel> radioList = [
    RadioButtonModel(name: "Speak Everything", select: true),
    RadioButtonModel(name: "Speak Words"),
    RadioButtonModel(name: "Speak only message box"),
  ];
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
                  onTap: () {
                    setState(() {});
                  },
                  radioList: radioList),
            ]));
  }
}
