import 'package:avaz_app/view/settings/title_widget.dart';
import 'package:flutter/material.dart';

import '../../../util/app_color_constants.dart';
import '../setting_widget.dart';

class BackupRestore extends StatefulWidget {
  const BackupRestore({super.key});

  @override
  State<BackupRestore> createState() => _BackupRestoreState();
}

class _BackupRestoreState extends State<BackupRestore> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(15),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Password Protection Settings",
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
                      TitleWidget(text: "CLOUD STORAGE"),
                      SettingWidget(
                        text: "Securely save your backups to the cloud",
                        icon: Icons.link,
                      ),
                      TitleWidget(text: "BACKUP ACTIONS"),
                      SettingWidget(
                        isArrow: false,
                        text: "Create new backup",
                      ),
                      SettingWidget(
                        isArrow: false,
                        text: "Restore default vocabulary",
                      ),
                      SettingWidget(
                        text: "Manage Auto Backups",
                      ),
                      SettingWidget(
                        isArrow: false,
                        text: "Import From File Browser",
                      ),
                      TitleWidget(text: "YOUR BACKUPS"),
                      SettingWidget(
                        isArrow: false,
                        text: "No backups yet",
                      ),
                    ]),
              ),
            ),
          ],
        ));
  }
}
