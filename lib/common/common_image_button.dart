import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:avaz_app/util/app_color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../view/settings/setting_model/touch_setting.dart';
import '../view/settings/settings_page/touch_accommodation.dart';
import 'common.dart';

class CommonImageButton extends StatefulWidget {
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
    this.textheight,
    this.textwidth,
    this.width,
    this.backgroundColor = AppColorConstants.imageTextButtonColor,
    this.borderColor = AppColorConstants.imageTextButtonColor,
    this.buttonIconColor = AppColorConstants.imageTextColor,
    this.buttonTextColor = AppColorConstants.imageTextColor,
    this.isHorizontal = false,
    this.isImageShow = false,
    this.isImageAsset = true,
    this.isTextShow = true,
    this.iscolorChange = true,
    this.isSpeak = false,
    this.isLongPress = false,
    this.isLongTap = false,
    this.buttonImage,
    this.borderRadius,
    this.text,
    this.slug,
    this.type,
    this.itemId,
    this.rowNumber,
    this.flutterTts,
    this.onAdd,
    this.changeTable,
    this.betweenGap,
    this.fontWeight = FontWeight.normal,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.fontSize,
    this.textPostion = "below",
    this.voiceFile,
    this.playAudio,
    this.stopAudio,
    this.onLongTap,
    this.touchSettingModel,
    this.pinValue,
  });
  final double? vertical;
  final double? horizontal;
  final double? imageSize;
  final double? height;
  final double? textheight;
  final double? textwidth;
  final double? width;
  final double? betweenGap;
  final double? fontSize;
  final BorderRadiusGeometry? borderRadius;
  final TextStyle? textStyle;
  final String? buttonName;
  final String? buttonImage;
  final String? voiceFile;
  final IconData? buttonIcon;
  final Color? buttonIconColor;
  final Color buttonTextColor;
  final Color backgroundColor;
  final Color borderColor;
  final bool isHorizontal;
  final bool isImageShow;
  final bool isImageAsset;
  final bool isTextShow;
  final bool iscolorChange;
  final bool isSpeak;
  final bool isLongPress;
  final bool isLongTap;
  final String? text;
  final String? slug;
  final String? type;
  final String? itemId;
  final int? rowNumber;
  final int? pinValue;
  final String textPostion;
  final FontWeight fontWeight;
  final FlutterTts? flutterTts;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final Function(String text, String? image, {String? audioFile})? onAdd;
  final Function(String slug)? changeTable;
  final Function()? onTap;
  final Function()? stopAudio;
  final Function(int? id, {int? rowNumber, int? pinValue})? onLongTap;
  final TouchSettingModel? touchSettingModel;
  // final AudioPlayer? player;
  final Function(String audioPath)? playAudio;

  @override
  State<CommonImageButton> createState() => _CommonImageButtonState();
}

