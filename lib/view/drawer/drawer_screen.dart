import 'package:avaz_app/view/search/search_screen.dart';
import 'package:avaz_app/view/settings/settings_screen.dart';
import 'package:avaz_app/view/tools/tools_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:volume_controller/volume_controller.dart';

import '../../common/common.dart';
import '../../common/common_image_button.dart';
import '../../util/app_color_constants.dart';
import '../editwords/edit_words_screen.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen(
      {super.key,
      required this.scaffoldKey,
      required this.flutterTts,
      required this.isKeyBoardShow,
      required this.dashboradNavigatorKey,
      required this.refreshSettingData,
      required this.refreshGirdData});
  final GlobalKey<ScaffoldState> scaffoldKey;
  final GlobalKey<NavigatorState> dashboradNavigatorKey;
  final FlutterTts flutterTts;
  final bool isKeyBoardShow;
  final Function() refreshSettingData;
  final Function() refreshGirdData;
  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  final GlobalKey<NavigatorState> _drawerNavigatorKey =
      GlobalKey<NavigatorState>();
  bool isNavigated = false;
  bool isMute = false;
  double _volumeListenerValue = 0;
  double _setVolumeValue = 0;
  List<DrawerModel> drawerData = [
    DrawerModel(name: "Edit Words", imageData: Icons.edit),
    DrawerModel(name: "Search", imageData: Icons.search),
    DrawerModel(name: "Settings", imageData: Icons.settings),
    DrawerModel(name: "Tools", imageData: Icons.build_rounded),
    DrawerModel(name: "Support", imageData: Icons.support_agent_outlined)
  ];

  List<DrawerModel> soundData = [
    DrawerModel(name: "Volume Up", imageData: Icons.volume_up_rounded),
    DrawerModel(name: "Volume Down", imageData: Icons.volume_down_rounded),
    DrawerModel(name: "Mute", imageData: Icons.volume_mute_rounded),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      VolumeController().listener((volume) {
        setState(() {
          _volumeListenerValue = volume;
        });
      });
    });
    _getVolumeData();
    drawerData = [
      DrawerModel(
          name: "Edit Words",
          imageData: Icons.edit,
          isShow: widget.isKeyBoardShow),
      DrawerModel(
        name: "Search",
        imageData: Icons.search,
      ),
      DrawerModel(
        name: "Settings",
        imageData: Icons.settings,
      ),
      DrawerModel(
          name: "Tools",
          imageData: Icons.build_rounded,
          isShow: widget.isKeyBoardShow),
      DrawerModel(name: "Support", imageData: Icons.support_agent_outlined)
    ];
  }

  Future<void> _getVolumeData() async {
    _setVolumeValue = await VolumeController().getVolume();
    setState(() {});
  }

  @override
  void dispose() {
    VolumeController().removeListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: CommonImageButton(
            backgroundColor: AppColorConstants.keyBoardBackColor,
            borderColor: AppColorConstants.keyBoardBackColor,
            isImageShow: true,
            vertical: 0,
            height: 50,
            onTap: () {
              if (isNavigated) {
                speakToText("Back", widget.flutterTts);
                _drawerNavigatorKey.currentState?.pop();
              } else {
                speakToText("Close", widget.flutterTts);
                widget.scaffoldKey.currentState?.closeEndDrawer();
              }
            },
            horizontal: 2,
            buttonIconColor: AppColorConstants.black,
            width: 75,
            imageSize: 35,
            borderRadius: const BorderRadiusDirectional.horizontal(
                start: Radius.circular(5)),
            buttonIcon:
                isNavigated ? Icons.arrow_back_ios_outlined : Icons.close,
          ),
        ),
        Expanded(
          child: Container(
            color: AppColorConstants.keyBoardBackColor,
            child: Navigator(
              key: _drawerNavigatorKey,
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  builder: (_) => Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text("Menu",
                                style: TextStyle(
                                    color: AppColorConstants.buttonColorBlue2,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 20,
                            ),
                            for (int i = 0; i < drawerData.length; i++)
                              if (drawerData[i].isShow)
                                Column(
                                  children: [
                                    CommonImageButton(
                                      width: 135,
                                      isHorizontal: true,
                                      text: drawerData[i].name,
                                      flutterTts: widget.flutterTts,
                                      buttonName: drawerData[i].name,
                                      buttonIcon: drawerData[i].imageData,
                                      horizontal: 10,
                                      vertical: 10,
                                      betweenGap: 10,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      fontWeight: FontWeight.bold,
                                      onTap: () {
                                        setState(() {
                                          isNavigated = true;
                                        });

                                        if (drawerData[i].name ==
                                            "Edit Words") {
                                          setState(() {
                                            isNavigated = false;
                                          });
                                          widget.scaffoldKey.currentState
                                              ?.closeEndDrawer();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditWordsScreen(
                                                  refreshGirdData:
                                                      widget.refreshGirdData,
                                                ),
                                              ));
                                        } else if (drawerData[i].name ==
                                            "Search") {
                                          _drawerNavigatorKey.currentState
                                              ?.push(MaterialPageRoute(
                                            builder: (context) =>
                                                const SearchScreen(),
                                          ))
                                              .whenComplete(
                                            () {
                                              setState(() {
                                                isNavigated = false;
                                              });
                                            },
                                          );
                                        } else if (drawerData[i].name ==
                                            "Settings") {
                                          _drawerNavigatorKey.currentState
                                              ?.push(MaterialPageRoute(
                                            builder: (context) =>
                                                SettingsScreen(
                                              dashboradNavigatorKey:
                                                  widget.dashboradNavigatorKey,
                                              scaffoldKey: widget.scaffoldKey,
                                              drawerNavigatorKey:
                                                  _drawerNavigatorKey,
                                              refreshSettingData:
                                                  widget.refreshSettingData,
                                            ),
                                          ))
                                              .whenComplete(
                                            () {
                                              setState(() {
                                                isNavigated = false;
                                              });
                                            },
                                          );
                                        } else if (drawerData[i].name ==
                                            "Tools") {
                                          _drawerNavigatorKey.currentState
                                              ?.push(MaterialPageRoute(
                                            builder: (context) => ToolsScreen(
                                              drawerNavigatorKey:
                                                  _drawerNavigatorKey,
                                            ),
                                          ))
                                              .whenComplete(
                                            () {
                                              setState(() {
                                                isNavigated = false;
                                              });
                                            },
                                          );
                                        } else if (drawerData[i].name ==
                                            "Support") {
                                          isNavigated = false;
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Sound",
                              style: TextStyle(
                                  color: AppColorConstants.buttonColorBlue2,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              for (int i = 0; i < soundData.length; i++)
                                Row(
                                  children: [
                                    CommonImageButton(
                                      width: 75,
                                      isImageShow: true,
                                      isHorizontal: false,
                                      text: soundData[i].name,
                                      flutterTts: widget.flutterTts,
                                      buttonName: soundData[i].name,
                                      buttonIcon: soundData[i].imageData,
                                      horizontal: 5,
                                      vertical: 3,
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                      onTap: () {
                                        if (soundData[i].name == "Volume Up") {
                                          _setVolumeValue =
                                              (_volumeListenerValue + 0.1)
                                                  .clamp(0.0, 1.0);
                                          VolumeController()
                                              .setVolume(_setVolumeValue);
                                          setState(() {});
                                        } else if (soundData[i].name ==
                                            "Volume Down") {
                                          _setVolumeValue =
                                              (_volumeListenerValue - 0.1)
                                                  .clamp(0.0, 1.0);
                                          VolumeController()
                                              .setVolume(_setVolumeValue);
                                          setState(() {});
                                        } else {
                                          if (isMute) {
                                            VolumeController()
                                                .setVolume(_setVolumeValue);
                                            isMute = false;
                                          } else {
                                            VolumeController().muteVolume();
                                            isMute = true;
                                          }
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class DrawerModel {
  final String name;
  final dynamic imageData;
  final bool isShow;
  final Function()? onTap;
  DrawerModel(
      {required this.name, this.imageData, this.isShow = true, this.onTap});
}
