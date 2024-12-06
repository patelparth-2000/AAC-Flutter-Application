import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../util/app_color_constants.dart';
import '../util/app_constants.dart';

class CommonSystemUI {
  static SystemUiOverlayStyle systemStyle = const SystemUiOverlayStyle(
      statusBarColor: AppColorConstants.systemArea,
      systemNavigationBarColor: AppColorConstants.systemArea);
}

void scaffoldMessengerMessage(
    {required String message, required BuildContext context}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message,
        style: const TextStyle(
            color: Colors.black, fontFamily: AppConstants.fontFamilyNormal)),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.white,
    duration: const Duration(seconds: 2),
    margin: const EdgeInsets.all(10.0),
  ));
}

bool textFieldValidation(TextEditingController controller, String text,
    bool isSelect, BuildContext context) {
  if (controller.text.isEmpty) {
    scaffoldMessengerMessage(
        message: "${isSelect ? "Select" : "Enter"} $text", context: context);
    return false;
  }
  return true;
}

Future<void> speakToText(String text, final FlutterTts flutterTts) async {
  if (text.isNotEmpty) {
    await flutterTts.speak(text);
  }
}

Widget dividerWidget({double height = 1, Color? color}) {
  return Container(
    height: height,
    color: color ?? AppColorConstants.black,
  );
}
