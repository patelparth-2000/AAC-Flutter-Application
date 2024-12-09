import 'package:avaz_app/common/common_image_button.dart';
import 'package:avaz_app/util/app_color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../model/get_category_modal.dart';
import '../services/data_base_service.dart';
import '../view/settings/setting_model.dart/account_setting_model.dart';
import '../view/settings/setting_model.dart/audio_setting.dart';
import '../view/settings/setting_model.dart/general_setting.dart';
import '../view/settings/setting_model.dart/keyboard_setting.dart';
import '../view/settings/setting_model.dart/picture_appearance_setting_model.dart';
import '../view/settings/setting_model.dart/picture_behaviour_setting_model.dart';
import '../view/settings/setting_model.dart/touch_setting.dart';

class CommonZoomAnimationWidget extends StatefulWidget {
  final Function(String text, String? image) onAdd;
  final Function(String slug) changeTable;
  final GetCategoryModal getCategoryModal;
  final FlutterTts flutterTts;
  final AccountSettingModel? accountSettingModel;
  final PictureAppearanceSettingModel? pictureAppearanceSettingModel;
  final PictureBehaviourSettingModel? pictureBehaviourSettingModel;
  final KeyboardSettingModel? keyboardSettingModel;
  final AudioSettingModel? audioSettingModel;
  final GeneralSettingModel? generalSettingModel;
  final TouchSettingModel? touchSettingModel;
  final double imageSize;
  final double textSize;

  const CommonZoomAnimationWidget(
      {super.key,
      required this.onAdd,
      required this.flutterTts,
      required this.changeTable,
      required this.getCategoryModal,
      this.accountSettingModel,
      this.pictureAppearanceSettingModel,
      this.pictureBehaviourSettingModel,
      this.keyboardSettingModel,
      this.audioSettingModel,
      this.generalSettingModel,
      this.touchSettingModel,
      required this.imageSize,
      required this.textSize});

  @override
  State<CommonZoomAnimationWidget> createState() =>
      _CommonZoomAnimationWidgetState();
}

class _CommonZoomAnimationWidgetState extends State<CommonZoomAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String imagePath = "";
  bool imageExists = false;

  @override
  void initState() {
    super.initState();
    _initialize();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  Future<void> _initialize() async {
    await directoryPath();
  }

  Future<void> directoryPath() async {
    final dbService = DataBaseService.instance;
    imagePath = await dbService.directoryPath();
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    widget.onAdd(
        widget.getCategoryModal.name!,
        widget.getCategoryModal.image != null
            ? "${widget.getCategoryModal.imagePath}${widget.getCategoryModal.image}"
            : null);
    _controller.forward();
    Future.delayed(const Duration(seconds: 1), () {
      _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: CommonImageButton(
        iscolorChange: false,
        changeTable: widget.changeTable,
        slug: widget.getCategoryModal.slug,
        type: widget.getCategoryModal.type,
        onAdd: widget.onAdd,
        flutterTts: widget.flutterTts,
        text: widget.getCategoryModal.name!,
        textPostion: widget.pictureAppearanceSettingModel!.textPosition!,
        onTap: widget.getCategoryModal.type == "voice" ? _onTap : () {},
        isImageAsset: false,
        buttonImage: widget.getCategoryModal.image != null
            ? "${widget.getCategoryModal.imagePath}${widget.getCategoryModal.image}"
            : null,
        imageSize: widget.imageSize,
        isImageShow: !(widget.pictureAppearanceSettingModel!.textSize! ==
            "only_text_(no_picture)"),
        backgroundColor: widget.getCategoryModal.type == "voice"
            ? AppColorConstants.keyBoardBackColor
            : widget.getCategoryModal.type == "sub_categories"
                ? AppColorConstants.keyBoardBackColorPink
                : AppColorConstants.keyBoardBackColorGreen,
        borderColor: widget.getCategoryModal.type == "voice"
            ? AppColorConstants.keyBoardBackColor
            : widget.getCategoryModal.type == "sub_categories"
                ? AppColorConstants.keyBoardBackColorPink
                : AppColorConstants.keyBoardBackColorGreen,
        isTextShow: !(widget.pictureAppearanceSettingModel!.textSize! ==
            "no_text_(only_picture)"),
        textStyle: TextStyle(
          color: AppColorConstants.keyBoardTextColor,
          fontWeight: FontWeight.bold,
          fontSize: (widget.pictureAppearanceSettingModel!.textSize! == "small")
              ? widget.textSize / 1.5
              : (widget.pictureAppearanceSettingModel!.textSize! == "medium")
                  ? widget.textSize / 1.2
                  : widget.textSize,
        ),
        buttonIconColor: null,
        voiceFile: widget.getCategoryModal.voiceFile != null
            ? "${widget.getCategoryModal.imagePath}${widget.getCategoryModal.voiceFile}"
            : null,
        buttonName: widget.getCategoryModal.name,
      ),
    );
  }
}
