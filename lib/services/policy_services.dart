import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jummi/endpoints.dart';
import 'package:jummi/models/Policy.dart';

class PolicyService {
  static var client = http.Client();

  static Future<dynamic> getPolicies() async {
    try {
      final response = await client.get(Uri.parse(get_policies_URL));
      if (response.statusCode == 200) {
        return policyFromJson(utf8.decode(response.bodyBytes));
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

class HuntingService {
  static var client = http.Client();

  static Future<dynamic> getHunting() async {
    try {
      final dynamic response = await client.get(Uri.parse(get_hunting_URL));
      if (response.statusCode == 200) {
        return response;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
