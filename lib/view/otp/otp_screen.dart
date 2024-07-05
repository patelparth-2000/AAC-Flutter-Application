import 'dart:async';
import 'dart:convert';

import 'package:avaz_app/common/common_text_field_widget.dart';
import 'package:avaz_app/util/app_color_constants.dart';
import 'package:avaz_app/util/app_constants.dart';
import 'package:avaz_app/view/data_collection/data_collection_screen.dart';
import 'package:flutter/material.dart';

import '../../API/common_api_call.dart';
import '../../common/common.dart';
import '../../common/common_button_widget.dart';
import '../../common/common_flag_text_field_widget.dart';
import '../../common/common_sharedPreferences.dart';
import '../../util/dimensions.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen(
      {super.key, required this.phoneNumber, required this.countryCode});
  final String phoneNumber;
  final String countryCode;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  FocusNode phoneNumberFocusNode = FocusNode();
  FocusNode optFocusNode = FocusNode();
  String initialCountryCode = "IN";
  bool isButtonDisabled = true;
  bool isOtpLoading = false;
  int countdown = 45;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _phoneNumberController.text = widget.phoneNumber;
    initialCountryCode = widget.countryCode;
    startCountdown();
    setState(() {});
  }

  @override
  void dispose() {
    timer?.cancel();
    _phoneNumberController.dispose();
    _otpController.dispose();
    phoneNumberFocusNode.dispose();
    optFocusNode.dispose();
    super.dispose();
  }

  void getOtpFromNumber({number, otp}) async {
    setState(() {
      isOtpLoading = true;
    });
    var response = await CommonApiCall.postApiCall(
        action: "customerlogin", body: {"mobile": "$number", "otp": "$otp"});

    if (!mounted) return;

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData != null) {
        if (responseData["status"].toString() == "1") {
          setStringData(AppConstants.isOtpFinish, "yes");
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const DataCollectionScreen(),
            ),
            (route) => false,
          );
        } else {
          // ignore: avoid_print
          print("message === > ${responseData["message"].toString()}");
          scaffoldMessengerMessage(
              message: responseData["message"].toString(), context: context);
        }
      }
    } else if (response.statusCode == 403) {
      final responseData = json.decode(response.body);
      if (responseData != null) {
        scaffoldMessengerMessage(
            message: responseData["message"].toString(), context: context);
      }
      setState(() {
        isOtpLoading = false;
      });
    }
  }

  void startCountdown() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (countdown == 0) {
        setState(() {
          timer.cancel();
          isButtonDisabled = false;
        });
      } else {
        setState(() {
          countdown--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.baseBG,
      body: SingleChildScrollView(
        child: Container(
          margin:
              EdgeInsets.symmetric(horizontal: Dimensions.screenWidth * .15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Dimensions.screenHeight * 0.06),
              const Text(
                "Get Started",
                style: TextStyle(
                    color: AppColorConstants.textTitle,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: Dimensions.screenHeight * 0.06),
              CommonFlagTextFieldWidget(
                controller: _phoneNumberController,
                focusNode: phoneNumberFocusNode,
                hintText: "your phone number",
                labelText: "Phone Number",
                initialCountryCode: initialCountryCode,
                onChanged: (phone) {
                  setState(() {});
                },
                onCountryChanged: (country) {},
              ),
              SizedBox(height: Dimensions.screenHeight * 0.04),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: Dimensions.screenWidth * 0.33,
                    child: CommonButtonWidget(
                      radius: 5.0,
                      paddingVertical: 4,
                      onTap: isButtonDisabled
                          ? () {}
                          : () {
                              isButtonDisabled = true;
                              countdown = 45;
                              setState(() {});
                              startCountdown();
                            },
                      isActive: (_phoneNumberController.text.isNotEmpty &&
                          _phoneNumberController.text.length == 10),
                      title: isButtonDisabled
                          ? "Wait for ${countdown}s"
                          : "Resend OTP",
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.screenHeight * 0.04),
              CommonTextFieldWidget(
                controller: _otpController,
                focusNode: optFocusNode,
                hintText: "Otp",
                labelText: "Otp",
                onChanged: (phone) {
                  setState(() {});
                },
              ),
              SizedBox(height: Dimensions.screenHeight * 0.06),
              CommonButtonWidget(
                radius: 5.0,
                paddingVertical: 4,
                onTap: () {
                  if (_phoneNumberController.text.isNotEmpty &&
                      _phoneNumberController.text.length == 10 &&
                      _otpController.text.isNotEmpty) {
                    getOtpFromNumber(
                        number: _phoneNumberController.text.toString(),
                        otp: _otpController.text.toString());
                  }
                },
                isActive: _phoneNumberController.text.isNotEmpty &&
                        _phoneNumberController.text.length == 10 &&
                        _otpController.text.isNotEmpty
                    ? true
                    : false,
                isLoading: isOtpLoading,
                title: "Continue",
              ),
              SizedBox(height: Dimensions.screenHeight * 0.04),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Need help? Contact AAC Support via ",
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: AppColorConstants.textTitle,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Email",
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        decoration: TextDecoration.underline,
                        color: AppColorConstants.textTitle,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    " or ",
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: AppColorConstants.textTitle,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "WhatsApp",
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        decoration: TextDecoration.underline,
                        color: AppColorConstants.textTitle,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
