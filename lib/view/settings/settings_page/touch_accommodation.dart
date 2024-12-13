import 'package:avaz_app/view/settings/setting_model.dart/touch_setting.dart';
import 'package:avaz_app/view/settings/setting_widget.dart';
import 'package:flutter/material.dart';

import '../../../services/data_base_service.dart';
import '../../../util/app_color_constants.dart';

// ignore: must_be_immutable
class TouchAccommodation extends StatefulWidget {
  TouchAccommodation(
      {super.key,
      required this.dataBaseService,
      this.touchSettingModel,
      required this.refreshSettingData});
  final DataBaseService dataBaseService;
  TouchSettingModel? touchSettingModel;
  final Function() refreshSettingData;
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
                switchValue: widget.touchSettingModel!.enableTouch!,
                onSwitchChanged: (value) {
                  widget.touchSettingModel!.enableTouch = value;
                  widget.dataBaseService
                      .touchSettingUpdate(widget.touchSettingModel!);
                  setState(() {});
                  widget.refreshSettingData();
                },
              )
            ]));
  }
}
