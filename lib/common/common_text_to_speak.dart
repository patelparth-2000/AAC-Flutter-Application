import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../model/get_category_modal.dart';
import '../services/data_base_service.dart';
import '../view/grid_data/grid_date_screen.dart';

class CommonTextToSpeak extends StatefulWidget {
  const CommonTextToSpeak(
      {super.key,
      required this.text,
      required this.child,
      required this.flutterTts,
      required this.onTap,
      this.slug,
      this.onAdd});
  final String text;
  final String? slug;
  final Widget child;
  final FlutterTts flutterTts;
  final Function(String text, String? image)? onAdd;
  final Function() onTap;

  @override
  State<CommonTextToSpeak> createState() => _CommonTextToSpeakState();
}

class _CommonTextToSpeakState extends State<CommonTextToSpeak> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> speakToText(String text) async {
    if (text.isNotEmpty) {
      await widget.flutterTts.speak(text);
    }
  }

  List<GetCategoryModal> getCategoryModalList = [];

  void getDataFromDatabse(String tableName) async {
    final dbService = DataBaseService.instance;
    var categoryData = await dbService.getTablesData(tableName);
    if (categoryData != null && categoryData is List) {
      for (var item in categoryData) {
        if (item is Map<String, dynamic>) {
          getCategoryModalList.add(GetCategoryModal.fromJson(item));
        }
      }
    }
    changePageData();
  }

  void changePageData() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GridDateScreen(
          flutterTts: widget.flutterTts,
          getCategoryModalList: getCategoryModalList,
          onAdd: widget.onAdd!,
        ), // Replace with your new screen
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.slug != null && widget.slug != "voice"
          ? () {
              speakToText(widget.text);
              getDataFromDatabse(widget.slug!.replaceAll("-", "_"));
            }
          : () {
              // ignore: avoid_print
              print("text == > ${widget.text}");
              speakToText(widget.text);
              widget.onTap();
            },
      child: widget.child,
    );
  }

  @override
  void dispose() {
    widget.flutterTts.stop();
    super.dispose();
  }
}
