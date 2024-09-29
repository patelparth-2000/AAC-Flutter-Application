import 'dart:io';

import 'package:avaz_app/util/app_color_constants.dart';
import 'package:flutter/material.dart';

class CommonImageButton extends StatelessWidget {
  const CommonImageButton({
    super.key,
    this.vertical,
    this.horizontal,
    this.imageSize,
    this.textStyle,
    this.onTap,
    this.buttonName,
    this.buttonIcon,
    this.height,
    this.width,
    this.backgroundColor = AppColorConstants.imageTextButtonColor,
    this.borderColor = AppColorConstants.imageTextButtonColor,
    this.buttonIconColor = AppColorConstants.imageTextColor,
    this.buttonTextColor = AppColorConstants.imageTextColor,
    this.isHorizontal = false,
    this.isImageShow = false,
    this.isImageAsset = true,
    this.isTextShow = true,
    this.buttonImage,
  });
  final double? vertical;
  final double? horizontal;
  final double? imageSize;
  final double? height;
  final double? width;
  final TextStyle? textStyle;
  final String? buttonName;
  final String? buttonImage;
  final IconData? buttonIcon;
  final Color? buttonIconColor;
  final Color buttonTextColor;
  final Color backgroundColor;
  final Color borderColor;
  final bool isHorizontal;
  final bool isImageShow;
  final bool isImageAsset;
  final bool isTextShow;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        padding: EdgeInsets.symmetric(
            horizontal: horizontal ?? 5, vertical: vertical ?? 5),
        decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: 2),
            color: backgroundColor,
            borderRadius: BorderRadius.circular(5)),
        child: isHorizontal
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (buttonIcon != null)
                    Icon(
                      buttonIcon,
                      color: buttonIconColor,
                      size: imageSize,
                    ),
                  if (buttonImage != null)
                    if (isImageAsset)
                      Image.asset(
                        buttonImage!,
                        color: buttonIconColor,
                        height: imageSize,
                        width: imageSize,
                      )
                    else
                      Image.file(
                        File(buttonImage!),
                        color: buttonIconColor,
                        height: imageSize,
                        width: imageSize,
                      ),
                  const SizedBox(
                    width: 3,
                  ),
                  if (buttonName != null)
                    Text(
                      "$buttonName",
                      style: textStyle ?? TextStyle(color: buttonTextColor),
                    )
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (buttonIcon != null && isImageShow)
                    Icon(
                      buttonIcon,
                      color: buttonIconColor,
                      size: imageSize,
                    ),
                  if (buttonImage != null && isImageShow)
                    if (isImageAsset)
                      Image.asset(
                        buttonImage!,
                        color: buttonIconColor,
                        height: imageSize,
                        width: imageSize,
                      )
                    else
                      Image.file(
                        File(buttonImage!),
                        color: buttonIconColor,
                        height: imageSize,
                        width: imageSize,
                      ),
                  if (buttonName != null && isTextShow)
                    Text(
                      "$buttonName",
                      style: textStyle ?? TextStyle(color: buttonTextColor),
                    )
                ],
              ),
      ),
    );
  }
}
