import 'package:flutter/material.dart';

import '../util/app_color_constants.dart';

class CommonButtonWidget extends StatelessWidget {
  final String title;
  final String? imagePath;
  final Function() onTap;
  final bool isActive;
  final bool isLoading;
  final Color? buttonColor;
  final double radius;
  final double paddingHorizontal;
  final double paddingVertical;
  final Gradient gradient;
  const CommonButtonWidget({
    super.key,
    required this.title,
    required this.onTap,
    this.isActive = true,
    this.isLoading = false,
    this.buttonColor,
    this.imagePath,
    this.radius = 10.0,
    this.paddingHorizontal = 15.0,
    this.paddingVertical = 20.0,
    this.gradient = const LinearGradient(
      colors: [
        AppColorConstants.buttonColorBlue1,
        AppColorConstants.buttonColorBlue2,
        AppColorConstants.buttonColorBlue3,
        AppColorConstants.buttonColorBlue4,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding:
              EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: 5),
          decoration: BoxDecoration(
              gradient: isActive ? gradient : null,
              color: buttonColor ??
                  (isActive ? null : AppColorConstants.inActiveButton),
              borderRadius: BorderRadius.circular(radius)),
          alignment: Alignment.center,
          child: Column(
            children: [
              if (imagePath != null)
                isLoading
                    ? const SizedBox(
                        height: 23,
                        width: 23,
                        child: CircularProgressIndicator(
                          strokeWidth:
                              4, // Adjust this value to change the size
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColorConstants.white),
                        ),
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Image.asset("$imagePath"),
                              const SizedBox(
                                width: 7,
                              )
                            ],
                          ),
                          Center(
                            child: Text(
                              title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: isActive
                                      ? AppColorConstants.white
                                      : AppColorConstants.contentSecondary),
                            ),
                          ),
                        ],
                      ),
              if (imagePath == null)
                isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth:
                              4, // Adjust this value to change the size
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColorConstants.white),
                        ),
                      )
                    : Text(
                        title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: isActive
                                ? AppColorConstants.white
                                : AppColorConstants.white),
                      ),
            ],
          ),
        ),
      ),
    );
  }
}
