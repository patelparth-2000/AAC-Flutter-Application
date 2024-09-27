import 'dart:async'; // Import the dart:async package
import 'dart:convert';
import 'package:avaz_app/util/app_color_constants.dart';
import 'package:avaz_app/util/images.dart';
import 'package:avaz_app/view/otp/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../API/common_api_call.dart';
import '../../common/common.dart';
import '../../common/common_button_widget.dart';
import '../../common/common_flag_text_field_widget.dart';
import '../../services/bulk_api_data.dart';
import '../../util/dimensions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _pageViewController = PageController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  FocusNode phoneNumberFocusNode = FocusNode();
  String countryCode = "IN";
  int pageIndex = 0;
  bool isLoginLoading = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    BulkApiData.getCategory(context);
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_pageViewController.hasClients) {
        int nextPage =
            (_pageViewController.page!.toInt() + 1) % _autoScrollPage.length;
        _pageViewController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    _timer.cancel();
    super.dispose();
  }

  final List<Map<String, dynamic>> _autoScrollPage = [
    {
      "info": "AAC builds confidence through communication",
      "images": Images.info1Image
    },
    {
      "info": "AAC is personalised for the communicator",
      "images": Images.info2Image
    },
    {
      "info": "Develop language & comprehension with AAC",
      "images": Images.info3Image
    }
  ];

  void getOtpFromNumber({number}) async {
    setState(() {
      isLoginLoading = true;
    });
    var response = await CommonApiCall.postApiCall(
        action: "customersendotp", body: {"mobile": "$number"});

    if (!mounted) return;

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData != null) {
        if (responseData["status"].toString() == "1") {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpScreen(
                  phoneNumber: _phoneNumberController.text.toString(),
                  countryCode: countryCode,
                ),
              ));
        } else {
          scaffoldMessengerMessage(
              message: responseData["message"].toString(), context: context);
        }
      }
    }
    setState(() {
      isLoginLoading = false;
    });
  }

  void getRegisterNumber({number}) async {
    var response =
        await CommonApiCall.postApiCall(action: "customerRegiste", body: {
      "name": "Test User",
      "mobile": "$number",
      "gender": "male",
      "age": "12",
    });
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData != null) {
        if (responseData["status"].toString() == "1") {}
      }
    }
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
            children: [
              SizedBox(
                height: Dimensions.screenHeight * 0.03,
              ),
              SizedBox(
                height: Dimensions.screenHeight * .46,
                child: Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: _pageViewController,
                        itemCount: _autoScrollPage.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = _autoScrollPage[index];
                          return Column(
                            children: [
                              Container(
                                height: Dimensions.screenHeight * 0.36,
                                width: Dimensions.screenWidth * 0.26,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: AppColorConstants.black)),
                                child: Image.asset(
                                  item["images"],
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                              SizedBox(
                                height: Dimensions.screenHeight * 0.007,
                              ),
                              Text(
                                item["info"],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: AppColorConstants.contentSecondary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          );
                        },
                        onPageChanged: (index) {
                          setState(() {
                            pageIndex = index;
                          });
                        },
                      ),
                    ),
                    SmoothPageIndicator(
                      controller: _pageViewController,
                      count: _autoScrollPage.length,
                      effect: const WormEffect(
                          dotHeight: 10,
                          dotWidth: 10,
                          spacing: 8,
                          dotColor: AppColorConstants.black20,
                          activeDotColor: AppColorConstants.sentimentDotColor),
                      onDotClicked: (index) {
                        _pageViewController.animateToPage(index,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.screenHeight * 0.06),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CommonFlagTextFieldWidget(
                        controller: _phoneNumberController,
                        focusNode: phoneNumberFocusNode,
                        hintText: "your phone number",
                        labelText: "Phone Number",
                        onChanged: (phone) {
                          setState(() {});
                        },
                        onCountryChanged: (country) {
                          countryCode = country.code.toString();
                        },
                      ),
                      SizedBox(height: Dimensions.screenHeight * 0.06),
                      CommonButtonWidget(
                        radius: 5.0,
                        paddingVertical: 4,
                        onTap: () {
                          if (_phoneNumberController.text.isNotEmpty &&
                              _phoneNumberController.text.length == 10) {
                            getOtpFromNumber(
                                number: _phoneNumberController.text.toString());
                          } else {}
                        },
                        isActive: _phoneNumberController.text.isNotEmpty &&
                                _phoneNumberController.text.length == 10
                            ? true
                            : false,
                        isLoading: isLoginLoading,
                        title: "Get Started",
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
