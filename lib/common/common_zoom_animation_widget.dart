import 'package:avaz_app/common/common_image_button.dart';
import 'package:avaz_app/common/common_text_to_speak.dart';
import 'package:avaz_app/util/app_color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../model/get_category_modal.dart';
import '../services/data_base_service.dart';

class CommonZoomAnimationWidget extends StatefulWidget {
  final Function(String text, String? image) onAdd;
  final Function(String slug) changeTable;
  final GetCategoryModal getCategoryModal;
  final FlutterTts flutterTts;

  const CommonZoomAnimationWidget({
    super.key,
    required this.onAdd,
    required this.flutterTts,
    required this.changeTable,
    required this.getCategoryModal,
  });

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
    widget.onAdd(widget.getCategoryModal.name!,
        "${widget.getCategoryModal.imagePath}${widget.getCategoryModal.image}");
    _controller.forward();
    Future.delayed(const Duration(seconds: 1), () {
      _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: CommonTextToSpeak(
        changeTable: widget.changeTable,
        slug: widget.getCategoryModal.slug,
        type: widget.getCategoryModal.type,
        onAdd: widget.onAdd,
        flutterTts: widget.flutterTts,
        text: widget.getCategoryModal.name!,
        onTap: widget.getCategoryModal.type == "voice" ? _onTap : () {},
        child: CommonImageButton(
          isImageAsset: false,
          buttonImage: widget.getCategoryModal.image != null
              ? "${widget.getCategoryModal.imagePath}${widget.getCategoryModal.image}"
              : null,
          imageSize: 55,
          isImageShow: true,
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
          textStyle: const TextStyle(
            color: AppColorConstants.keyBoardTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          buttonIconColor: null,
          buttonName: widget.getCategoryModal.name,
        ),
      ),
    );
  }
}
