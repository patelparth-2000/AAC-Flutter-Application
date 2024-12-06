import 'package:flutter/material.dart';

import '../../util/app_color_constants.dart';
import '../subscription/subscription_screen.dart';
import 'setting_widget.dart';
import 'settings_page/acc_support.dart';
import 'settings_page/account_details.dart';
import 'settings_page/backup_restore.dart';
import 'settings_page/color_coding.dart';
import 'settings_page/grammar.dart';
import 'settings_page/keys_on_selection.dart';
import 'settings_page/layout.dart';
import 'settings_page/password_protection.dart';
import 'settings_page/pictures_grid_size.dart';
import 'settings_page/prediction.dart';
import 'settings_page/share_messages.dart';
import 'settings_page/side_navigation_bar.dart';
import 'settings_page/test_size.dart';
import 'settings_page/touch_accommodation.dart';
import 'settings_page/vocabulary_screen.dart';
import 'settings_page/voice.dart';
import 'settings_page/what_to_speak.dart';
import 'settings_page/word_on_selection.dart';
import 'title_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen(
      {super.key,
      required this.scaffoldKey,
      required this.dashboradNavigatorKey,
      required this.drawerNavigatorKey});
  final GlobalKey<ScaffoldState> scaffoldKey;
  final GlobalKey<NavigatorState> dashboradNavigatorKey;
  final GlobalKey<NavigatorState> drawerNavigatorKey;
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void nextpage(Widget nextWidget) {
    widget.drawerNavigatorKey.currentState?.push(MaterialPageRoute(
      builder: (context) => nextWidget,
    ));
  }

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
                  SettingWidget(
                      text: "Account Details",
                      onTap: () {
                        nextpage(const AccountDetails());
                      }),
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
                      text: "Pictures per Screen (Grid Size)",
                      onTap: () {
                        nextpage(const PicturesGridSize());
                      }),
                  SettingWidget(
                      text: "Text Size",
                      onTap: () {
                        nextpage(const TestSize());
                      }),
                  SettingWidget(
                      text: "Text Position",
                      isToggle: true,
                      initialLabelIndex: 0,
                      onToggleChanged: (index) {}),
                  SettingWidget(
                      text: "Change Side Navigation Bar",
                      onTap: () {
                        nextpage(const SideNavigationBar());
                      }),
                  SettingWidget(
                      text: "Colour Coding",
                      onTap: () {
                        nextpage(const ColorCoding());
                      }),
                  const TitleWidget(
                    text: "PICTURE SETTINGS (BEHAVIOUR)",
                  ),
                  SettingWidget(
                      text: "Enlarge Word on Selection",
                      onTap: () {
                        nextpage(const WordOnSelection());
                      }),
                  SettingWidget(
                      text: "Home Screen vocabulary",
                      onTap: () {
                        nextpage(const VocabularyScreen());
                      }),
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
                  SettingWidget(
                      text: "Grammar",
                      onTap: () {
                        nextpage(const Grammar());
                      }),
                  const TitleWidget(
                    text: "KEYBOARD SETTING",
                  ),
                  SettingWidget(
                      text: "Layout",
                      onTap: () {
                        nextpage(const Layout());
                      }),
                  SettingWidget(
                      text: "Prediction",
                      onTap: () {
                        nextpage(const Prediction());
                      }),
                  SettingWidget(
                      text: "Enlarge Keys on Selection",
                      onTap: () {
                        nextpage(const KeysOnSelection());
                      }),
                  const TitleWidget(
                    text: "AUDIO SETTING",
                  ),
                  SettingWidget(
                      text: "Voice",
                      onTap: () {
                        nextpage(const Voice());
                      }),
                  SettingWidget(
                      text: "What to Speak",
                      onTap: () {
                        nextpage(const WhatToSpeak());
                      }),
                  SettingWidget(
                    text: "Speak action keys",
                    isSwitch: true,
                    switchValue: true,
                    onSwitchChanged: (value) {},
                  ),
                  const TitleWidget(
                    text: "GENERAL",
                  ),
                  SettingWidget(
                      text: "Share Messages",
                      onTap: () {
                        nextpage(const ShareMessages());
                      }),
                  SettingWidget(
                      text: "Password Protection",
                      onTap: () {
                        nextpage(const PasswordProtection());
                      }),
                  SettingWidget(
                    text: "Auto Clear Message Box",
                    isSwitch: true,
                    switchValue: true,
                    onSwitchChanged: (value) {},
                  ),
                  SettingWidget(
                      text: "Backup & Restore",
                      onTap: () {
                        nextpage(const BackupRestore());
                      }),
                  const TitleWidget(
                    text: "ACCESSIBILITY",
                  ),
                  SettingWidget(
                      text: "Touch Accommodation",
                      onTap: () {
                        nextpage(const TouchAccommodation());
                      }),
                  const TitleWidget(
                    text: "SUPPORT",
                  ),
                  SettingWidget(
                      text: "Avaz Support",
                      onTap: () {
                        nextpage(const AccSupport());
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
