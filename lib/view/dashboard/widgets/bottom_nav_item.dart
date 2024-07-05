import 'package:flutter/material.dart';

import '../../../../util/app_color_constants.dart';
import '../../../common/common_text_field_widget.dart';
import '../../../util/dimensions.dart';

class BottomNavItem extends StatelessWidget {
  final String imagePath;
  final Function()? onTap;
  final bool isSelected;
  final String label;
  const BottomNavItem(
      {super.key,
      required this.imagePath,
      this.onTap,
      this.isSelected = false,
      required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: AppColorConstants.topRowBackground,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: CommonTextFieldWidget(
                    textFieldHeight: 70,
                    controller: TextEditingController(),
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: Dimensions.screenHeight * 0.004,
            ),
            Text(
              label,
              style: isSelected
                  ? const TextStyle(
                      color: AppColorConstants.blue100,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)
                  : const TextStyle(
                      color: AppColorConstants.contentSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
