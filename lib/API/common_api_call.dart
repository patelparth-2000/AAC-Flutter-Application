// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'package:avaz_app/api/api.dart';
import 'package:http/http.dart' as http;

class CommonApiCall {
  static Future<dynamic> postApiCall(
      {required String action, Object? body, headers}) async {
    var response;
    final url = Uri.parse(
      '${Api.baseUrl}$action',
    );
    try {
      print('$action request ===> $body');
      print('$action ===> $url');
      response = await http.post(url, body: body, headers: headers);
      print("response.body $action ==== > ${response.body}");
    } catch (e) {
      print('error api: $e');
    }
    return response;
  }

  static Future<dynamic> getApiCall(
      {required String action, params, headers}) async {
    var response;
    final url = Uri.parse(
      '${Api.baseUrl}$action${getMapData(params)}',
      // ${getParams(params)}',
    );
    try {
      print('$action $params ===> $url');
      response = await http.get(url, headers: headers);
      print('$action response.body ===> ${response.body}');
    } catch (e) {
      print('error api: $e');
    }
    return response;
  }

  static String getParams(params) {
    if (params == null || params.isEmpty) {
      return "";
    }
    return "/$params";
  }

  static String getMapData(Map<dynamic, dynamic>? params) {
    if (params == null || params.isEmpty) {
      return "";
    }
    String data = "";
    params.forEach((key, value) {
      data += "$key=$value&";
    });

    // Check if data is not empty before removing the last character
    if (data.isNotEmpty) {
      data = data.substring(0, data.length - 1);
    }
    return data;
  }
}
