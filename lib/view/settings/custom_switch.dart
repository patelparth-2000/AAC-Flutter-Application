import 'package:avaz_app/util/app_color_constants.dart';
import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({super.key, required this.value, required this.onChanged});

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 40.0,
        height: 20.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: widget.value ? AppColorConstants.blue60 : Colors.grey,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment:
              widget.value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20.0,
            height: 20.0,
            decoration: const BoxDecoration(
              color: AppColorConstants.imageTextButtonColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
