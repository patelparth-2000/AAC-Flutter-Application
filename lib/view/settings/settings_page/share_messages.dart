import 'package:flutter/material.dart';

import '../../../services/data_base_service.dart';
import '../../../util/app_color_constants.dart';
import '../radio_button.dart';
import '../setting_model.dart/general_setting.dart';
import '../setting_widget.dart';

// ignore: must_be_immutable
class ShareMessages extends StatefulWidget {
  ShareMessages(
      {super.key, this.generalSettingModel, required this.dataBaseService});
  final DataBaseService dataBaseService;
  GeneralSettingModel? generalSettingModel;
  @override
  State<ShareMessages> createState() => _ShareMessagesState();
}

class _ShareMessagesState extends State<ShareMessages> {
  List<RadioButtonModel> radioList = [
    RadioButtonModel(name: "Image", select: true),
    RadioButtonModel(name: "Text"),
  ];

  void radioData(String value) {
    value = value.toLowerCase().replaceAll(" ", "_");
    for (var item in radioList) {
      item.select = item.name.toLowerCase().replaceAll(" ", "_") == value;

      if (item.select) {
        widget.generalSettingModel!.shareMassageType = value;
        widget.dataBaseService
            .generalSettingUpdate(widget.generalSettingModel!);
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    radioData(widget.generalSettingModel!.shareMassageType!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(15),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text("Share Settings",
                  style: TextStyle(
                      color: AppColorConstants.buttonColorBlue2,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: SettingWidget(
                  text: "Share Messages",
                  isSwitch: true,
                  switchValue: widget.generalSettingModel!.shareMassage!,
                  onSwitchChanged: (value) {
                    widget.generalSettingModel!.shareMassage = value;
                    widget.dataBaseService
                        .generalSettingUpdate(widget.generalSettingModel!);
                    setState(() {});
                  },
                ),
              ),
              RadioButton(
                  onTap: (value) {
                    radioData(value);
                    setState(() {});
                  },
                  radioList: radioList),
            ]));
  }
}
