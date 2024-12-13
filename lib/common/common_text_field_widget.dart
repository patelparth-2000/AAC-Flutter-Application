import 'package:flutter/material.dart';
import '../util/app_color_constants.dart';

class CommonTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final String? labelText;
  final String? prefixIcon;
  final Widget? suffixIcon;
  final TextStyle? textFieldStyle;
  final double? vertical;
  final double? horizontal;
  final Function()? onTap;
  final bool? readOnly;
  final bool isPrefixIConShow;
  final bool? enableInteractiveSelection;
  final OutlineInputBorder? focusedBorder;
  final OutlineInputBorder? enabledBorder;
  final TextInputType? keyboardType;
  final InputDecoration? decoration;
  final int? maxLines;
  final int? maxLength;
  final FocusNode? focusNode;
  final double? textFieldHeight;
  final double? textFieldiwidth;
  final double? fontSize;

  const CommonTextFieldWidget({
    super.key,
    required this.controller,
    this.onChanged,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.textFieldStyle,
    this.vertical,
    this.onTap,
    this.readOnly,
    this.focusedBorder,
    this.horizontal,
    this.enabledBorder,
    this.keyboardType,
    this.decoration,
    this.maxLines = 1,
    this.maxLength,
    this.enableInteractiveSelection,
    this.focusNode,
    this.isPrefixIConShow = false,
    this.textFieldHeight,
    this.textFieldiwidth,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: textFieldHeight ?? 40.0, // Adjust the height as needed
      width: textFieldiwidth,
      child: TextField(
        focusNode: focusNode,
        readOnly: readOnly ?? false,
        maxLines: maxLines,
        enableInteractiveSelection: enableInteractiveSelection ?? true,
        style: textFieldStyle ??
            TextStyle(
              fontSize: fontSize ?? 14.0, // Adjust the font size as needed
              height: 1.6,
              color: AppColorConstants.black,
            ),
        cursorHeight: 20,
        maxLength: maxLength,
        cursorColor: AppColorConstants.blue100,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: keyboardType ?? TextInputType.text,
        controller: controller,
        decoration: decoration ??
            InputDecoration(
              filled: true,
              fillColor: AppColorConstants.baseBG,
              focusColor: AppColorConstants.baseBG,
              enabledBorder: enabledBorder ??
                  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide:
                        const BorderSide(color: AppColorConstants.black),
                  ),
              contentPadding: EdgeInsets.symmetric(
                vertical:
                    vertical ?? 8.0, // Adjust the vertical padding as needed
                horizontal: horizontal ?? 10.0,
              ),
              focusedBorder: focusedBorder ??
                  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide:
                        const BorderSide(color: AppColorConstants.blue100),
                  ),
              prefixIcon: prefixIcon != null
                  ? isPrefixIConShow
                      ? Container(
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            padding: const EdgeInsets.all(0),
                            decoration: BoxDecoration(
                              color: AppColorConstants.blue10,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Image.asset(
                              "$prefixIcon",
                            ),
                          ),
                        )
                      : Image.asset(
                          "$prefixIcon",
                        )
                  : null,
              suffixIcon: suffixIcon,
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
            ),
        onChanged: onChanged,
        onTap: onTap,
      ),
    );
  }
}
