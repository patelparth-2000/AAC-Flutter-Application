import 'package:avaz_app/common/common_image_button.dart';
import 'package:avaz_app/common/common_text_to_speak.dart';
import 'package:avaz_app/util/app_color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class CommonZoomAnimationWidget extends StatefulWidget {
  final String text;
  final String slug;
  final String type;
  final String? image;
  final Function(String text, String? image) onAdd;
  // final Function(String tablename) onNavigationChange;
  final FlutterTts flutterTts;

  const CommonZoomAnimationWidget({
    super.key,
    required this.text,
    this.image,
    required this.onAdd,
    required this.flutterTts,
    // required this.onNavigationChange,
    required this.type,
    required this.slug,
  });

  @override
  State<CommonZoomAnimationWidget> createState() =>
      _CommonZoomAnimationWidgetState();
}

class _CommonZoomAnimationWidgetState extends State<CommonZoomAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    widget.onAdd(widget.text, widget.image);
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
        slug: widget.slug,
        onAdd: widget.onAdd,
        flutterTts: widget.flutterTts,
        text: widget.text,
        onTap: widget.type == "voice" ? _onTap : () {},
        child: CommonImageButton(
          buttonImage: widget.image,
          imageSize: 55,
          isImageShow: true,
          backgroundColor: AppColorConstants.keyBoardBackColor,
          borderColor: AppColorConstants.keyBoardBackColor,
          textStyle: const TextStyle(
            color: AppColorConstants.keyBoardTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          buttonIconColor: null,
          buttonName: widget.text,
        ),
      ),
    );
  }
}
