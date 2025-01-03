import 'package:flutter/material.dart';

import '../../services/data_base_service.dart';
import '../../util/app_color_constants.dart';
import '../subscription/subscription_screen.dart';
import 'setting_model/account_setting_model.dart';
import 'setting_model/audio_setting.dart';
import 'setting_model/general_setting.dart';
import 'setting_model/keyboard_setting.dart';
import 'setting_model/picture_appearance_setting_model.dart';
import 'setting_model/picture_behaviour_setting_model.dart';
import 'setting_model/touch_setting.dart';
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
      required this.drawerNavigatorKey,
      required this.refreshSettingData});
  final GlobalKey<ScaffoldState> scaffoldKey;
  final GlobalKey<NavigatorState> dashboradNavigatorKey;
  final GlobalKey<NavigatorState> drawerNavigatorKey;
  final Function() refreshSettingData;
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  DataBaseService dataBaseService = DataBaseService.instance;
  bool isLoading = false;
  AccountSettingModel? accountSettingModel = AccountSettingModel();
  PictureAppearanceSettingModel? pictureAppearanceSettingModel =
      PictureAppearanceSettingModel();
  PictureBehaviourSettingModel? pictureBehaviourSettingModel =
      PictureBehaviourSettingModel();
  KeyboardSettingModel? keyboardSettingModel = KeyboardSettingModel();
  AudioSettingModel? audioSettingModel = AudioSettingModel();
  GeneralSettingModel? generalSettingModel = GeneralSettingModel();
  TouchSettingModel? touchSettingModel = TouchSettingModel();
  List<String> textPosition = ['Above', 'Below'];
  int initialLabelIndexText = 0;

  @override
  void initState() {
    super.initState();
    getSettingData();
  }

  void getSettingData() async {
    setState(() {
      isLoading = true;
    });
    accountSettingModel = await dataBaseService.accountSettingFetch();
    pictureAppearanceSettingModel =
        await dataBaseService.pictureAppearanceSettingFetch();
    pictureBehaviourSettingModel =
        await dataBaseService.pictureBehaviourSettingFetch();
    keyboardSettingModel = await dataBaseService.keyboardSettingFetch();
    audioSettingModel = await dataBaseService.audioSettingFetch();
    generalSettingModel = await dataBaseService.generalSettingFetch();
    touchSettingModel = await dataBaseService.touchSettingFetch();

    String currentTextPosition = pictureAppearanceSettingModel!.textPosition!;
    initialLabelIndexText = textPosition.indexWhere((element) =>
        element.toLowerCase().replaceAll(" ", "_") == currentTextPosition);
    if (initialLabelIndexText == -1) initialLabelIndexText = 0;

    setState(() {
      isLoading = false;
    });
  }

  void nextpage(Widget nextWidget) {
    widget.drawerNavigatorKey.currentState?.push(MaterialPageRoute(
      builder: (context) => nextWidget,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      child: isLoading
          ? const Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: AppColorConstants.imageTextButtonColor,
                    semanticsLabel: 'Circular progress indicator',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Loading....",
                      style: TextStyle(
                          color: AppColorConstants.buttonColorBlue2,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            )
          : Column(
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
                              nextpage(AccountDetails(
                                dataBaseService: dataBaseService,
                                accountSettingModel: accountSettingModel,
                                refreshSettingData: widget.refreshSettingData,
                              ));
                            }),
                        SettingWidget(
                            text: "Purchase Subscription",
                            onTap: () {
                              widget.scaffoldKey.currentState?.closeEndDrawer();
                              Navigator.push(
                                  widget.scaffoldKey.currentContext!,
                                  MaterialPageRoute(
                                    builder: (context) => SubscriptionScreen(
                                      dataBaseService: dataBaseService,
                                      accountSettingModel: accountSettingModel,
                                      refreshSettingData:
                                          widget.refreshSettingData,
                                    ),
                                  ));
                            }),
                        const TitleWidget(
                          text: "PICTURE SETTINGS (APPEARANCE)",
                        ),
                        SettingWidget(
                          text: "Message Box",
                          isSwitch: true,
                          switchValue:
                              pictureAppearanceSettingModel!.massageBox!,
                          onSwitchChanged: (value) {
                            pictureAppearanceSettingModel!.massageBox = value;
                            dataBaseService.pictureAppearanceSettingUpdate(
                                pictureAppearanceSettingModel!);
                            widget.refreshSettingData();
                            setState(() {});
                          },
                        ),
                        SettingWidget(
                          text: "Pictures in Message box",
                          isSwitch: true,
                          switchValue:
                              pictureAppearanceSettingModel!.pictureMassageBox!,
                          onSwitchChanged: (value) {
                            pictureAppearanceSettingModel!.pictureMassageBox =
                                value;
                            dataBaseService.pictureAppearanceSettingUpdate(
                                pictureAppearanceSettingModel!);
                            widget.refreshSettingData();
                            setState(() {});
                          },
                        ),
                        SettingWidget(
                            text: "Pictures per Screen (Grid Size)",
                            onTap: () async {
                              nextpage(PicturesGridSize(
                                dataBaseService: dataBaseService,
                                pictureAppearanceSettingModel:
                                    pictureAppearanceSettingModel,
                                refreshSettingData: widget.refreshSettingData,
                              ));
                            }),
                        SettingWidget(
                            text: "Text Size",
                            onTap: () {
                              nextpage(TestSize(
                                dataBaseService: dataBaseService,
                                pictureAppearanceSettingModel:
                                    pictureAppearanceSettingModel,
                                refreshSettingData: widget.refreshSettingData,
                              ));
                            }),
                        SettingWidget(
                            text: "Text Position",
                            isToggle: true,
                            initialLabelIndex: initialLabelIndexText,
                            togglelabels: textPosition,
                            onToggleChanged: (index) {
                              initialLabelIndexText = index!;
                              String selectedData = textPosition[index]
                                  .toLowerCase()
                                  .replaceAll(" ", "_");
                              pictureAppearanceSettingModel!.textPosition =
                                  selectedData;
                              dataBaseService.pictureAppearanceSettingUpdate(
                                  pictureAppearanceSettingModel!);
                              widget.refreshSettingData();
                              setState(() {});
                            }),
                        SettingWidget(
                            text: "Change Side Navigation Bar",
                            onTap: () {
                              nextpage(SideNavigationBar(
                                dataBaseService: dataBaseService,
                                pictureAppearanceSettingModel:
                                    pictureAppearanceSettingModel,
                                refreshSettingData: widget.refreshSettingData,
                              ));
                            }),
                        SettingWidget(
                            text: "Colour Coding",
                            onTap: () {
                              nextpage(ColorCoding(
                                dataBaseService: dataBaseService,
                                pictureAppearanceSettingModel:
                                    pictureAppearanceSettingModel,
                                refreshSettingData: widget.refreshSettingData,
                              ));
                            }),
                        const TitleWidget(
                          text: "PICTURE SETTINGS (BEHAVIOUR)",
                        ),
                        SettingWidget(
                            text: "Enlarge Word on Selection",
                            onTap: () {
                              nextpage(WordOnSelection(
                                dataBaseService: dataBaseService,
                                pictureBehaviourSettingModel:
                                    pictureBehaviourSettingModel,
                                refreshSettingData: widget.refreshSettingData,
                              ));
                            }),
                        SettingWidget(
                            text: "Home Screen vocabulary",
                            onTap: () {
                              nextpage(VocabularyScreen(
                                dataBaseService: dataBaseService,
                                pictureBehaviourSettingModel:
                                    pictureBehaviourSettingModel,
                                refreshSettingData: widget.refreshSettingData,
                              ));
                            }),
                        SettingWidget(
                          text: "Auto-home each time",
                          isSwitch: true,
                          switchValue:
                              pictureBehaviourSettingModel!.autoHomeEachTime!,
                          onSwitchChanged: (value) {
                            pictureBehaviourSettingModel!.autoHomeEachTime =
                                value;
                            dataBaseService.pictureBehaviourSettingUpdate(
                                pictureBehaviourSettingModel!);
                            widget.refreshSettingData();
                            setState(() {});
                          },
                        ),
                        SettingWidget(
                          text: "Swipe action to navigation",
                          isSwitch: true,
                          switchValue:
                              pictureBehaviourSettingModel!.actionToNavigation!,
                          onSwitchChanged: (value) {
                            pictureBehaviourSettingModel!.actionToNavigation =
                                value;
                            dataBaseService.pictureBehaviourSettingUpdate(
                                pictureBehaviourSettingModel!);
                            widget.refreshSettingData();
                            setState(() {});
                          },
                        ),
                        SettingWidget(
                            text: "Grammar",
                            onTap: () {
                              nextpage(Grammar(
                                dataBaseService: dataBaseService,
                                pictureBehaviourSettingModel:
                                    pictureBehaviourSettingModel,
                                refreshSettingData: widget.refreshSettingData,
                              ));
                            }),
                        const TitleWidget(
                          text: "KEYBOARD SETTING",
                        ),
                        SettingWidget(
                            text: "Layout",
                            onTap: () {
                              nextpage(Layout(
                                dataBaseService: dataBaseService,
                                keyboardSettingModel: keyboardSettingModel,
                                refreshSettingData: widget.refreshSettingData,
                              ));
                            }),
                        SettingWidget(
                            text: "Prediction",
                            onTap: () {
                              nextpage(Prediction(
                                dataBaseService: dataBaseService,
                                keyboardSettingModel: keyboardSettingModel,
                                refreshSettingData: widget.refreshSettingData,
                              ));
                            }),
                        SettingWidget(
                            text: "Enlarge Keys on Selection",
                            onTap: () {
                              nextpage(KeysOnSelection(
                                dataBaseService: dataBaseService,
                                keyboardSettingModel: keyboardSettingModel,
                                refreshSettingData: widget.refreshSettingData,
                              ));
                            }),
                        const TitleWidget(
                          text: "AUDIO SETTING",
                        ),
                        SettingWidget(
                            text: "Voice",
                            onTap: () {
                              nextpage(Voice(
                                dataBaseService: dataBaseService,
                                audioSettingModel: audioSettingModel,
                                refreshSettingData: widget.refreshSettingData,
                              ));
                            }),
                        SettingWidget(
                            text: "What to Speak",
                            onTap: () {
                              nextpage(WhatToSpeak(
                                dataBaseService: dataBaseService,
                                audioSettingModel: audioSettingModel,
                                refreshSettingData: widget.refreshSettingData,
                              ));
                            }),
                        SettingWidget(
                          text: "Speak action keys",
                          isSwitch: true,
                          switchValue: audioSettingModel!.speakAction!,
                          onSwitchChanged: (value) {
                            audioSettingModel!.speakAction = value;
                            dataBaseService
                                .audioSettingUpdate(audioSettingModel!);
                            widget.refreshSettingData();
                            setState(() {});
                          },
                        ),
                        const TitleWidget(
                          text: "GENERAL",
                        ),
                        SettingWidget(
                            text: "Share Messages",
                            onTap: () {
                              nextpage(ShareMessages(
                                dataBaseService: dataBaseService,
                                generalSettingModel: generalSettingModel,
                                refreshSettingData: widget.refreshSettingData,
                              ));
                            }),
                        SettingWidget(
                            text: "Password Protection",
                            onTap: () {
                              nextpage(PasswordProtection(
                                dataBaseService: dataBaseService,
                                generalSettingModel: generalSettingModel,
                                refreshSettingData: widget.refreshSettingData,
                              ));
                            }),
                        SettingWidget(
                          text: "Auto Clear Message Box",
                          isSwitch: true,
                          switchValue:
                              generalSettingModel!.autoClearMassageBox!,
                          onSwitchChanged: (value) {
                            generalSettingModel!.autoClearMassageBox = value;
                            dataBaseService
                                .generalSettingUpdate(generalSettingModel!);
                            widget.refreshSettingData();
                            setState(() {});
                          },
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
                            text: "Touch Sensitivity",
                            onTap: () {
                              nextpage(TouchAccommodation(
                                dataBaseService: dataBaseService,
                                touchSettingModel: touchSettingModel,
                                refreshSettingData: widget.refreshSettingData,
                              ));
                            }),
                        const TitleWidget(
                          text: "SUPPORT",
                        ),
                        SettingWidget(
                            text: "Touch Voz Support",
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
