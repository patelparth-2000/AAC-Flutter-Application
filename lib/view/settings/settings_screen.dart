import 'package:avaz_app/view/settings/setting_widget.dart';
import 'package:avaz_app/view/settings/title_widget.dart';
import 'package:flutter/material.dart';

import '../../util/app_color_constants.dart';
import '../subscription/subscription_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen(
      {super.key,
      required this.scaffoldKey,
      required this.dashboradNavigatorKey});
  final GlobalKey<ScaffoldState> scaffoldKey;
  final GlobalKey<NavigatorState> dashboradNavigatorKey;
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text("Settings",
              style: TextStyle(
                  color: AppColorConstants.buttonColorBlue2,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const TitleWidget(
                    text: "MY ACCOUNT",
                  ),
                  SettingWidget(text: "Account Details", onTap: () {}),
                  SettingWidget(
                      text: "Purchese Subscription",
                      onTap: () {
                        widget.scaffoldKey.currentState?.closeEndDrawer();
                        Navigator.push(
                            widget.scaffoldKey.currentContext!,
                            MaterialPageRoute(
                              builder: (context) => const SubscriptionScreen(),
                            ));
                      }),
                  const TitleWidget(
                    text: "PICTURE SETTINGS (APPEARANVE)",
                  ),
                  SettingWidget(
                    text: "Message Box",
                    isSwitch: true,
                    switchValue: true,
                    onSwitchChanged: (value) {},
                  ),
                  SettingWidget(
                    text: "Pictures in Message box",
                    isSwitch: true,
                    switchValue: true,
                    onSwitchChanged: (value) {},
                  ),
                  SettingWidget(
                      text: "Pictures per Screen (Grid Size)", onTap: () {}),
                  SettingWidget(text: "Text Size", onTap: () {}),
                  SettingWidget(
                      text: "Text Position",
                      isToggle: true,
                      initialLabelIndex: 0,
                      onToggleChanged: (index) {}),
                  SettingWidget(
                      text: "Change Side Navigation Bar", onTap: () {}),
                  SettingWidget(text: "Colour Coding", onTap: () {}),
                  const TitleWidget(
                    text: "PICTURE SETTINGS (BEHAVIOUR)",
                  ),
                  SettingWidget(
                      text: "Enlarge Word on Selection", onTap: () {}),
                  SettingWidget(text: "Home Screen vocabulary", onTap: () {}),
                  SettingWidget(
                    text: "Auto-home each time",
                    isSwitch: true,
                    switchValue: false,
                    onSwitchChanged: (value) {},
                  ),
                  SettingWidget(
                    text: "Swipe action to navigation",
                    isSwitch: true,
                    switchValue: true,
                    onSwitchChanged: (value) {},
                  ),
                  SettingWidget(text: "Grammar", onTap: () {}),
                  const TitleWidget(
                    text: "KEYBOARD SETTING",
                  ),
                  SettingWidget(text: "Layout", onTap: () {}),
                  SettingWidget(text: "Prediction", onTap: () {}),
                  SettingWidget(
                      text: "Enlarge Keys on Selection", onTap: () {}),
                  const TitleWidget(
                    text: "AUDIO SETTING",
                  ),
                  SettingWidget(text: "Voice", onTap: () {}),
                  SettingWidget(text: "What to Speak", onTap: () {}),
                  SettingWidget(
                    text: "Speak action keys",
                    isSwitch: true,
                    switchValue: true,
                    onSwitchChanged: (value) {},
                  ),
                  const TitleWidget(
                    text: "GENERAL",
                  ),
                  SettingWidget(text: "Share Messages", onTap: () {}),
                  SettingWidget(text: "Password Protection", onTap: () {}),
                  SettingWidget(
                    text: "Auto Clear Message Box",
                    isSwitch: true,
                    switchValue: true,
                    onSwitchChanged: (value) {},
                  ),
                  SettingWidget(text: "Backup & Restore", onTap: () {}),
                  const TitleWidget(
                    text: "ACCESSIBILITY",
                  ),
                  SettingWidget(text: "Touch Accommodation", onTap: () {}),
                  const TitleWidget(
                    text: "SUPPORT",
                  ),
                  SettingWidget(text: "Avaz Support", onTap: () {}),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
