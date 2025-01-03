import 'package:avaz_app/common/common.dart';
import 'package:avaz_app/util/dimensions.dart';
import 'package:avaz_app/view/settings/setting_model/touch_setting.dart';
import 'package:avaz_app/view/settings/setting_widget.dart';
import 'package:flutter/material.dart';

import '../../../services/data_base_service.dart';
import '../../../util/app_color_constants.dart';

// ignore: must_be_immutable
class TouchAccommodation extends StatefulWidget {
  TouchAccommodation(
      {super.key,
      required this.dataBaseService,
      this.touchSettingModel,
      required this.refreshSettingData});
  final DataBaseService dataBaseService;
  TouchSettingModel? touchSettingModel;
  final Function() refreshSettingData;
  @override
  State<TouchAccommodation> createState() => _TouchAccommodationState();
}

class _TouchAccommodationState extends State<TouchAccommodation> {
  double duration = 1.0;
  double repeat = 1.0;

  double onAdd(double limit) {
    if (limit == 8.0) {
      return limit;
    }
    limit += 0.5;
    return limit;
  }

  double onRemove(double limit) {
    if (limit == 0.5) {
      return limit;
    }
    limit -= 0.5;
    return limit;
  }

  @override
  void initState() {
    super.initState();
    duration = double.parse(widget.touchSettingModel!.durationLimit!);
    repeat = double.parse(widget.touchSettingModel!.ignoreLimit!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text("Touch Sensitivity Settings",
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
                  children: [
                    SettingWidget(
                      text: "Enable Touch Sensitivity",
                      isSwitch: true,
                      switchValue: widget.touchSettingModel!.enableTouch!,
                      onSwitchChanged: (value) {
                        widget.touchSettingModel!.enableTouch = value;
                        widget.dataBaseService
                            .touchSettingUpdate(widget.touchSettingModel!);
                        setState(() {});
                        widget.refreshSettingData();
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    if (widget.touchSettingModel!.enableTouch!)
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SettingWidget(
                              text: "Hold Duration",
                              isSwitch: true,
                              switchValue:
                                  widget.touchSettingModel!.holdDuration!,
                              onSwitchChanged: (value) {
                                widget.touchSettingModel!.holdDuration = value;
                                widget.dataBaseService.touchSettingUpdate(
                                    widget.touchSettingModel!);
                                setState(() {});
                                widget.refreshSettingData();
                              },
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            if (widget.touchSettingModel!.holdDuration!)
                              CounterWidget(
                                onAdd: () {
                                  duration = onAdd(duration);
                                  widget.touchSettingModel!.durationLimit =
                                      duration.toString();
                                  widget.dataBaseService.touchSettingUpdate(
                                      widget.touchSettingModel!);
                                  widget.refreshSettingData();
                                  setState(() {});
                                },
                                onRemove: () {
                                  duration = onRemove(duration);
                                  widget.touchSettingModel!.durationLimit =
                                      duration.toString();
                                  widget.dataBaseService.touchSettingUpdate(
                                      widget.touchSettingModel!);
                                  widget.refreshSettingData();
                                  setState(() {});
                                },
                                limit: duration,
                              ),
                            const SizedBox(
                              height: 5,
                            ),
                            SettingWidget(
                              text: "Ignore Repeat",
                              isSwitch: true,
                              switchValue:
                                  widget.touchSettingModel!.ignoreRepeat!,
                              onSwitchChanged: (value) {
                                widget.touchSettingModel!.ignoreRepeat = value;
                                widget.dataBaseService.touchSettingUpdate(
                                    widget.touchSettingModel!);
                                setState(() {});
                                widget.refreshSettingData();
                              },
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            if (widget.touchSettingModel!.ignoreRepeat!)
                              CounterWidget(
                                onAdd: () {
                                  repeat = onAdd(repeat);
                                  widget.touchSettingModel!.ignoreLimit =
                                      repeat.toString();
                                  widget.dataBaseService.touchSettingUpdate(
                                      widget.touchSettingModel!);
                                  widget.refreshSettingData();
                                  setState(() {});
                                },
                                onRemove: () {
                                  repeat = onRemove(repeat);
                                  widget.touchSettingModel!.ignoreLimit =
                                      repeat.toString();
                                  widget.dataBaseService.touchSettingUpdate(
                                      widget.touchSettingModel!);
                                  widget.refreshSettingData();
                                  setState(() {});
                                },
                                limit: repeat,
                              ),
                            const SizedBox(
                              height: 10,
                            ),
                            dividerWidget(
                                color: AppColorConstants.contentSecondary,
                                height: 0.5),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "Border Color",
                                  style: TextStyle(
                                      color: AppColorConstants.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                const Spacer(),
                                for (int i = 0; i < colorList.length; i++)
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          widget.touchSettingModel!
                                                  .borderColor =
                                              colorList[i]["name"];
                                          widget.dataBaseService
                                              .touchSettingUpdate(
                                                  widget.touchSettingModel!);
                                          setState(() {});
                                          widget.refreshSettingData();
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          padding: const EdgeInsets.all(1),
                                          decoration: BoxDecoration(
                                              border: widget.touchSettingModel!
                                                          .borderColor ==
                                                      colorList[i]["name"]
                                                  ? Border.all(
                                                      color: AppColorConstants
                                                          .keyBoardTextColor,
                                                      width: 1.5)
                                                  : null),
                                          child: Container(
                                            color: colorList[i]["color"],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      )
                                    ],
                                  ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Border Thickness",
                                      style: TextStyle(
                                          color: AppColorConstants.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      width: Dimensions.screenWidth * 0.35,
                                      child: Slider(
                                        activeColor: AppColorConstants.blue100,
                                        inactiveColor: AppColorConstants.blue20,
                                        value: double.parse(widget
                                            .touchSettingModel!
                                            .borderThickness!),
                                        max: 15.0,
                                        min: 0.0,
                                        onChanged: (value) {
                                          widget.touchSettingModel!
                                                  .borderThickness =
                                              value.toString();
                                          widget.dataBaseService
                                              .touchSettingUpdate(
                                                  widget.touchSettingModel!);
                                          setState(() {});
                                          widget.refreshSettingData();
                                        },
                                      ),
                                    ),
                                    const Text(
                                      "Border Radius",
                                      style: TextStyle(
                                          color: AppColorConstants.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      width: Dimensions.screenWidth * 0.35,
                                      child: Slider(
                                        activeColor: AppColorConstants.blue100,
                                        inactiveColor: AppColorConstants.blue20,
                                        value: double.parse(widget
                                            .touchSettingModel!.borderRadius!),
                                        max: 50.0,
                                        min: 0.0,
                                        onChanged: (value) {
                                          widget.touchSettingModel!
                                              .borderRadius = value.toString();
                                          widget.dataBaseService
                                              .touchSettingUpdate(
                                                  widget.touchSettingModel!);
                                          setState(() {});
                                          widget.refreshSettingData();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          double.parse(widget.touchSettingModel!
                                              .borderRadius!)),
                                      border: Border.all(
                                        width: double.parse(widget
                                            .touchSettingModel!
                                            .borderThickness!),
                                        color: colorchange(
                                            widget.touchSettingModel),
                                      )),
                                )
                              ],
                            ),
                          ]),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

class CounterWidget extends StatelessWidget {
  final double limit;
  final Function() onAdd;
  final Function() onRemove;
  const CounterWidget(
      {super.key,
      required this.limit,
      required this.onAdd,
      required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 23,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              InkWell(
                onTap: onRemove,
                child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    color: AppColorConstants.keyBoardTextColor,
                    child: const Icon(
                      Icons.remove,
                      color: AppColorConstants.white,
                      size: 20,
                    )),
              ),
              Container(
                alignment: Alignment.center,
                color: AppColorConstants.white,
                width: 60,
                child: Text("$limit s"),
              ),
              InkWell(
                onTap: onAdd,
                child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    color: AppColorConstants.keyBoardTextColor,
                    child: const Icon(
                      Icons.add,
                      color: AppColorConstants.white,
                      size: 20,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Color colorchange(TouchSettingModel? touchSettingModel) {
  for (var color in colorList) {
    if (touchSettingModel!.borderColor!.toString() == color["name"]) {
      return color["color"];
    }
  }
  return Colors.purpleAccent;
}

List<Map<String, dynamic>> colorList = [
  {"name": "pink", "color": Colors.purpleAccent},
  {"name": "blue", "color": Colors.blue},
  {"name": "orange", "color": Colors.orange},
  {"name": "red", "color": Colors.red}
];
