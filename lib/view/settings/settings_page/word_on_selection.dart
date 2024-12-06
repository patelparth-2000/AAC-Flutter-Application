import 'package:flutter/material.dart';

import '../../../util/app_color_constants.dart';
import '../radio_button.dart';

class WordOnSelection extends StatefulWidget {
  const WordOnSelection({super.key});

  @override
  State<WordOnSelection> createState() => _WordOnSelectionState();
}

class _WordOnSelectionState extends State<WordOnSelection> {
  List<RadioButtonModel> radioList = [
    RadioButtonModel(name: "Don't enlarge"),
    RadioButtonModel(name: "Enlarge slowly"),
    RadioButtonModel(name: "Enlarge st normal speed", select: true),
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
