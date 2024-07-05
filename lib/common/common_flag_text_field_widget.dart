import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../util/app_color_constants.dart';

class CommonFlagTextFieldWidget extends StatelessWidget {
  const CommonFlagTextFieldWidget(
      {super.key,
      required this.focusNode,
      this.hintText,
      this.labelText,
      this.textFieldHeight,
      this.textFieldStyle,
      this.fontSize,
      this.vertical,
      this.horizontal,
      this.focusedBorder,
      this.enabledBorder,
      required this.controller,
      this.keyboardType,
      this.onChanged,
      this.languageCode = "IN",
      this.onCountryChanged,
      this.initialCountryCode = "IN"});
  final TextEditingController controller;
  final ValueChanged<PhoneNumber>? onChanged;
  final ValueChanged<Country>? onCountryChanged;
  final FocusNode focusNode;
  final TextStyle? textFieldStyle;
  final String languageCode;
  final String initialCountryCode;
  final String? hintText;
  final String? labelText;
  final double? textFieldHeight;
  final double? fontSize;
  final double? vertical;
  final double? horizontal;
  final OutlineInputBorder? focusedBorder;
  final OutlineInputBorder? enabledBorder;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: textFieldHeight ?? 40.0,
      child: IntlPhoneField(
        style: textFieldStyle ??
            TextStyle(
              fontSize: fontSize ?? 14.0, // Adjust the font size as needed
              height: 1.6,
              color: AppColorConstants.black,
            ),
        cursorHeight: 20,
        cursorColor: AppColorConstants.blue100,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: keyboardType ?? TextInputType.phone,
        controller: controller,
        focusNode: focusNode,
        invalidNumberMessage: null,
        initialCountryCode: initialCountryCode,
        pickerDialogStyle: PickerDialogStyle(
            backgroundColor: AppColorConstants.baseBG,
            padding: const EdgeInsets.all(10),
            listTilePadding: const EdgeInsets.symmetric(horizontal: 10),
            countryNameStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            countryCodeStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColorConstants.baseBG,
          focusColor: AppColorConstants.baseBG,
          enabledBorder: enabledBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: AppColorConstants.black),
              ),
          contentPadding: EdgeInsets.symmetric(
            vertical: vertical ?? 8.0, // Adjust the vertical padding as needed
            horizontal: horizontal ?? 10.0,
          ),
          focusedBorder: focusedBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: AppColorConstants.blue100),
              ),
          counterText: "",
          error: null,
          errorText: null,
          labelText: labelText,
          labelStyle: const TextStyle(
            color: AppColorConstants.contentSecondary,
            fontSize: 14.0,
            fontWeight: FontWeight.normal,
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
            color: AppColorConstants.contentSecondary,
            fontSize: 14.0,
            fontWeight: FontWeight.normal,
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(),
          ),
        ),
        languageCode: languageCode,
        onChanged: onChanged,
        onCountryChanged: onCountryChanged,
      ),
    );
  }
}
