import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:avaz_app/common/common_image_button.dart';
import 'package:avaz_app/util/app_color_constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../common/common.dart';
import '../../model/get_category_modal.dart';
import '../../services/data_base_service.dart';
import '../../services/permission_manager.dart';
import 'text_drop_widget.dart';

class EditWordsScreen extends StatefulWidget {
  const EditWordsScreen({super.key, required this.refreshGirdData});
  final Function() refreshGirdData;

  @override
  State<EditWordsScreen> createState() => _EditWordsScreenState();
}

class _EditWordsScreenState extends State<EditWordsScreen> {
  TextEditingController voiceController = TextEditingController();
  DropDownModel? selectedCategory;
  DropDownModel? selectedSubCategory;
  DropDownModel? selectedLang;
  String? imagePath;
  String? imageName;
  String? audioPath; // To store the selected audio file path
  String? audioName; // To display the selected audio file name
  String? directoryPath; // To display the selected audio file name
  bool isRecording = false;
  bool isPlaying = false;
  final recorder = FlutterSoundRecorder();
  final player = AudioPlayer();
  Duration currentPosition = Duration.zero;
  Duration audioDuration = Duration.zero;
  Duration recordingDuration = Duration.zero;
  Timer? timer;
  List<DropDownModel> categoryList = [];
  List<DropDownModel> subCategoryList = [];
  List<DropDownModel> languageList = [
    DropDownModel(id: "1", name: "Engilsh"),
    DropDownModel(id: "2", name: "Hindi"),
    DropDownModel(id: "3", name: "Gujrati"),
  ];
  List<GetCategoryModal> getCategoryModalList = [];
  List<GetCategoryModal> getSubCategoryModalList = [];
  String firstTableName = "category_table";
  final dbService = DataBaseService.instance;

  @override
  void initState() {
    super.initState();
    getDataFromDatabse();
    initializeRecorder();
  }

  void getDataFromDatabse() async {
    directoryPath = await dbService.directoryPath();
    var categoryData = await dbService.getCategoryTable();
    adddata(categoryData);
    setState(() {});
  }

  void adddata(categoryData) async {
    if (categoryData != null && categoryData is List) {
      for (var item in categoryData) {
        if (item is Map<String, dynamic>) {
          Map<String, dynamic> modifiableItem = Map<String, dynamic>.from(item);
          GetCategoryModal getCategoryModal =
              GetCategoryModal.fromJson(modifiableItem);
          getCategoryModalList.add(getCategoryModal);
          categoryList.add(DropDownModel(
              name: getCategoryModal.name!, id: getCategoryModal.id!));
        }
      }
    }
  }

  void addSubCategory(String tableName) async {
    getSubCategoryModalList.clear();
    subCategoryList.clear();
    var subcategoryData = await dbService.getTablesSubCategoryData(tableName);
    for (var subitem in subcategoryData) {
      if (subitem is Map<String, dynamic>) {
        Map<String, dynamic> modifiableSubItem =
            Map<String, dynamic>.from(subitem);
        GetCategoryModal getSubCategoryModal =
            GetCategoryModal.fromJson(modifiableSubItem);
        getSubCategoryModalList.add(getSubCategoryModal);
        subCategoryList.add(DropDownModel(
            name: getSubCategoryModal.name!, id: getSubCategoryModal.id!));
      }
    }
    selectedSubCategory = null;
    setState(() {});
  }

  Future<void> initializeRecorder() async {
    try {
      await recorder.openRecorder();
      await recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
    } catch (e) {
      debugPrint('Failed to initialize recorder: $e');
    }
  }

