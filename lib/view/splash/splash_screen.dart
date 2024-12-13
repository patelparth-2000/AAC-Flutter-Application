// import 'dart:async';
// import 'package:avaz_app/view/dashboard/DashboardScreen.dart';
// import 'package:avaz_app/view/data_collection/data_collection_screen.dart';
// import 'package:flutter/material.dart';
// import '../../common/common_sharedPreferences.dart';
// import '../../util/app_color_constants.dart';
// import '../../util/app_constants.dart';
// import '../../util/images.dart';
// import '../login/login_screen.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   late String? tocken;

//   @override
//   void initState() {
//     super.initState();
//     Timer(const Duration(seconds: 3), () {
//       checkNextRoutePage();
//     });
//   }

//   void checkNextRoutePage() async {
//     String isOtpFinish = await getStringData(AppConstants.isOtpFinish);
//     String isUserinfoFinish =
//         await getStringData(AppConstants.isUserinfoFinish);
//     if (isOtpFinish == "" || isOtpFinish != "yes") {
//       getToNext(const LoginScreen());
//     } else if (isUserinfoFinish == "" || isUserinfoFinish != "yes") {
//       getToNext(const DataCollectionScreen());
//     } else {
//       getToNext(const DashboardScreen());
//     }
//   }

//   void getToNext(Widget widget) {
//     Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => widget,
//         ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColorConstants.black,
//       body: SizedBox(
//           height: double.infinity,
//           width: double.infinity,
//           child: Image.asset(
//             Images.splashImage,
//             fit: BoxFit.fill,
//           )),
//     );
//   }
// }

import 'package:avaz_app/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:avaz_app/view/dashboard/DashboardScreen.dart';
import 'package:avaz_app/view/data_collection/data_collection_screen.dart';
import '../../common/common_sharedPreferences.dart';
import '../../util/app_color_constants.dart';
import '../../util/app_constants.dart';
import '../login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize the video controller
    _controller =
        VideoPlayerController.asset('assets/images/ACC-Splash-video.mp4')
          ..initialize().then((_) {
            // Start the video playback
            setState(() {
              _controller.play();
            });
            // Navigate to the next screen after the video ends
            _controller.addListener(() {
              if (_controller.value.position == _controller.value.duration) {
                checkNextRoutePage();
              }
            });
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
      backgroundColor: AppColorConstants.white,
      body: Stack(
        children: [
          // Video player as the background
          if (_controller.value.isInitialized)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  width: Dimensions.screenHeight,
                  height: Dimensions.screenHeight,
                  child: VideoPlayer(_controller),
                ),
              ),
            ),
          // Optional: Add a logo overlay or any other widgets on top of the video
          // const Center(
          //   child: Text(
          //     "Loading...",
          //     style: TextStyle(
          //         color: Colors.white,
          //         fontSize: 24,
          //         fontWeight: FontWeight.bold),
          //   ),
          // ),
        ],
      ),
    );
  }
}
