import 'package:flutter/material.dart';

import '../../util/app_color_constants.dart';
import '../settings/setting_widget.dart';

class AccBooks extends StatefulWidget {
  const AccBooks({super.key});

  @override
  State<AccBooks> createState() => _AccBooksState();
}

class _AccBooksState extends State<AccBooks> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(15),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Tools",
                style: TextStyle(
                    color: AppColorConstants.buttonColorBlue2,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SettingWidget(
                        text: "No Books found",
                        isArrow: false,
                      ),
                    ]),
              ),
            )
          ],
        ));
  }
}
