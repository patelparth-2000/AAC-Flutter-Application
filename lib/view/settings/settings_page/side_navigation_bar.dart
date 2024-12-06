import 'package:avaz_app/view/settings/setting_widget.dart';
import 'package:avaz_app/view/settings/title_widget.dart';
import 'package:flutter/material.dart';

import '../../../util/app_color_constants.dart';
import '../radio_button.dart';

class SideNavigationBar extends StatefulWidget {
  const SideNavigationBar({super.key});

  @override
  State<SideNavigationBar> createState() => _SideNavigationBarState();
}

class _SideNavigationBarState extends State<SideNavigationBar> {
  List<RadioButtonModel> radioList = [
    RadioButtonModel(name: "Go Back", select: true),
    RadioButtonModel(name: "Home", select: true),
    RadioButtonModel(name: "Quick", select: true),
    RadioButtonModel(name: "Core Words"),
    RadioButtonModel(name: "Next Page", select: true),
    RadioButtonModel(name: "Previous Page", select: true),
    RadioButtonModel(name: "Search Words", select: true),
    RadioButtonModel(name: "Alert"),
    RadioButtonModel(name: "I Made A Mistake"),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text("Side Navigation Bar Settings",
                style: TextStyle(
                    color: AppColorConstants.buttonColorBlue2,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const TitleWidget(text: "CHANGE SIDE NAVIGATION BAR"),
                      SettingWidget(
                        text: "Side navigation bar",
                        isSwitch: true,
                        switchValue: true,
                        onSwitchChanged: (value) {},
                      ),
                      SettingWidget(
                        text: "Side navigation bar",
                        isToggle: true,
                        initialLabelIndex: 1,
                        togglelabels: const ["Left", "Right"],
                        onToggleChanged: (index) {},
                      ),
                      const TitleWidget(text: "CHOOSE ATLEAST 4 BUTTONS"),
                      RadioButton(
                          flex: 0,
                          physics: const NeverScrollableScrollPhysics(),
                          isMultipal: true,
                          onTap: () {
                            setState(() {});
                          },
                          radioList: radioList),
                    ]),
              ),
            ),
          ],
        ));
  }
}
