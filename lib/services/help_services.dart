import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jummi/endpoints.dart';
import 'package:jummi/models/Contact.dart';
import 'package:jummi/models/Help.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelpService {
  static var client = http.Client();

  static Future<dynamic> getContacts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final response = await client.get(
        Uri.parse(get_contacts_URL),
        headers: {
          'Authorization': prefs.getString('access_token').toString(),
        },
      );
      if (response.statusCode == 200) {
        return contactFromJson(utf8.decode(response.bodyBytes));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> getHelps() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final response = await client.get(
        Uri.parse(get_helps_URL),
        headers: {
          'Authorization': prefs.getString('access_token').toString(),
        },
      );
      if (response.statusCode == 200) {
        return helpFromJson(utf8.decode(response.bodyBytes));
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
