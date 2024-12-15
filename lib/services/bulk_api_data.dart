// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:avaz_app/common/common.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../api/common_api_call.dart';
import 'data_base_service.dart';

class BulkApiData {
  static void getCategory(BuildContext context) async {
    _settingDataInsert();
    _laungApi(context);
    var response = await CommonApiCall.postApiCall(action: "get_category");
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (responseData != null) {
        if (responseData["status"].toString() == "1") {
          final dataToStore = responseData["data"];
          final imageUrl = responseData["imageURL"];
          if (dataToStore != null && dataToStore is List) {
            // Iterate through the list and insert each item
            for (var item in dataToStore) {
              if (item is Map<String, dynamic>) {
                await _downloadFilesIfValid(item, imageUrl);
                await _insertApiResponseToDatabase(
                    item, "category_table", "type", "id");
              }
            }
            for (var item in dataToStore) {
              getSubCategory(
                  context, item["id"].toString(), item["slug"].toString());
              getVoice(context, item["id"].toString(), item["slug"].toString());
            }
          }
        } else {
          scaffoldMessengerMessage(
              message: responseData["message"].toString(), context: context);
        }
      }
    }
  }

  static void getSubCategory(
      BuildContext context, String categoryId, String categoryName) async {
    var response = await CommonApiCall.postApiCall(
        action: "get_sub_category", body: {"category_id": categoryId});

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (responseData != null) {
        if (responseData["status"].toString() == "1") {
          final dataToStore = responseData["data"];
          final imageUrl = responseData["imageURL"];
          if (dataToStore != null && dataToStore is List) {
            // Iterate through the list and insert each item
            for (var item in dataToStore) {
              if (item is Map<String, dynamic>) {
                await _downloadFilesIfValid(item, imageUrl);
                await _insertApiResponseToDatabase(
                    item, categoryName.replaceAll("-", "_"), "type", "id");
              }
            }
            for (var item in dataToStore) {
              getVoice(context, categoryId, item["slug"].toString(),
                  subCategoryId: item["id"].toString());
            }
          }
        } else {
          scaffoldMessengerMessage(
              message: responseData["message"].toString(), context: context);
        }
      }
    }
  }

  static void getVoice(
      BuildContext context, String categoryId, String categoryName,
      {String? subCategoryId}) async {
    dynamic response;
    if (subCategoryId != null) {
      response = await CommonApiCall.postApiCall(
          action: "get_voice",
          body: {"category_id": categoryId, "sub_category_id": subCategoryId});
    } else {
      response = await CommonApiCall.postApiCall(
          action: "get_voice", body: {"category_id": categoryId});
    }

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (responseData != null) {
        if (responseData["status"].toString() == "1") {
          final dataToStore = responseData["data"];
          final imageUrl = responseData["imageURL"];
          if (dataToStore != null && dataToStore is List) {
            // Iterate through the list and insert each item
            for (var item in dataToStore) {
              if (item is Map<String, dynamic>) {
                await _downloadFilesIfValid(item, imageUrl);
                await _insertApiResponseToDatabase(
                    item, categoryName.replaceAll("-", "_"), "type", "id");
              }
            }
          }
        } else {
          scaffoldMessengerMessage(
              message: responseData["message"].toString(), context: context);
        }
      }
    }
  }

  static Future<void> _laungApi(BuildContext context) async {
    var response = await CommonApiCall.postApiCall(action: "get_lang");
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData != null) {
        if (responseData["status"].toString() == "1") {
          final dataToStore = responseData["data"];
          if (dataToStore != null && dataToStore is List) {
            // Iterate through the list and insert each item
            for (var item in dataToStore) {
              if (item is Map<String, dynamic>) {
                await _insertApiResponseToDatabase(
                    item, "language_data_add", "slug", "id");
              }
            }
          }
        } else {
          scaffoldMessengerMessage(
              message: responseData["message"].toString(), context: context);
        }
      }
    }
  }

  // static Future<void> _asyncMethod(String imageUrl, String imageName) async {
  //   try {
  //     final url = Uri.parse('$imageUrl$imageName');
  //     var response = await http.get(url);
  //     if (response.statusCode == 200) {
  //       var documentDirectory = await getApplicationDocumentsDirectory();
  //       // ignore: avoid_print
  //       _insertApiResponseToDatabase({
  //         "id": "1",
  //         "type": "directoryPath",
  //         "path": "${documentDirectory.path}/"
  //       }, "directory_path", "id", "type");
  //       var filePath = '${documentDirectory.path}/$imageName';
  //       File file = File(filePath);
  //       await file.writeAsBytes(response.bodyBytes);
  //     } else {
  //       // ignore: avoid_print
  //       print('Failed to download image: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     // ignore: avoid_print
  //     print('Error downloading image: $e');
  //   }
  // }

  static Future<void> _asyncMethod(String fileUrl, String fileName,
      {bool isAudio = false}) async {
    try {
      final url = Uri.parse('$fileUrl$fileName');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var documentDirectory = await getApplicationDocumentsDirectory();
        // Store the directory path in the database
        _insertApiResponseToDatabase({
          "id": "1",
          "type": "directoryPath",
          "path": "${documentDirectory.path}/"
        }, "directory_path", "id", "type");

        var filePath = '${documentDirectory.path}/$fileName';
        File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
      } else {
        // Log failure
        // print('Failed to download file: ${response.statusCode}');
      }
    } catch (e) {
      // Log error
      // print('Error downloading file: $e');
    }
  }

  static Future<void> _downloadFilesIfValid(
      Map<String, dynamic> item, String fileUrl) async {
    // Download image file
    if (item["image"] != null &&
        !item["image"].toString().endsWith(".mp3") &&
        !item["image"].toString().endsWith(".wav")) {
      await _asyncMethod(fileUrl, item["image"]);
    }

    // Download audio file
    if (item["voice_file"] != null &&
        !item["voice_file"].toString().endsWith(".png") &&
        !item["voice_file"].toString().endsWith(".jpeg")) {
      await _asyncMethod(fileUrl, item["voice_file"], isAudio: true);
    } else {
      item["voice_file"] = null;
    }
  }

  static Future<void> _insertApiResponseToDatabase(Map<String, dynamic> apiData,
      String tableName, String uniqueType, String uniqueId) async {
    final dbService = DataBaseService.instance;
    // Dynamically create a table based on API data
    await dbService.createTablesFromApiData(
      tableName: tableName, // Define your table name
      apiData: apiData,
      uniqueType: uniqueType,
      uniqueId: uniqueId,
    );
  }

  static Future<void> _settingDataInsert() async {
    final dbService = DataBaseService.instance;
    await dbService.createSettingTables();
  }
}
