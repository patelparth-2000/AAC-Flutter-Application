import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class CommonTextToSpeak extends StatefulWidget {
  const CommonTextToSpeak(
      {super.key,
      required this.text,
      required this.child,
      required this.flutterTts,
      required this.onTap});
  final String text;
  final Widget child;
  final FlutterTts flutterTts;
  final Function() onTap;

  @override
  State<CommonTextToSpeak> createState() => _CommonTextToSpeakState();
}

class _CommonTextToSpeakState extends State<CommonTextToSpeak> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> speakToText(String text) async {
    if (text.isNotEmpty) {
      await widget.flutterTts.speak(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // ignore: avoid_print
        print("text == > ${widget.text}");
        speakToText(widget.text);
        widget.onTap();
      },
      child: widget.child,
    );
  }

  @override
  void dispose() {
    widget.flutterTts.stop();
    super.dispose();
  }
}
