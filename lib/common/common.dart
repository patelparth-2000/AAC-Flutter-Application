import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../util/app_color_constants.dart';
import '../util/app_constants.dart';
import '../util/dimensions.dart';
import '../view/editwords/edit_words_screen.dart';

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

String changeDateFormat(String datetime) {
  DateTime parsedDate = DateTime.parse(datetime);
  String formattedDate =
      DateFormat('dd-MMM-yyyy').format(parsedDate).toLowerCase();
  return formattedDate;
}

List<dynamic> gridList = [
  {
    "count": 77,
    "item": 11,
    "ratio": 1.3,
    "image": Dimensions.screenHeight * 0.05,
    "text": Dimensions.screenHeight * 0.01,
    "height": Dimensions.screenHeight * .14,
    "width": Dimensions.screenWidth * .08,
  },
  {
    "count": 60,
    "item": 10,
    "ratio": 1.3,
    "image": Dimensions.screenHeight * 0.05,
    "text": Dimensions.screenHeight * 0.01,
    "height": Dimensions.screenHeight * .15,
    "width": Dimensions.screenWidth * .09,
  },
  {
    "count": 40,
    "item": 8,
    "ratio": 1.3,
    "image": Dimensions.screenHeight * 0.08,
    "text": Dimensions.screenHeight * 0.03,
    "height": Dimensions.screenHeight * .2,
    "width": Dimensions.screenWidth * .12,
  },
  {
    "count": 24,
    "item": 6,
    "ratio": 1.3,
    "image": Dimensions.screenHeight * 0.1,
    "text": Dimensions.screenHeight * 0.05,
    "height": Dimensions.screenHeight * .26,
    "width": Dimensions.screenWidth * .16,
  },
  {
    "count": 15,
    "item": 5,
    "ratio": 1.3,
    "image": Dimensions.screenHeight * 0.1,
    "text": Dimensions.screenHeight * 0.05,
    "height": Dimensions.screenHeight * .31,
    "width": Dimensions.screenWidth * .19,
  },
  {
    "count": 8,
    "item": 4,
    "ratio": 1.2,
    "image": Dimensions.screenHeight * 0.2,
    "text": Dimensions.screenHeight * 0.07,
    "height": Dimensions.screenHeight * .4,
    "width": Dimensions.screenWidth * .24,
  },
  {
    "count": 4,
    "item": 2,
    "ratio": 2.4,
    "image": Dimensions.screenHeight * 0.2,
    "text": Dimensions.screenHeight * 0.07,
    "height": Dimensions.screenHeight * .45,
    "width": Dimensions.screenWidth * .45,
  },
  {
    "count": 3,
    "item": 3,
    "ratio": 0.8,
    "image": Dimensions.screenHeight * 0.3,
    "text": Dimensions.screenHeight * 0.1,
    "height": Dimensions.screenHeight * .8,
    "width": Dimensions.screenWidth * .32,
  },
  {
    "count": 2,
    "item": 2,
    "ratio": 1.2,
    "image": Dimensions.screenHeight * 0.3,
    "text": Dimensions.screenHeight * 0.1,
    "height": Dimensions.screenHeight * .8,
    "width": Dimensions.screenWidth * .45,
  },
  {
    "count": 1,
    "item": 1,
    "ratio": 2.4,
    "image": Dimensions.screenHeight * 0.3,
    "text": Dimensions.screenHeight * 0.1,
    "height": Dimensions.screenHeight * .8,
    "width": Dimensions.screenWidth * .9,
  },
];

String? colordata(Color? pickerColor) {
  if (pickerColor == null) {
    return null;
  }
//     String colorHex =
//     '#${(pickerColor.opacity * 255).round().toRadixString(16).padLeft(2, '0')}${(pickerColor.r * 255).round().toRadixString(16).padLeft(2, '0')}${(pickerColor.g * 255).round().toRadixString(16).padLeft(2, '0')}${(pickerColor.b * 255).round().toRadixString(16).padLeft(2, '0')}';
// print(colorHex);
  String colorHex =
      '#${(pickerColor.r * 255).round().toRadixString(16).padLeft(2, '0')}${(pickerColor.g * 255).round().toRadixString(16).padLeft(2, '0')}${(pickerColor.b * 255).round().toRadixString(16).padLeft(2, '0')}';
  return colorHex;
}

Color hexToBordorColorCommon(String hexString) {
  Color color = AppColorConstants.keyBoardBackColor;
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  color = Color(int.parse(buffer.toString(), radix: 16));
  return color;
}

List<DropDownColorModel> colorDropList = [
  DropDownColorModel(color: "#ffc366", name: "Things"),
  DropDownColorModel(color: "#48ed94", name: "Actions"),
  DropDownColorModel(color: "#f395b5", name: "Phrases"),
  DropDownColorModel(color: "#ffe76b", name: "People"),
  DropDownColorModel(color: "#be95bf", name: "Places"),
];
