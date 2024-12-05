import 'package:avaz_app/view/settings/custom_switch.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../util/app_color_constants.dart';

class SettingWidget extends StatelessWidget {
  const SettingWidget(
      {super.key,
      required this.text,
      this.isSwitch = false,
      this.isToggle = false,
      this.onSwitchChanged,
      this.onToggleChanged,
      this.switchValue = false,
      this.initialLabelIndex,
      this.onTap});
  final String text;
  final bool isSwitch;
  final bool isToggle;
  final ValueChanged<bool>? onSwitchChanged;
  final OnToggle? onToggleChanged;
  final bool switchValue;
  final int? initialLabelIndex;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            if (isSwitch)
              CustomSwitch(value: switchValue, onChanged: onSwitchChanged!)
            else if (isToggle)
              ToggleSwitch(
                minWidth: 55.0,
                minHeight: 25.0,
                fontSize: 10.0,
                initialLabelIndex: initialLabelIndex,
                activeBgColor: const [AppColorConstants.imageTextButtonColor],
                activeFgColor: AppColorConstants.white,
                inactiveBgColor: AppColorConstants.white,
                inactiveFgColor: AppColorConstants.imageTextButtonColor,
                totalSwitches: 2,
                cornerRadius: 2,
                dividerMargin: 0,
                labels: const ['Above', 'Below'],
                onToggle: onToggleChanged,
              )
            else
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AppColorConstants.imageTextButtonColor,
              ),
          ],
        ),
      ),
    );
  }
}
