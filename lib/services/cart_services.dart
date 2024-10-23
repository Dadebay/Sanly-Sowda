// ignore_for_file: prefer_single_quotes

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jummi/controllers/cart_controller.dart';
import 'package:jummi/endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartService {
  static var client = http.Client();

  static Future<dynamic> fetchCustomerCarts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final response = await client.get(
        Uri.parse(get_customer_carts_URL),
        headers: {'Accept': 'application/json', 'Authorization': prefs.getString('access_token') != null && prefs.getString('access_token') != '' ? "Bearer ${prefs.getString("access_token")}" : ''},
      );
      return response;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> fetchOrder(id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final response = await client.get(
        Uri.parse('${get_order_URL + id}/'),
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

  static Future<dynamic> acceptOrder(int? id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final response = await client.post(
        Uri.parse("$accept_order_URL$id/"),
        headers: {'Accept': 'application/json', 'Authorization': prefs.getString('access_token') != null && prefs.getString('access_token') != '' ? "Bearer ${prefs.getString("access_token")}" : ''},
      );
      return response;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> rejectOrder(int? id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final response = await client.post(
        Uri.parse("$reject_order_URL$id/"),
        headers: {'Accept': 'application/json', 'Authorization': prefs.getString('access_token') != null && prefs.getString('access_token') != '' ? "Bearer ${prefs.getString("access_token")}" : ''},
      );
      return response;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> fetchEcommerceOrders() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final response = await client.get(
        Uri.parse(get_ecommerce_orders_URL),
        headers: {'Accept': 'application/json', 'Authorization': prefs.getString('access_token') != null && prefs.getString('access_token') != '' ? "Bearer ${prefs.getString("access_token")}" : ''},
      );
      return response;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> createCart(String? address) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final CartController cartController = Get.put(CartController());

    final List body = [];

    for (var i = 0; i < cartController.grouped_items.length; i++) {
      final obj = {};
      obj['ecommerce_id'] = cartController.grouped_items[i]['ecommerce_id'];
      obj['total'] = cartController.grouped_items[i]['total'];
      obj['delivery_price'] = cartController.grouped_items[i]['delivery_price'];
      final List innerList = [];
      for (var y = 0; y < cartController.grouped_items[i]['items'].length; y++) {
        innerList.add({
          'product_id': cartController.grouped_items[i]['items'][y]['product_id'],
          'count': cartController.grouped_items[i]['items'][y]['count'],
          'price': cartController.grouped_items[i]['items'][y]['price'],
        });
      }
      obj['items'] = innerList;
      body.add(obj);
    }

    final String jsonStringMap = json.encode(body);

    try {
      final response = await client.post(
        Uri.parse(create_cart_URL),
        headers: {
          'Accept': 'application/json',
          'Authorization': prefs.getString('access_token') != null && prefs.getString('access_token') != '' ? "Bearer ${prefs.getString("access_token")}" : '',
        },
        body: {
          'address': address,
          'grouped_items': jsonStringMap,
        },
      );
      return response;
    } catch (e) {
      return null;
    }
  }
}
