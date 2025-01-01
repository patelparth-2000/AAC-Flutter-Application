import 'package:avaz_app/view/settings/setting_widget.dart';
import 'package:avaz_app/view/settings/title_widget.dart';
import 'package:flutter/material.dart';

import '../../../services/data_base_service.dart';
import '../../../util/app_color_constants.dart';
import '../radio_button.dart';
import '../setting_model/picture_appearance_setting_model.dart';

// ignore: must_be_immutable
class SideNavigationBar extends StatefulWidget {
  SideNavigationBar(
      {super.key,
      required this.dataBaseService,
      this.pictureAppearanceSettingModel,
      required this.refreshSettingData});
  final DataBaseService dataBaseService;
  PictureAppearanceSettingModel? pictureAppearanceSettingModel;
  final Function() refreshSettingData;
  @override
  State<SideNavigationBar> createState() => _SideNavigationBarState();
}

class _SideNavigationBarState extends State<SideNavigationBar> {
  List<RadioButtonModel> radioList = [
    RadioButtonModel(name: "Go Back"),
    RadioButtonModel(name: "Home"),
    RadioButtonModel(name: "Quick"),
    RadioButtonModel(name: "Core Words"),
    RadioButtonModel(name: "Next Page"),
    RadioButtonModel(name: "Previous Page"),
    RadioButtonModel(name: "Search Words"),
    RadioButtonModel(name: "Alert"),
    RadioButtonModel(name: "I Made A Mistake"),
  ];

  List<String> sideNavigtion = ["Left", "Right"];
  int initialLabelIndexSide = 0;

  void radioData(String value) {
    value = value.toLowerCase().replaceAll(" ", "_");
    List<String> sideButton = value.split(",");
    for (var item in radioList) {
      for (var side in sideButton) {
        if (item.name.toLowerCase().replaceAll(" ", "_") == side) {
          item.select = true;
        }
      }
    }
    widget.pictureAppearanceSettingModel!.sideNavigationBarButton = value;
    widget.dataBaseService
        .pictureAppearanceSettingUpdate(widget.pictureAppearanceSettingModel!);
    setState(() {});
    widget.refreshSettingData();
  }

  void sideNavigation() {
    String currentTextPosition =
        widget.pictureAppearanceSettingModel!.sideNavigationBarPosition!;
    initialLabelIndexSide = sideNavigtion.indexWhere((element) =>
        element.toLowerCase().replaceAll(" ", "_") == currentTextPosition);
    if (initialLabelIndexSide == -1) initialLabelIndexSide = 0;
  }

  @override
  void initState() {
    super.initState();
    sideNavigation();
    radioData(widget.pictureAppearanceSettingModel!.sideNavigationBarButton!);
  }

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
                        switchValue: widget
                            .pictureAppearanceSettingModel!.sideNavigationBar!,
                        onSwitchChanged: (value) {
                          widget.pictureAppearanceSettingModel!
                              .sideNavigationBar = value;
                          widget.dataBaseService.pictureAppearanceSettingUpdate(
                              widget.pictureAppearanceSettingModel!);
                          widget.refreshSettingData();
                          setState(() {});
                        },
                      ),
                      if (widget
                          .pictureAppearanceSettingModel!.sideNavigationBar!)
                        SettingWidget(
                          text: "Side navigation bar position",
                          isToggle: true,
                          initialLabelIndex: initialLabelIndexSide,
                          togglelabels: sideNavigtion,
                          onToggleChanged: (index) {
                            initialLabelIndexSide = index!;
                            String selectedData = sideNavigtion[index]
                                .toLowerCase()
                                .replaceAll(" ", "_");
                            widget.pictureAppearanceSettingModel!
                                .sideNavigationBarPosition = selectedData;
                            widget.dataBaseService
                                .pictureAppearanceSettingUpdate(
                                    widget.pictureAppearanceSettingModel!);
                            widget.refreshSettingData();
                            setState(() {});
                          },
                        ),
                      if (widget
                          .pictureAppearanceSettingModel!.sideNavigationBar!)
                        const TitleWidget(text: "CHOOSE ATLEAST 4 BUTTONS"),
                      if (widget
                          .pictureAppearanceSettingModel!.sideNavigationBar!)
                        RadioButton(
                            flex: 0,
                            physics: const NeverScrollableScrollPhysics(),
                            isMultipal: true,
                            onTap: (value) {
                              radioData(value);
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
