// ignore_for_file: unnecessary_statements, unrelated_type_equality_checks, depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jummi/constants.dart';
import 'package:jummi/controllers/ecommerces_filter.dart';
import 'package:jummi/endpoints.dart';
import 'package:jummi/models/HomeStore.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EcommerceService {
  static var client = http.Client();

  static Future<dynamic> fetchEcommerces(page) async {
    final EcommercesFilterController efController = Get.put(EcommercesFilterController());
    try {
      final response = await client.get(
        Uri.parse(
          "$get_ecommerces_URL?page=$page&size=10&word=${efController.word}&categories=${efController.categories.map((category) => category.id).toList()}&locations=${efController.locations.map((location) => location.id).toList()}&topRated=${efController.topRated == true ? '1' : '0'}&delivery=${efController.delivery == true ? '1' : '0'}",
        ),
      );
      return response;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> fetchEcommerce(id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final response = await client.get(
        Uri.parse('$get_ecommerce_URL$id/'),
        headers: {'Accept': 'application/json', 'Authorization': prefs.getString('access_token') != null && prefs.getString('access_token') != '' ? "Bearer ${prefs.getString("access_token")}" : ''},
      );
      if (response.statusCode == 500) {
        removeToken();
      }
      return response;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> followEcommerce(id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final response = await client.post(
        Uri.parse('$follow_ecommerce_URL$id/'),
        headers: {'Accept': 'application/json', 'Authorization': prefs.getString('access_token') != null && prefs.getString('access_token') != '' ? "Bearer ${prefs.getString("access_token")}" : ''},
      );
      return response;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> makeMyEcommerce(id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final response = await client.post(
        Uri.parse('$make_my_ecommerce_URL$id/'),
        headers: {'Accept': 'application/json', 'Authorization': prefs.getString('access_token') != null && prefs.getString('access_token') != '' ? "Bearer ${prefs.getString("access_token")}" : ''},
      );
      return response;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> rateEcommerce(id, star) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final response = await client.post(
        Uri.parse('$rate_ecommerce_URL$id/'),
        headers: {
          'Accept': 'application/json',
          'Authorization': prefs.getString('access_token') != null && prefs.getString('access_token') != '' ? "Bearer ${prefs.getString("access_token")}" : '',
        },
        body: {'star': json.encode(star)},
      );
      return response;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> createEcommerce(
    String? name,
    String? description,
    bool? delivery,
    String deliveryPrice,
    List<int?>? categories,
    int? location,
    String? locationStr,
    String? latitude,
    String? longitude,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final response = await client.post(
        Uri.parse(create_ecommerce_URL),
        headers: {
          'Accept': 'application/json',
          'Authorization': prefs.getString('access_token') != null && prefs.getString('access_token') != '' ? "Bearer ${prefs.getString("access_token")}" : '',
        },
        body: {
          'name': name,
          'description': description,
          'delivery': delivery! ? '1' : '0',
          'delivery_price': deliveryPrice.toString(),
          'categories': categories.toString(),
          'location': location.toString(),
          'location_str': locationStr,
          'map_latitude': latitude,
          'map_longitude': longitude,
        },
      );
      return response;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> updateAvatar(int? id, File? image, String? action) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$update_ecommerce_URL$id/'),
      );
      image != null
          ? request.files.add(
              http.MultipartFile(
                'avatar',
                image.readAsBytes().asStream(),
                image.lengthSync(),
                filename: basename(image.path).split('/').last,
              ),
            )
          : '';
      request.fields['avatar_action'] = action.toString();
      request.headers
          .addAll({'Accept': 'application/json', 'Authorization': prefs.getString('access_token') != null && prefs.getString('access_token') != '' ? "Bearer ${prefs.getString("access_token")}" : ''});
      final response = await request.send();
      return response;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> updateWallpaper(int? id, File? image, String? action) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$update_ecommerce_URL$id/'),
      );
      image != null
          ? request.files.add(
              http.MultipartFile(
                'wallpaper',
                image.readAsBytes().asStream(),
                image.lengthSync(),
                filename: basename(image.path).split('/').last,
              ),
            )
          : '';
      request.fields['wallpaper_action'] = action.toString();
      request.headers
          .addAll({'Accept': 'application/json', 'Authorization': prefs.getString('access_token') != null && prefs.getString('access_token') != '' ? "Bearer ${prefs.getString("access_token")}" : ''});
      final response = await request.send();
      return response;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> updateInfo(
    int? id,
    String? name,
    String? description,
    bool? delivery,
    double deliveryPrice,
    List<int?>? categories,
    String? location,
    int? locationId,
    String? mapLatitude,
    String? mapLongitude,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final response = await client.post(
        Uri.parse('$update_ecommerce_URL$id/'),
        headers: {
          'Accept': 'application/json',
          'Authorization': prefs.getString('access_token') != null && prefs.getString('access_token') != '' ? "Bearer ${prefs.getString("access_token")}" : '',
        },
        body: {
          'name': name,
          'description': description,
          'delivery': delivery! ? 'True' : 'False',
          'delivery_price': deliveryPrice.toString(),
          'categories': categories.toString(),
          'location_str': location,
          'location_id': locationId.toString(),
          'map_latitude': mapLatitude,
          'map_longitude': mapLongitude,
        },
      );
      return response;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> getHomeStores() async {
    try {
      final response = await client.get(Uri.parse(get_home_stores_URL));
      return homeStoreFromJson(jsonEncode(jsonDecode(utf8.decode(response.bodyBytes))));
    } catch (e) {
      return null;
    }
  }

  static dynamic getSearches(query) async {
    try {
      final response = await client.get(Uri.parse('$get_search_URL?q=$query'));
      if (response.statusCode == 200) {
        // return utf8.decode(response.bodyBytes);
        return response;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static dynamic getSearchResult(query) async {
    try {
      final response = await client.get(Uri.parse('$get_search_result_URL?q=$query'));
      if (response.statusCode == 200) {
        // return utf8.decode(response.bodyBytes);
        return response;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
