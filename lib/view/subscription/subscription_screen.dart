import 'package:avaz_app/util/app_color_constants.dart';
import 'package:avaz_app/util/dimensions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../common/common.dart';
import '../../services/data_base_service.dart';
import '../settings/setting_model.dart/account_setting_model.dart';

// ignore: must_be_immutable
class SubscriptionScreen extends StatefulWidget {
  SubscriptionScreen(
      {super.key, required this.dataBaseService, this.accountSettingModel});
  final DataBaseService dataBaseService;
  AccountSettingModel? accountSettingModel;
  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    padding: const EdgeInsets.all(5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        border: Border.all(
                            color: AppColorConstants.blue60, width: 4)),
                    child: const Icon(Icons.arrow_back_ios_new_outlined,
                        size: 20, color: AppColorConstants.blue60),
                  ),
                ),
                SizedBox(
                  width: Dimensions.screenWidth * 0.82,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text(
                                "You're on a ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                  widget
                                      .accountSettingModel!.subscriptionDetail!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: AppColorConstants.blue60)),
                              const Text(" plan",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                "Expired on: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              Text(
                                  changeDateFormat(
                                      widget.accountSettingModel!.expireDate!),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: AppColorConstants.blue60)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Without a subscription, you will lose access to:",
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 12),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0),
                            color: AppColorConstants.blue40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                iconText(
                                    icon: Icons.emoji_emotions_outlined,
                                    text: "Symbols"),
                                const SizedBox(
                                  height: 10,
                                ),
                                iconText(
                                    icon: Icons.volume_up_outlined,
                                    text: "Voice"),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                iconText(
                                    icon: Icons.file_copy_rounded,
                                    text: "Low-tech boards"),
                                const SizedBox(
                                  height: 10,
                                ),
                                iconText(
                                    icon: Icons.search_rounded,
                                    text: "Web Search"),
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          priceTag(duration: "AAC Monthly", text: "₹299.00"),
                          priceTag(duration: "AAC yearly", text: "₹2,999.00"),
                          priceTag(
                              duration: "AAC Lifetime",
                              text: "₹11,099.00",
                              iscolor: true),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                children: [
                  iconText(
                      icon: Icons.discount_outlined,
                      text: "Promo Code",
                      color: AppColorConstants.blue80),
                  const Text(
                      "Subscription will automatically renew unless canceled within 24-hours before the end of the current peroid. You can cancle anytime on your play store subscription. Any unused protion of a free trial will be forfeited if you purchase a subscription.",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.black,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.black, // Set the default text color
                      ),
                      children: [
                        const TextSpan(
                          text: "For more information see our ",
                        ),
                        TextSpan(
                          text: "T&C",
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors
                                .blue, // Optional: Use a different color for links
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Handle T&C click
                              // ignore: avoid_print
                              print("T&C clicked");
                            },
                        ),
                        const TextSpan(
                          text: " and ",
                        ),
                        TextSpan(
                          text: "Privacy Policy.",
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors
                                .blue, // Optional: Use a different color for links
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Handle Privacy Policy click
                              // ignore: avoid_print
                              print("Privacy Policy clicked");
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget iconText(
      {required IconData icon, required String text, Color? color}) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(text,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 14, color: color)),
      ],
    );
  }

  Widget priceTag(
      {required String duration, required String text, bool iscolor = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
      decoration: BoxDecoration(
          border: Border.all(
              color: AppColorConstants.imageTextButtonColor, width: 3),
          borderRadius: BorderRadius.circular(10),
          color: iscolor ? AppColorConstants.imageTextButtonColor : null),
      child: Column(
        children: [
          Text(duration,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: !iscolor
                      ? AppColorConstants.imageTextButtonColor
                      : AppColorConstants.white)),
          const SizedBox(
            height: 10,
          ),
          Text(text,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: !iscolor
                      ? AppColorConstants.imageTextButtonColor
                      : AppColorConstants.white)),
        ],
      ),
    );
  }
}