class _CommonImageButtonState extends State<CommonImageButton> {
  String? audioPath;
  bool isButtonClick = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      isButtonClick = true;
    });
  }

  void _handleTapUp(TapUpDetails details) async {
    if (widget.touchSettingModel!.enableTouch! &&
        widget.touchSettingModel!.holdDuration!) {
      Future.delayed(Duration(
        milliseconds:
            (double.parse(widget.touchSettingModel!.durationLimit!) * 1000)
                .toInt(),
      )).whenComplete(() {
        isButtonClick = false;
        setState(() {});
      });
    } else {
      isButtonClick = false;
      setState(() {});
    }

    if (widget.stopAudio != null) {
      await widget.stopAudio!();
    }

    Future.delayed(widget.touchSettingModel!.enableTouch! &&
                widget.touchSettingModel!.holdDuration!
            ? Duration(
                milliseconds:
                    (double.parse(widget.touchSettingModel!.durationLimit!) *
                            1000)
                        .toInt(),
              )
            : const Duration(seconds: 0))
        .whenComplete(() {
      if (widget.voiceFile != null && widget.voiceFile!.isNotEmpty) {
        // Play audio file if voiceFile is provided
        audioPath = widget.voiceFile; // Set the audioPath to the voiceFile
        widget.onTap!();
        widget.playAudio!(audioPath!);
        // await playAudio(); // Play the audio
      } else if (widget.text != null &&
          widget.flutterTts != null &&
          widget.isSpeak) {
        // Speak text only if voiceFile is null
        speckbutton();
      } else {
        // Default onTap behavior
        if (widget.onTap != null) {
          widget.onTap!();
        }
        if (widget.changeTable != null) {
          Future.delayed(const Duration(milliseconds: 50)).whenComplete(() {
            widget.changeTable!(widget.slug!);
          });
        }
      }
    });
  }

  void speckbutton() async {
    if (widget.type != null && widget.type != "voice" && widget.slug != null) {
      speakToText(widget.text!, widget.flutterTts!);
      Future.delayed(const Duration(milliseconds: 50)).whenComplete(() {
        widget.changeTable!(widget.slug!);
      });
    } else {
      // ignore: avoid_print
      print("text == > ${widget.text}");
      speakToText(widget.text!, widget.flutterTts!);
      if (widget.onTap != null) {
        widget.onTap!();
      }
    }
  }

  void _handleTapCancel() {
    if (widget.touchSettingModel!.enableTouch! &&
        widget.touchSettingModel!.holdDuration!) {
      Future.delayed(Duration(
        milliseconds:
            (double.parse(widget.touchSettingModel!.durationLimit!) * 1000)
                .toInt(),
      )).whenComplete(() {
        isButtonClick = false;
        setState(() {});
      });
    } else {
      isButtonClick = false;
      setState(() {});
    }
  }

  void _startBackspace() {
    if (widget.isLongTap) {
      if (widget.onLongTap != null) {
        widget.onLongTap!(int.parse(widget.itemId.toString()),
            rowNumber: widget.rowNumber, pinValue: widget.pinValue);
      }
    } else if (widget.isLongPress) {
      _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        if (widget.onTap != null) {
          widget.onTap!();
        }
      });
    }
  }

  void _stopBackspace() {
    if (widget.isLongPress) {
      _timer?.cancel();
      _timer = null;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: widget.onTap,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onLongPress:
          widget.isLongPress || widget.isLongTap ? _startBackspace : null,
      onLongPressUp:
          widget.isLongPress || widget.isLongTap ? _stopBackspace : null,
      child: Container(
        height: widget.height,
        width: widget.width,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        decoration: BoxDecoration(
            border: Border.all(color: widget.borderColor, width: 2),
            color: widget.backgroundColor,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(5)),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: widget.horizontal ?? 5,
                  vertical: widget.vertical ?? 5),
              child: widget.isHorizontal
                  ? Center(
                      child: Row(
                        crossAxisAlignment: widget.crossAxisAlignment,
                        mainAxisAlignment: widget.mainAxisAlignment,
                        children: [
                          if (widget.buttonIcon != null)
                            Icon(
                              widget.buttonIcon,
                              color: widget.buttonIconColor,
                              size: widget.imageSize,
                            ),
                          if (widget.buttonImage != null)
                            if (widget.isImageAsset)
                              Image.asset(
                                widget.buttonImage!,
                                color: widget.buttonIconColor,
                                height: widget.imageSize,
                                width: widget.imageSize,
                              )
                            else
                              Image.file(
                                File(widget.buttonImage!),
                                color: widget.buttonIconColor,
                                height: widget.imageSize,
                                width: widget.imageSize,
                              ),
                          SizedBox(
                            width: widget.betweenGap ?? 3,
                          ),
                          if (widget.buttonName != null)
                            SizedBox(
                              height: widget.textheight,
                              width: widget.textwidth,
                              child: Center(
                                child: AutoSizeText(
                                  widget.buttonName!, // The text to display
                                  style: widget.textStyle ??
                                      TextStyle(
                                          color: widget.buttonTextColor,
                                          fontWeight: widget.fontWeight,
                                          fontSize: widget.fontSize ??
                                              14), // Default font size if not provided
                                  maxLines: 2, // Limit to a single line
                                  minFontSize:
                                      10, // Minimum font size when text is too long
                                  overflow: TextOverflow
                                      .ellipsis, // Adds "..." if text overflows
                                ),
                              ),
                            )
                          // Text(
                          //   "${widget.buttonName}",
                          //   style: widget.textStyle ??
                          //       TextStyle(
                          //           color: widget.buttonTextColor,
                          //           fontWeight: widget.fontWeight,
                          //           fontSize: widget.fontSize),
                          // )
                        ],
                      ),
                    )
                  : Center(
                      child: Column(
                        crossAxisAlignment: widget.crossAxisAlignment,
                        mainAxisAlignment: widget.mainAxisAlignment,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.buttonName != null &&
                              widget.isTextShow &&
                              widget.textPostion == "above")
                            AutoSizeText(
                              widget.buttonName!, // The text to display
                              style: widget.textStyle ??
                                  TextStyle(
                                      color: widget.buttonTextColor,
                                      fontWeight: widget.fontWeight,
                                      fontSize: widget.fontSize ??
                                          14), // Default font size if not provided
                              maxLines: 1, // Limit to a single line
                              minFontSize:
                                  10, // Minimum font size when text is too long
                              overflow: TextOverflow
                                  .ellipsis, // Adds "..." if text overflows
                            ),
                          if (widget.buttonIcon != null && widget.isImageShow)
                            Icon(
                              widget.buttonIcon,
                              color: widget.buttonIconColor,
                              size: widget.imageSize,
                            ),
                          if (widget.buttonImage != null && widget.isImageShow)
                            if (widget.isImageAsset)
                              Image.asset(
                                widget.buttonImage!,
                                color: widget.buttonIconColor,
                                height: widget.imageSize,
                                width: widget.imageSize,
                              )
                            else
                              Image.file(
                                File(widget.buttonImage!),
                                color: widget.buttonIconColor,
                                height: widget.imageSize,
                                width: widget.imageSize,
                              ),
                          SizedBox(
                            width: widget.betweenGap ?? 0,
                          ),
                          if (widget.buttonName != null &&
                              widget.isTextShow &&
                              widget.textPostion == "below")
                            AutoSizeText(
                              widget.buttonName!, // The text to display
                              style: widget.textStyle ??
                                  TextStyle(
                                      color: widget.buttonTextColor,
                                      fontWeight: widget.fontWeight,
                                      fontSize: widget.fontSize ??
                                          14), // Default font size if not provided
                              maxLines: 1, // Limit to a single line
                              minFontSize:
                                  10, // Minimum font size when text is too long
                              overflow: TextOverflow
                                  .ellipsis, // Adds "..." if text overflows
                            )
                          // Text(
                          //   "${widget.buttonName}",
                          //   style: widget.textStyle ??
                          //       TextStyle(
                          //           color: widget.buttonTextColor,
                          //           fontWeight: widget.fontWeight,
                          //           fontSize: widget.fontSize),
                          // )
                        ],
                      ),
                    ),
            ),
            if (widget.pinValue != null && widget.pinValue == 1)
              const Align(
                alignment: Alignment.topRight,
                child: Icon(
                  Icons.push_pin_rounded,
                  color: AppColorConstants.blue80,
                  size: 15,
                ),
              ),
            Container(
                width: isButtonClick ? widget.width : 0,
                height: isButtonClick ? widget.height : 0,
                padding: widget.touchSettingModel!.enableTouch!
                    ? const EdgeInsets.all(10)
                    : const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_usedecoration: BoxDecoration(
                  borderRadius: widget.touchSettingModel!.enableTouch!
                      ? BorderRadius.circular(
                          double.parse(widget.touchSettingModel!.borderRadius!))
                      : widget.borderRadius ?? BorderRadius.circular(5),
                  border: widget.touchSettingModel!.enableTouch!
                      ? Border.all(
                          width: double.parse(
                              widget.touchSettingModel!.borderThickness!),
                          color: colorchange(widget.touchSettingModel),
                        )
                      : null,
                  color: widget.touchSettingModel!.enableTouch!
                      ? null
                      // ignore: deprecated_member_use
                      : Colors.amber.withOpacity(0.7),
                )),
          ],
        ),
      ),
    );
  }
}
