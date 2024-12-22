import 'package:avaz_app/view/editwords/edit_words_screen.dart';
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
      this.items = const [],
      this.dropDownOnChanged,
      this.isColorPicker = false,
      this.colorPicker,
      this.onTap});
  final TextEditingController? controller;
  final ValueChanged<String?>? onChanged;
  final ValueChanged<DropDownModel?>? dropDownOnChanged;
  final String hintText;
  final String text;
  final bool isTextField;
  final bool isColorPicker;
  final Color? colorPicker;
  final DropDownModel? value;
  final List<DropDownModel> items;
  final Function()? onTap;

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
            textFieldHeight: 38,
            controller: controller!,
            hintText: hintText,
            onChanged: onChanged,
          )
        else if (isColorPicker)
          InkWell(
            onTap: onTap,
            child: Container(
              width: 250,
              height: 35,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  color: AppColorConstants.white,
                  border: Border.all(color: AppColorConstants.black),
                  borderRadius: BorderRadius.circular(5)),
              child: colorPicker != null
                  ? Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      color: colorPicker,
                    )
                  : Text(
                      hintText,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
                color: AppColorConstants.white,
                border: Border.all(color: AppColorConstants.black),
                borderRadius: BorderRadius.circular(5)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<DropDownModel>(
                isExpanded: false,
                hint: Text(
                  hintText,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                items: items
                    .map(
                        (DropDownModel item) => DropdownMenuItem<DropDownModel>(
                              value: item,
                              child: Text(
                                item.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ))
                    .toList(),
                value: value,
                onChanged: dropDownOnChanged,
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
