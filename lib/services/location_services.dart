import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jummi/endpoints.dart';
import 'package:jummi/models/Location.dart';

class LocationService {
  static var client = http.Client();

  static Future<dynamic> fetchLocationsAsString() async {
    try {
      final response = await client.get(
        Uri.parse(get_locations_URL),
      );
      if (response.statusCode == 200) {
        return utf8.decode(response.bodyBytes);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> fetchLocations() async {
    try {
      final response = await client.get(
        Uri.parse(get_locations_URL),
      );
      if (response.statusCode == 200) {
        return locationFromJson(utf8.decode(response.bodyBytes));
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
