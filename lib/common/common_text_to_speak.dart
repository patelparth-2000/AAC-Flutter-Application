import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'common.dart';

class CommonTextToSpeak extends StatefulWidget {
  const CommonTextToSpeak(
      {super.key,
      this.slug,
      this.onAdd,
      this.type,
      required this.text,
      required this.child,
      required this.flutterTts,
      required this.onTap,
      this.changeTable});
  final String text;
  final String? slug;
  final String? type;
  final Widget child;
  final FlutterTts flutterTts;
  final Function(String text, String? image)? onAdd;
  final Function(String slug)? changeTable;
  final Function() onTap;

  @override
  State<CommonTextToSpeak> createState() => _CommonTextToSpeakState();
}

class _CommonTextToSpeakState extends State<CommonTextToSpeak> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.type != null &&
              widget.type != "voice" &&
              widget.slug != null
          ? () async {
              speakToText(widget.text, widget.flutterTts);
              Future.delayed(const Duration(milliseconds: 50)).whenComplete(() {
                widget.changeTable!(widget.slug!);
              });
            }
          : () {
              // ignore: avoid_print
              print("text == > ${widget.text}");
              speakToText(widget.text, widget.flutterTts);
              widget.onTap();
            },
      child: widget.child,
    );
  }
}
