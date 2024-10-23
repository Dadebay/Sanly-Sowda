import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jummi/endpoints.dart';
import 'package:jummi/models/Noti.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotiService {
  static var client = http.Client();

  static Future<dynamic> fetchNotifications() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final response = await client.get(
        Uri.parse(get_notifications_URL),
        headers: {
          'Accept': 'application/json',
          'Authorization': prefs.getString('access_token') != null && prefs.getString('access_token') != '' ? "Bearer ${prefs.getString("access_token")}" : '',
        },
      );
      return response;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> fetchNotificationsTwo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final response = await client.get(
        Uri.parse(get_notifications_URL),
        headers: {
          'Accept': 'application/json',
          'Authorization': prefs.getString('access_token') != null && prefs.getString('access_token') != '' ? "Bearer ${prefs.getString("access_token")}" : '',
        },
      );
      return notiFromJson(utf8.decode(response.bodyBytes));
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> fetchNotification(id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final response = await client.get(
        Uri.parse('${get_notification_URL + id}/'),
        headers: {
          'Accept': 'application/json',
          'Authorization': prefs.getString('access_token') != null && prefs.getString('access_token') != '' ? "Bearer ${prefs.getString("access_token")}" : '',
        },
      );
      return response;
    } catch (e) {
      return null;
    }
  }
}
