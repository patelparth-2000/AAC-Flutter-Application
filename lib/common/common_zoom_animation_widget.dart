import 'package:avaz_app/common/common_image_button.dart';
import 'package:avaz_app/util/app_color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../model/get_category_modal.dart';
import '../services/data_base_service.dart';
import '../view/settings/setting_model/account_setting_model.dart';
import '../view/settings/setting_model/audio_setting.dart';
import '../view/settings/setting_model/general_setting.dart';
import '../view/settings/setting_model/keyboard_setting.dart';
import '../view/settings/setting_model/picture_appearance_setting_model.dart';
import '../view/settings/setting_model/picture_behaviour_setting_model.dart';
import '../view/settings/setting_model/touch_setting.dart';

class CommonZoomAnimationWidget extends StatefulWidget {
  final Function(String text, String? image, {String? audioFile}) onAdd;
  final Function(String slug) changeTable;
  final Function(String audioPath) playAudio;
  final Function(String type) hexToBordorColor;
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
  final Function()? stopAudio;
  final Function(int? id,
      {int? rowNumber, int? pinValue,required GetCategoryModal getCategoryModal})? onLongTap;

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
      required this.textSize,
      required this.playAudio,
      this.stopAudio,
      this.onLongTap,
      required this.hexToBordorColor});

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
            : null,
        audioFile: widget.getCategoryModal.voiceFile != null
            ? "${widget.getCategoryModal.imagePath}${widget.getCategoryModal.voiceFile}"
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
        getCategoryModal: widget.getCategoryModal,
        onLongTap: widget.onLongTap,
        pinValue: widget.getCategoryModal.pinItem,
        isLongTap: true,
        touchSettingModel: widget.touchSettingModel,
        stopAudio: widget.stopAudio,
        iscolorChange: false,
        isSpeak: true,
        changeTable: widget.changeTable,
        slug: widget.getCategoryModal.slug,
        type: widget.getCategoryModal.type,
        itemId: widget.getCategoryModal.id,
        rowNumber: widget.getCategoryModal.rowNumber,
        onAdd: widget.onAdd,
        playAudio: widget.playAudio,
        flutterTts: widget.flutterTts,
        text: widget.getCategoryModal.name!,
        textPostion: widget.pictureAppearanceSettingModel!.textPosition!,
        onTap: widget.getCategoryModal.type == "voice" ? _onTap : () {},
        isImageAsset: false,
        itemColor: widget.getCategoryModal.color,
        buttonImage: widget.getCategoryModal.image != null
            ? "${widget.getCategoryModal.imagePath}${widget.getCategoryModal.image}"
            : null,
        imageSize: widget.imageSize,
        isImageShow: !(widget.pictureAppearanceSettingModel!.textSize! ==
            "only_text_(no_picture)"),
        backgroundColor: widget.getCategoryModal.type == "sub_categories"
            ? widget.hexToBordorColor(widget.getCategoryModal.type!)
            : hexToColor(
                widget.getCategoryModal.color, widget.getCategoryModal.type),
        borderColor: widget.getCategoryModal.type == "voice" ||
                widget.getCategoryModal.type == "sub_categories"
            ? widget.hexToBordorColor(widget.getCategoryModal.type!)
            : hexToColor(
                widget.getCategoryModal.color, widget.getCategoryModal.type),
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

Color hexToColor(String? hexString, String? type) {
  Color color = type == "voice"
      ? AppColorConstants.keyBoardBackColor
      : type == "sub_categories"
          ? AppColorConstants.keyBoardBackColorPink
          : AppColorConstants.keyBoardBackColorGreen;
  if (hexString == null) {
    return color;
  }
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  color = Color(int.parse(buffer.toString(), radix: 16));
  return color;
}
