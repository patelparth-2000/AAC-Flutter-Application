import 'package:flutter/material.dart';

import '../../util/app_color_constants.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Text(text,
          style: const TextStyle(
              color: AppColorConstants.imageTextButtonColor,
              fontSize: 16,
              fontWeight: FontWeight.w600)),
    );
  }
}
