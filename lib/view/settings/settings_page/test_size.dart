import 'package:avaz_app/util/app_color_constants.dart';
import 'package:flutter/material.dart';

import '../radio_button.dart';

class TestSize extends StatefulWidget {
  const TestSize({super.key});

  @override
  State<TestSize> createState() => _TestSizeState();
}

class _TestSizeState extends State<TestSize> {
  List<RadioButtonModel> radioList = [
    RadioButtonModel(name: "No text (only picture)"),
    RadioButtonModel(name: "Small"),
    RadioButtonModel(name: "Medium", select: true),
    RadioButtonModel(name: "Large"),
    RadioButtonModel(name: "Only text (no picture)"),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(15),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text("Pictures Per Screen (Grid Size)",
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
