import 'dart:io';

import 'package:avaz_app/common/common_image_button.dart';
import 'package:avaz_app/util/app_color_constants.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/common.dart';
import '../../services/permission_manager.dart';
import 'text_drop_widget.dart';

class EditWordsScreen extends StatefulWidget {
  const EditWordsScreen({super.key});

  @override
  State<EditWordsScreen> createState() => _EditWordsScreenState();
}

class _EditWordsScreenState extends State<EditWordsScreen> {
  TextEditingController voiceController = TextEditingController();
  String? selectedCategory;
  String? selectedSubCategory;
  String? selectedLang;
  String? imagePath;
  List<String> categoryList = ["Play Chess", "Play game"];
  List<String> subCategoryList = ["Play Chess", "Play game"];
  List<String> languageList = ["Englis", "Hindi"];

  Future<void> selectImage(ImageSource source) async {
    bool permissionGranted = false;

    if (source == ImageSource.camera) {
      permissionGranted = await PermissionManager.requestCameraPermission();
    } else if (source == ImageSource.gallery) {
      permissionGranted = await PermissionManager.requestGalleryPermission();
    }

    if (permissionGranted) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        final croppedFile = await cropImage(pickedFile.path);

        if (croppedFile != null) {
          setState(() {
            imagePath = croppedFile.path;
          });
        }
      }
    } else {
      showPermissionDeniedDialog();
    }
  }

  Future<File?> cropImage(String imagePath) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1), // Square crop
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: AppColorConstants.buttonColorBlue1,
          toolbarWidgetColor: Colors.white,
          hideBottomControls: true,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Crop Image',
          aspectRatioLockEnabled: true,
        ),
      ],
    );

    return croppedFile != null ? File(croppedFile.path) : null;
  }

  void showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Permission Denied"),
        content: const Text(
            "The required permission was not granted. Please allow permissions in app settings."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.keyBoardBackColor,
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Close",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColorConstants.buttonColorBlue1),
                    ),
                  ),
                ),
                const Text(
                  "Add a new voice",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColorConstants.buttonColorBlue1),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColorConstants.buttonColorBlue1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          dividerWidget(height: 0.5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 30),
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColorConstants.buttonColorBlue2),
                    child: imagePath != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(File(imagePath!)))
                        : null,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 110,
                        child: Text(
                          "Select Image",
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 16),
                        ),
                      ),
                      CommonImageButton(
                        buttonIcon: Icons.camera_alt,
                        isImageShow: true,
                        onTap: () => selectImage(ImageSource.camera),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      CommonImageButton(
                        buttonIcon: Icons.image_rounded,
                        isImageShow: true,
                        onTap: () => selectImage(ImageSource.gallery),
                      )
                    ],
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      TextDropWidget(
                        hintText: "Select Language",
                        text: "Language",
                        items: languageList,
                        value: selectedLang,
                        onChanged: (value) {
                          setState(() {
                            selectedLang = value;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextDropWidget(
                        hintText: "Select Category",
                        text: "Category",
                        items: categoryList,
                        value: selectedCategory,
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      dividerWidget(),
                      const SizedBox(
                        height: 5,
                      ),
                      TextDropWidget(
                        hintText: "Select Sub Category",
                        text: "Sub Category",
                        items: subCategoryList,
                        value: selectedSubCategory,
                        onChanged: (value) {
                          setState(() {
                            selectedSubCategory = value;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextDropWidget(
                        controller: voiceController,
                        hintText: "Type voice",
                        text: "Voice",
                        isTextField: true,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      dividerWidget(),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
