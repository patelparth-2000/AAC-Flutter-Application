import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:avaz_app/util/app_color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

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
    this.isSpeak = true,
    this.buttonImage,
    this.borderRadius,
    this.text,
    this.slug,
    this.type,
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
  });
  final double? vertical;
  final double? horizontal;
  final double? imageSize;
  final double? height;
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
  final String? text;
  final String? slug;
  final String? type;
  final String textPostion;
  final FontWeight fontWeight;
  final FlutterTts? flutterTts;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final Function(String text, String? image, {String? audioFile})? onAdd;
  final Function(String slug)? changeTable;
  final Function()? onTap;
  final Function()? stopAudio;
  // final AudioPlayer? player;
  final Function(String audioPath)? playAudio;

  @override
  State<CommonImageButton> createState() => _CommonImageButtonState();
}

class _CommonImageButtonState extends State<CommonImageButton> {
  late Color _currentBackgroundColor;
  String? audioPath;

  @override
  void initState() {
    super.initState();
    _currentBackgroundColor = widget.backgroundColor;
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _currentBackgroundColor = Colors.amber.withOpacity(0.7); // Hover effect
    });
  }

  // void _handleTapUp(TapUpDetails details) {
  //   setState(() {
  //     _currentBackgroundColor = widget.backgroundColor; // Reset on release
  //   });
  //   if (widget.text != null && widget.flutterTts != null) {
  //     speckbutton();
  //   } else {
  //     if (widget.onTap != null) {
  //       widget.onTap!();
  //     }
  //   }
  // }

  void _handleTapUp(TapUpDetails details) async {
    setState(() {
      _currentBackgroundColor = widget.backgroundColor; // Reset on release
    });

    if (widget.stopAudio != null) {
      await widget.stopAudio!();
    }

    if (widget.voiceFile != null && widget.voiceFile!.isNotEmpty) {
      // Play audio file if voiceFile is provided
      audioPath = widget.voiceFile; // Set the audioPath to the voiceFile
      widget.onTap!();
      widget.playAudio!(audioPath!);
      // await playAudio(); // Play the audio
    } else if (widget.text != null && widget.flutterTts != null) {
      // Speak text only if voiceFile is null
      speckbutton();
    } else {
      // Default onTap behavior
      if (widget.onTap != null) {
        widget.onTap!();
      }
    }
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
    setState(() {
      _currentBackgroundColor = widget.backgroundColor; // Reset if canceled
    });
  }

  // Future<void> playAudio() async {
  //   try {
  //     // Always stop the current audio
  //     await player.stop();

  //     // Play the new audio if the path is not null
  //     if (audioPath != null) {
  //       await player.play(DeviceFileSource(audioPath!));
  //     }
  //   } catch (e) {
  //     // ignore: avoid_print
  //     print("Error playing audio: $e");
  //   }
  // }

  // Future<void> stopAudio() async {
  //   if (player.state == PlayerState.playing) {
  //     await player.stop();
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
    // player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: widget.onTap,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: Container(
        height: widget.height,
        width: widget.width,
        padding: EdgeInsets.symmetric(
            horizontal: widget.horizontal ?? 5, vertical: widget.vertical ?? 5),
        decoration: BoxDecoration(
            border: Border.all(color: widget.borderColor, width: 2),
            color: widget.iscolorChange
                ? _currentBackgroundColor
                : widget.backgroundColor,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(5)),
        child: widget.isHorizontal
            ? Row(
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
                      overflow:
                          TextOverflow.ellipsis, // Adds "..." if text overflows
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
              )
            : Column(
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
                      overflow:
                          TextOverflow.ellipsis, // Adds "..." if text overflows
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
                      overflow:
                          TextOverflow.ellipsis, // Adds "..." if text overflows
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
    );
  }
}
