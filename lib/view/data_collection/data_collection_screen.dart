import 'package:flutter/material.dart';

import '../../common/common_button_widget.dart';
import '../../common/common_sharedPreferences.dart';
import '../../common/common_text_field_widget.dart';
import '../../util/app_color_constants.dart';
import '../../util/app_constants.dart';
import '../../util/dimensions.dart';
import '../dashboard/DashboardScreen.dart';

class DataCollectionScreen extends StatefulWidget {
  const DataCollectionScreen({super.key});

  @override
  State<DataCollectionScreen> createState() => _DataCollectionScreenState();
}

class _DataCollectionScreenState extends State<DataCollectionScreen> {
  String _selectedGender = '';
  String _selectedGrid = '4x6 Picture Grid';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();
  FocusNode ageFocusNode = FocusNode();

  void _handleRadioGenderValueChange(String? value) {
    setState(() {
      _selectedGender = value!;
    });
  }

  void _handleRadioGridValueChange(String? value) {
    setState(() {
      _selectedGrid = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: Dimensions.screenWidth
 * .1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: Dimensions.screenHeight
 * 0.06),
              const Text(
                "Let's set up AAC for the Communicator",
                style: TextStyle(
                    color: AppColorConstants.textTitle2,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: Dimensions.screenHeight
 * 0.07),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonTextFieldWidget(
                          controller: _nameController,
                          focusNode: nameFocusNode,
                          hintText: "Communicator's name",
                          labelText: "Name",
                          onChanged: (phone) {
                            setState(() {});
                          },
                        ),
                        SizedBox(height: Dimensions.screenHeight
 * 0.06),
                        CommonTextFieldWidget(
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          focusNode: ageFocusNode,
                          hintText: "Communicator's Age (1-100 years)",
                          labelText: "Age",
                          onChanged: (phone) {
                            setState(() {});
                          },
                        ),
                        SizedBox(height: Dimensions.screenHeight
 * 0.06),
                        const Text("Preferred Gender Pronoun"),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            rowRadioButton('He', _selectedGender,
                                _handleRadioGenderValueChange),
                            rowRadioButton('She', _selectedGender,
                                _handleRadioGenderValueChange),
                            rowRadioButton('They', _selectedGender,
                                _handleRadioGenderValueChange),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: Dimensions.screenWidth
 * .1,
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        const Text(
                          "Select a picture grid that best describes the Communicator",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        rowRadioButton('3x5 Picture Grid', _selectedGrid,
                            _handleRadioGridValueChange),
                        rowRadioButton('4x6 Picture Grid', _selectedGrid,
                            _handleRadioGridValueChange),
                        rowRadioButton('5x8 Picture Grid', _selectedGrid,
                            _handleRadioGridValueChange),
                        const Text(
                          "You can change this from Settings at any point in time",
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              color: AppColorConstants.contentSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.screenHeight
 * 0.06),
              SizedBox(
                width: Dimensions.screenWidth
 * .3,
                child: CommonButtonWidget(
                  radius: 5.0,
                  paddingVertical: 4,
                  onTap: () {
                    setStringData(AppConstants.isUserinfoFinish, "yes");
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DashboardScreen(),
                        ));
                  },
                  title: "Get Started",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget rowRadioButton(
      String text, String selectItem, Function(String?)? onChanged) {
    return Row(
      children: [
        Transform.scale(
          scale: 1.3,
          child: Radio<String>(
            focusColor: AppColorConstants.textTitle2,
            hoverColor: AppColorConstants.textTitle2,
            activeColor: AppColorConstants.textTitle2,
            fillColor: WidgetStateProperty.resolveWith<Color?>(
              (states) => AppColorConstants.textTitle2,
            ),
            value: text,
            groupValue: selectItem,
            onChanged: onChanged,
          ),
        ),
        Text(text),
      ],
    );
  }
}
