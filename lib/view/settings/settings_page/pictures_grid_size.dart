import 'package:avaz_app/view/settings/radio_button.dart';
import 'package:flutter/material.dart';

import '../../../util/app_color_constants.dart';

class PicturesGridSize extends StatefulWidget {
  const PicturesGridSize({super.key});

  @override
  State<PicturesGridSize> createState() => _PicturesGridSizeState();
}

class _PicturesGridSizeState extends State<PicturesGridSize> {
  List<RadioButtonModel> radioList = [
    RadioButtonModel(name: "Very Small (77 pictures)"),
    RadioButtonModel(name: "Small (60 pictures)"),
    RadioButtonModel(name: "Small (40 pictures)"),
    RadioButtonModel(name: "Small (24 pictures)", select: true),
    RadioButtonModel(name: "Normal (15 pictures)"),
    RadioButtonModel(name: "Large (8 pictures)"),
    RadioButtonModel(name: "Large (4 pictures)"),
    RadioButtonModel(name: "Large (3 pictures)"),
    RadioButtonModel(name: "Extra-Large (2 pictures)"),
    RadioButtonModel(name: "Huge (1 pictures)"),
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
