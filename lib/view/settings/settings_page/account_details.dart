import 'package:avaz_app/common/common.dart';
import 'package:avaz_app/view/settings/setting_widget.dart';
import 'package:flutter/material.dart';

import '../../../util/app_color_constants.dart';
import '../title_widget.dart';

class AccountDetails extends StatefulWidget {
  const AccountDetails({super.key});

  @override
  State<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(15),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text("Settings",
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
                        const TitleWidget(
                          text: "ACCOUNT DETAILS",
                        ),
                        textData("Registered Number: ", "+911234567890"),
                        textData("Subscription Plan: ", "Free trial"),
                        textData("Expired on: ", "04-jun-2024"),
                        const SizedBox(
                          height: 10,
                        ),
                        dividerWidget(
                            color: AppColorConstants.contentSecondary),
                        const SizedBox(
                          height: 10,
                        ),
                        SettingWidget(
                          text: "Delete Account",
                          onTap: () {},
                        ),
                        SettingWidget(
                          text: "Upload Crash Reports",
                          isSwitch: true,
                          switchValue: true,
                          onSwitchChanged: (value) {},
                        )
                      ]),
                ),
              )
            ]));
  }

  Widget textData(String text, String data) {
    return Row(
      children: [
        Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(
          data,
          style: const TextStyle(fontStyle: FontStyle.italic),
        )
      ],
    );
  }
}
