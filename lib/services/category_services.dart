import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jummi/endpoints.dart';
import 'package:jummi/models/Category.dart';

class CategoryService {
  static var client = http.Client();

  static Future<dynamic> fetchCategoriesAsString() async {
    try {
      final response = await client.get(
        Uri.parse(get_all_categories_URL),
      );
      if (response.statusCode == 200) {
        return utf8.decode(response.bodyBytes);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> fetchTopCategories() async {
    try {
      final response = await client.get(
        Uri.parse(get_top_categories_URL),
      );
      if (response.statusCode == 200) {
        return categoryFromJson(utf8.decode(response.bodyBytes));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> fetchAllCategories() async {
    try {
      final response = await client.get(
        Uri.parse(get_all_categories_URL),
      );
      if (response.statusCode == 200) {
        return categoryFromJson(utf8.decode(response.bodyBytes));
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
