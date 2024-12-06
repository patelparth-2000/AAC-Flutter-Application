import 'package:flutter/material.dart';

import '../../../util/app_color_constants.dart';
import '../radio_button.dart';

class KeysOnSelection extends StatefulWidget {
  const KeysOnSelection({super.key});

  @override
  State<KeysOnSelection> createState() => _KeysOnSelectionState();
}

class _KeysOnSelectionState extends State<KeysOnSelection> {
  List<RadioButtonModel> radioList = [
    RadioButtonModel(name: "Don't enlarge", select: true),
    RadioButtonModel(name: "Enlarge slowly"),
    RadioButtonModel(name: "Enlarge at normal speed"),
    RadioButtonModel(name: "Enlarge quickly"),
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
