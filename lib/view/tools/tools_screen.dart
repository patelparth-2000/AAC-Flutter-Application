import 'package:avaz_app/view/tools/acc_books.dart';
import 'package:flutter/material.dart';

import '../../util/app_color_constants.dart';
import '../settings/setting_widget.dart';
import '../settings/title_widget.dart';

class ToolsScreen extends StatefulWidget {
  const ToolsScreen({super.key, required this.drawerNavigatorKey});
  final GlobalKey<NavigatorState> drawerNavigatorKey;

  @override
  State<ToolsScreen> createState() => _ToolsScreenState();
}

class _ToolsScreenState extends State<ToolsScreen> {
  void nextpage(Widget nextWidget) {
    widget.drawerNavigatorKey.currentState?.push(MaterialPageRoute(
      builder: (context) => nextWidget,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text("Tools",
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
                      const TitleWidget(text: "LOW TECH"),
                      const SettingWidget(
                        text: "Create an TouchVoz Book with Home",
                        isArrow: false,
                      ),
                      SettingWidget(
                        text: "Browse all TouchVoz Books",
                        onTap: () {
                          nextpage(const AccBooks());
                        },
                      ),
                    ]),
              ),
            )
          ],
        ));
  }
}
