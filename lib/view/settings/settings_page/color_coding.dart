import 'package:flutter/material.dart';

import '../../../util/app_color_constants.dart';
import '../radio_button.dart';

class ColorCoding extends StatefulWidget {
  const ColorCoding({super.key});

  @override
  State<ColorCoding> createState() => _ColorCodingState();
}

class _ColorCodingState extends State<ColorCoding> {
  List<RadioButtonModel> radioList = [
    RadioButtonModel(name: "Don't Colour code"),
    RadioButtonModel(name: "Colour code background", select: true),
    RadioButtonModel(name: "colour code stripe"),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(15),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text("Colour Codings Settings",
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
