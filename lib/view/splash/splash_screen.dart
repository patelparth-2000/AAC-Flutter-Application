import 'dart:async';
import 'package:avaz_app/view/dashboard/DashboardScreen.dart';
import 'package:avaz_app/view/data_collection/data_collection_screen.dart';
import 'package:flutter/material.dart';
import '../../common/common_sharedPreferences.dart';
import '../../util/app_color_constants.dart';
import '../../util/app_constants.dart';
import '../../util/images.dart';
import '../login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late String? tocken;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      checkNextRoutePage();
    });
  }

  void checkNextRoutePage() async {
    String isOtpFinish = await getStringData(AppConstants.isOtpFinish);
    String isUserinfoFinish =
        await getStringData(AppConstants.isUserinfoFinish);
    if (isOtpFinish == "" || isOtpFinish != "yes") {
      getToNext(const LoginScreen());
    } else if (isUserinfoFinish == "" || isUserinfoFinish != "yes") {
      getToNext(const DataCollectionScreen());
    } else {
      getToNext(const DashboardScreen());
    }
  }

  void getToNext(Widget widget) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => widget,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.black,
      body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Image.asset(
            Images.splashImage,
            fit: BoxFit.fill,
          )),
    );
  }
}
