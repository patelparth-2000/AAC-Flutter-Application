import 'dart:convert';

import 'package:avaz_app/common/common.dart';
import 'package:flutter/material.dart';

import '../api/common_api_call.dart';
import 'data_base_service.dart';

class BulkApiData {
  static void getCategory(BuildContext context) async {
    var response = await CommonApiCall.postApiCall(action: "get_category");

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
          if (dataToStore != null && dataToStore is List) {
            // Iterate through the list and insert each item
            for (var item in dataToStore) {
              if (item is Map<String, dynamic>) {
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
          if (dataToStore != null && dataToStore is List) {
            // Iterate through the list and insert each item
            for (var item in dataToStore) {
              if (item is Map<String, dynamic>) {
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
}
