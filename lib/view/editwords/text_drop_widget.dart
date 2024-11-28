import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../common/common_text_field_widget.dart';
import '../../util/app_color_constants.dart';

class TextDropWidget extends StatelessWidget {
  const TextDropWidget(
      {super.key,
      this.controller,
      this.onChanged,
      required this.hintText,
      required this.text,
      this.isTextField = false,
      this.value,
      this.items = const []});
  final TextEditingController? controller;
  final ValueChanged<String?>? onChanged;
  final String hintText;
  final String text;
  final bool isTextField;
  final String? value;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          alignment: Alignment.centerRight,
          width: 120,
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        if (isTextField)
          CommonTextFieldWidget(
            textFieldiwidth: 253,
            textFieldHeight: 35,
            controller: controller!,
            hintText: hintText,
            onChanged: onChanged,
          )
        else
          Container(
            decoration: BoxDecoration(
                color: AppColorConstants.white,
                border: Border.all(color: AppColorConstants.black),
                borderRadius: BorderRadius.circular(5)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: false,
                hint: Text(
                  hintText,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                items: items
                    .map((String item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ))
                    .toList(),
                value: value,
                onChanged: onChanged,
                buttonStyleData: const ButtonStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  height: 35,
                  width: 250,
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 35,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
