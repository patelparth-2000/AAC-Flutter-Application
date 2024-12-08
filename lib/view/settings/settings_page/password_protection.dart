import 'package:flutter/material.dart';

import '../../../services/data_base_service.dart';
import '../../../util/app_color_constants.dart';
import '../setting_model.dart/general_setting.dart';
import '../setting_widget.dart';

// ignore: must_be_immutable
class PasswordProtection extends StatefulWidget {
PasswordProtection(
      {super.key, this.generalSettingModel, required this.dataBaseService});
  final DataBaseService dataBaseService;
  GeneralSettingModel? generalSettingModel;
  @override
  State<PasswordProtection> createState() => _PasswordProtectionState();
}

class _PasswordProtectionState extends State<PasswordProtection> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(15),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text("Password Protection Settings",
                  style: TextStyle(
                      color: AppColorConstants.buttonColorBlue2,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: const SettingWidget(
                  text: "Set password",
                  isArrow: false,
                ),
              ),
            ]));
  }
}
