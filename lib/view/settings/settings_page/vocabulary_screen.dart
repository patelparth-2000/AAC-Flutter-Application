import 'package:flutter/material.dart';

import '../../../util/app_color_constants.dart';
import '../radio_button.dart';

class VocabularyScreen extends StatefulWidget {
  const VocabularyScreen({super.key});

  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  List<RadioButtonModel> radioList = [
    RadioButtonModel(name: "ROOT SCREEN", select: true),
    RadioButtonModel(name: "QUICK"),
    RadioButtonModel(name: "GETTING STARTED"),
    RadioButtonModel(name: "BASIC"),
    RadioButtonModel(name: "ADVANCED"),
    RadioButtonModel(name: "CORE WORDS"),
    RadioButtonModel(name: "OTHER LANGUAGES"),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(15),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text("Home Screen Vocabulary Settings",
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
