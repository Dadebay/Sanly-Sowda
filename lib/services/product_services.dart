// ignore_for_file: depend_on_referenced_packages, unrelated_type_equality_checks, prefer_single_quotes

import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jummi/controllers/ecommerce_filter.dart';
import 'package:jummi/controllers/products_filter.dart';
import 'package:jummi/endpoints.dart';
import 'package:jummi/models/Product.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductService {
  static var client = http.Client();

  static Future<dynamic> fetchEcommerceProducts(id, page) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final EcommerceFilterController efController = Get.put(EcommerceFilterController());
    try {
      final response = await client.get(
        Uri.parse(
          "$get_ecommerce_products_URL$id/?page=$page&size=10&word=${efController.word}&categories=${efController.categories}&favorite=${efController.favorite == true ? '1' : '0'}&discount=${efController.discount == true ? '1' : '0'}",
        ),
        headers: {'Accept': 'application/json', 'Authorization': prefs.getString('access_token') != null && prefs.getString('access_token') != '' ? "Bearer ${prefs.getString("access_token")}" : ''},
      );
      return response;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> fetchExploreProducts(page) async {
    final ProductsFilterController pfController = Get.put(ProductsFilterController());
    try {
      final response = await client.get(
        Uri.parse(
          "$get_products_URL?page=$page&size=20&word=${pfController.word}&categories=${pfController.categories.map((category) => category.id).toList()}&locations=${pfController.locations.map((location) => location.id).toList()}&favorite=${pfController.favorite == true ? '1' : '0'}&discount=${pfController.discount == true ? '1' : '0'}&delivery=${pfController.delivery == true ? '1' : '0'}",
        ),
      );
      return response;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> getLikedProducts(page) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final response = await client.get(
        Uri.parse(get_liked_products_URL),
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

  static Future<dynamic> getLastVisitedProducts(page) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final response = await client.get(
        Uri.parse(get_last_visited_products_URL),
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

  static Future<dynamic> fetchProduct(id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final response = await client.get(
        Uri.parse('${get_product_URL + id}/'),
        headers: {'Accept': 'application/json', 'Authorization': prefs.getString('access_token') != null && prefs.getString('access_token') != '' ? "Bearer ${prefs.getString("access_token")}" : ''},
      );
      return response;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> createProduct(
    int? id,
    List<File> images,
    String? name,
    String? content,
    String? price,
    String? discountPrice,
    int? category,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(create_product_URL),
      );
      if (images.isNotEmpty) {
        var c = 0;
        for (var i in images) {
          request.files.add(
            http.MultipartFile(
              'image$c',
              i.readAsBytes().asStream(),
              i.lengthSync(),
              filename: basename(i.path).split('/').last,
            ),
          );
          c = c + 1;
        }
      }
      request.fields['ecommerce_id'] = id.toString();
      request.fields['name'] = name.toString();
      request.fields['content'] = content.toString();
      request.fields['price'] = price.toString();
      request.fields['discountPrice'] = discountPrice.toString();
      request.fields['category'] = category.toString();
      request.headers.addAll(
        {'Accept': 'application/json', 'Authorization': prefs.getString('access_token') != null && prefs.getString('access_token') != '' ? "Bearer ${prefs.getString("access_token")}" : ''},
      );
      final response = await request.send();
      return await http.Response.fromStream(response);
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> updateProduct(
    int? id,
    String? name,
    String? content,
    String? price,
    String? discountPrice,
    int? category,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse("$update_product_URL$id/"),
      );
      request.fields['name'] = name.toString();
      request.fields['content'] = content.toString();
      request.fields['price'] = price.toString();
      request.fields['discountPrice'] = discountPrice.toString();
      request.fields['category'] = category.toString();
      request.headers.addAll(
        {'Accept': 'application/json', 'Authorization': prefs.getString('access_token') != null && prefs.getString('access_token') != '' ? "Bearer ${prefs.getString("access_token")}" : ''},
      );
      final response = await request.send();
      return await http.Response.fromStream(response);
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> deleteProduct(
    int? id,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse("$delete_product_URL$id/"),
      );
      request.headers.addAll(
        {'Accept': 'application/json', 'Authorization': prefs.getString('access_token') != null && prefs.getString('access_token') != '' ? "Bearer ${prefs.getString("access_token")}" : ''},
      );
      final response = await request.send();
      return await http.Response.fromStream(response);
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> likeProduct(
    int? id,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse("$like_product_URL$id/"),
      );
      request.headers.addAll(
        {
          'Accept': 'application/json',
          'Authorization': prefs.getString('access_token') != null && prefs.getString('access_token') != '' ? "Bearer ${prefs.getString("access_token")}" : '',
        },
      );
      final response = await request.send();
      return await http.Response.fromStream(response);
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> getTopDiscount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final response = await client.get(
        Uri.parse(get_top_discount_URL),
        headers: {
          'Accept': 'application/json',
          'Authorization': prefs.getString('access_token') != null && prefs.getString('access_token') != '' ? "Bearer ${prefs.getString("access_token")}" : '',
        },
      );
      return Product.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> getPopularProducts() async {
    try {
      final response = await client.get(
        Uri.parse(get_new_products_URL),
      );
      return productFromJson(utf8.decode(response.bodyBytes));
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> getHomeProducts() async {
    try {
      final response = await client.get(
        Uri.parse(get_home_products_URL),
      );
      return productFromJson(utf8.decode(response.bodyBytes));
    } catch (e) {
      return null;
    }
  }
}
