import 'package:avaz_app/util/app_color_constants.dart';
import 'package:flutter/material.dart';

class RadioButton extends StatefulWidget {
  const RadioButton(
      {super.key,
      required this.radioList,
      required this.onTap,
      this.isMultipal = false,
      this.physics,
      this.flex = 1});
  final List<RadioButtonModel> radioList;
  final Function() onTap;
  final bool isMultipal;
  final ScrollPhysics? physics;
  final int flex;

  @override
  State<RadioButton> createState() => _RadioButtonState();
}

class _RadioButtonState extends State<RadioButton> {
  void _onItemTapped(int index) {
    setState(() {
      if (widget.isMultipal) {
        widget.radioList[index].select = !widget.radioList[index].select;
      } else {
        for (int i = 0; i < widget.radioList.length; i++) {
          widget.radioList[i].select = (i == index);
        }
      }
    });
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.flex,
      child: ListView.builder(
        physics: widget.physics,
        shrinkWrap: true,
        primary: true,
        itemCount: widget.radioList.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              _onItemTapped(index);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 25,
                    child: Text(
                      widget.radioList[index].name,
                      style: const TextStyle(
                          color: AppColorConstants.keyTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (widget.radioList[index].select)
                    const Icon(
                      Icons.check_circle,
                      color: AppColorConstants.keyTextColor,
                    )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class RadioButtonModel {
  String name;
  bool select;
  RadioButtonModel({required this.name, this.select = false});
}