  Future<void> selectAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null) {
      File originalFile = File(result.files.single.path!);
      // final appDir = await getAppDirectory();
      final newPath = '$directoryPath/${result.files.single.name}';
      final savedFile = await originalFile.copy(newPath);

      setState(() {
        audioPath = savedFile.path;
        audioName = result.files.single.name;
      });
      // File file = File(result.files.single.path!);
      // setState(() {
      //   audioPath = file.path;
      //   audioName = result.files.single.name;
      // });

      await player.setSourceDeviceFile(audioPath!);
      audioDuration = await player.getDuration() ?? Duration.zero;
    }
  }

  Future<void> startRecording() async {
    bool permissionGranted =
        await PermissionManager.requestMicrophonePermission();
    if (permissionGranted) {
      // Directory tempDir = Directory.systemTemp;
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String filePath = '$directoryPath/recording_$timestamp.aac';
      // String filePath = '$directoryPath/temp_recording.aac';

      await recorder.startRecorder(toFile: filePath);

      setState(() {
        isRecording = true;
        recordingDuration = Duration.zero;
      });

      // Start the recording timer
      timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
        setState(() {
          recordingDuration =
              Duration(seconds: recordingDuration.inSeconds + 1);
        });
      });
    } else {
      showPermissionDeniedDialog();
    }
  }

  Future<void> stopRecording() async {
    if (timer != null) timer!.cancel(); // Stop the timer
    final path = await recorder.stopRecorder();

    setState(() {
      isRecording = false;
      audioPath = path;
      audioName = path?.split("/").last;
      recordingDuration = Duration.zero; // Reset the timer
    });

    if (audioPath != null) {
      await player.setSourceDeviceFile(audioPath!);
      audioDuration = await player.getDuration() ?? Duration.zero;
    }
  }

  Future<void> playAudio() async {
    if (audioPath != null) {
      setState(() {
        isPlaying = true;
      });
      await player.play(DeviceFileSource(audioPath!));
      player.onPositionChanged.listen((Duration position) {
        setState(() {
          currentPosition = position;
        });
      });

      player.onPlayerComplete.listen((_) {
        setState(() {
          isPlaying = false;
          currentPosition = Duration.zero;
        });
      });
    }
  }

  Future<void> stopAudio() async {
    await player.stop();
    setState(() {
      isPlaying = false;
      currentPosition = Duration.zero;
    });
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    player.dispose();
    super.dispose();
  }

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
            imageName = croppedFile.path.split("/").last;
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
    if (croppedFile != null) {
      // final appDir = await getAppDirectory();
      final newPath = '$directoryPath/${croppedFile.path.split('/').last}';
      final savedFile = await File(croppedFile.path).copy(newPath);
      return savedFile; // Returns the saved file in the app directory
    }
    return null;
  }

  void showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColorConstants.keyBoardBackColor,
        surfaceTintColor: AppColorConstants.keyBoardBackColor,
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(5)),
        title: const Text("Permission Denied"),
        content: const Text(
            "The required permission was not granted. Please allow permissions in app settings."),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: AppColorConstants.imageTextButtonColor,
                  borderRadius: BorderRadius.circular(5)),
              child: const Text(
                "Close",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColorConstants.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showErrorDialog({required String text}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColorConstants.keyBoardBackColor,
        surfaceTintColor: AppColorConstants.keyBoardBackColor,
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(5)),
        title: const Text("Field Required"),
        content: Text("$text field is Required"),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: AppColorConstants.imageTextButtonColor,
                  borderRadius: BorderRadius.circular(5)),
              child: const Text(
                "Close",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColorConstants.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool isValid() {
    if (selectedLang == null) {
      showErrorDialog(text: "Language");
      return false;
    }
    if (selectedCategory == null) {
      showErrorDialog(text: "Category");
      return false;
    }
    if (voiceController.text.isEmpty) {
      showErrorDialog(text: "Voice");
      return false;
    }
    return true;
  }

  void addData(BuildContext context) async {
    if (!isValid()) {
      return;
    }
    String tableName = "";
    Map<String, dynamic> data = {
      "id": null,
      "type": "voice",
      "lang": selectedLang?.id,
      "category_id": selectedCategory?.id,
      "sub_category_id": selectedSubCategory?.id,
      "name": voiceController.text,
      "code": null,
      "image": imageName,
      "slug": voiceController.text.toLowerCase().replaceAll(" ", "-"),
      "voice_file": audioName,
      "created_by": "1",
      "status": "active",
      "delete_status": "0",
      "category": null,
      "lang_name": null,
      "subcategory": null,
      // "imagePath": directoryPath,
    };

    if (selectedSubCategory != null) {
      for (var item in getSubCategoryModalList) {
        if (item.id == selectedSubCategory?.id) {
          tableName = item.slug!.replaceAll("-", "_");
          await dbService.insertDataIntoTableManual(
              tableName: tableName, data: data);
        }
      }
    } else {
      for (var item in getCategoryModalList) {
        if (item.id == selectedCategory?.id) {
          tableName = item.slug!.replaceAll("-", "_");
          await dbService.insertDataIntoTableManual(
              tableName: tableName, data: data);
        }
      }
    }
    widget.refreshGirdData();
    // ignore: use_build_context_synchronously
    addAPiData(context);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  void addAPiData(BuildContext context) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://sitedev.online/api/addVoice'));
    request.fields.addAll({
      'name': voiceController.text,
      'lang': selectedLang != null ? selectedLang!.id : "",
      'category_id': selectedCategory != null ? selectedCategory!.id : "",
      'sub_category_id':
          selectedSubCategory != null ? selectedSubCategory!.id : "",
      'created_by': '1'
    });
    if (imagePath != null) {
      request.files.add(
          await http.MultipartFile.fromPath('icon_image', imagePath ?? ""));
    }
    if (audioPath != null) {
      request.files.add(
          await http.MultipartFile.fromPath('voice_file_doc', audioPath ?? ""));
    }

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // ignore: avoid_print
      print(await response.stream.bytesToString());
    } else {
      // ignore: avoid_print
      print(response.reasonPhrase);
    }
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
                      addData(context);
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
          Expanded(
            child: SingleChildScrollView(
              child: Row(
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
                      SizedBox(
                        width: 200,
                        child: Text(
                          imageName ?? "",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 14),
                        ),
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
                            dropDownOnChanged: (value) {
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
                            dropDownOnChanged: (value) {
                              setState(() {
                                selectedCategory = value;
                                for (var getCategoryModal
                                    in getCategoryModalList) {
                                  if (getCategoryModal.id == value?.id) {
                                    String tableName = getCategoryModal.slug!
                                        .replaceAll("-", "_");
                                    addSubCategory(tableName);
                                  }
                                }
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
                            dropDownOnChanged: (value) {
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
                            hintText: "Enter voice",
                            text: "Voice",
                            isTextField: true,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          dividerWidget(),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 0,
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: const Text(
                                  "Select Voice File",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CommonImageButton(
                                        buttonIcon:
                                            Icons.my_library_music_rounded,
                                        isImageShow: true,
                                        onTap: () => selectAudio(),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      CommonImageButton(
                                        buttonIcon: isRecording
                                            ? Icons.stop
                                            : Icons.mic,
                                        isImageShow: true,
                                        onTap: isRecording
                                            ? stopRecording
                                            : startRecording,
                                      ),
                                      const SizedBox(width: 10),
                                      if (isRecording)
                                        Text(
                                          "${recordingDuration.inMinutes.toString().padLeft(2, '0')}:${(recordingDuration.inSeconds % 60).toString().padLeft(2, '0')}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  if (audioPath != null)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (audioName != null)
                                          SizedBox(
                                            child: Text(
                                              audioName!,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        Row(
                                          children: [
                                            CommonImageButton(
                                              buttonIcon: isPlaying
                                                  ? Icons.stop
                                                  : Icons.play_arrow,
                                              isImageShow: true,
                                              onTap: isPlaying
                                                  ? stopAudio
                                                  : playAudio,
                                            ),
                                            const SizedBox(width: 10),
                                            SizedBox(
                                              width: 200,
                                              child: Slider(
                                                value: currentPosition.inSeconds
                                                    .toDouble(),
                                                max: audioDuration.inSeconds
                                                    .toDouble(),
                                                activeColor: AppColorConstants
                                                    .imageTextButtonColor,
                                                onChanged: (value) async {
                                                  final newPosition = Duration(
                                                      seconds: value.toInt());
                                                  await player
                                                      .seek(newPosition);
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DropDownModel {
  String name;
  String id;

  DropDownModel({required this.name, required this.id});
}
