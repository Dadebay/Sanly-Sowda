// ignore_for_file: non_constant_identifier_names

import 'package:get/get.dart';

class CartController extends GetxController {
  var count = 0.obs;
  var grouped_items = <Map<String, dynamic>>[].obs;
  double total = 0.0;

  void calculateTotal() {
    count.value = 0;
    const double totalMine = 0.0;
    for (var i = 0; i < grouped_items.length; i++) {
      count = count + grouped_items[i]['items'].length;
      total = totalMine + double.parse(grouped_items[i]['delivery_price']);
      for (var y = 0; y < grouped_items[i]['items'].length; y++) {
        total = totalMine + (double.parse(grouped_items[i]['items'][y]['count'].toString()) * double.parse(grouped_items[i]['items'][y]['price'].toString()));
      }
    }
    total = totalMine;
  }

  void addToCart(Map<String, dynamic> obj) async {
    var flag = 0;
    for (var i = 0; i < grouped_items.length; i++) {
      if (grouped_items[i]['ecommerce_id'] == obj['ecommerce_id']) {
        grouped_items[i]['items'].add(obj);
        grouped_items[i]['total'] = double.parse(grouped_items[i]['total'].toString()) + double.parse(obj['price'].toString());
        flag = 1;
      }
    }
    if (flag == 0) {
      grouped_items.add({
        'ecommerce_id': obj['ecommerce_id'],
        'ecommerce': obj['ecommerce'],
        'items': [obj],
        'total': obj['price'],
        'delivery_price': obj['delivery_price'],
      });
    }
    calculateTotal();
  }

  int checkProduct(String id) {
    var count = 0;
    for (var i = 0; i < grouped_items.length; i++) {
      for (var y = 0; y < grouped_items[i]['items'].length; y++) {
        if (grouped_items[i]['items'][y]['product_id'] == id) {
          count = grouped_items[i]['items'][y]['count'];
        }
      }
    }
    return count;
  }

  void increaseCount(String id) async {
    for (var i = 0; i < grouped_items.length; i++) {
      for (var y = 0; y < grouped_items[i]['items'].length; y++) {
        if (grouped_items[i]['items'][y]['product_id'] == id) {
          grouped_items[i]['items'][y]['count'] = grouped_items[i]['items'][y]['count'] + 1;
          grouped_items[i]['total'] = double.parse(
                grouped_items[i]['total'].toString(),
              ) +
              double.parse(grouped_items[i]['items'][y]['price'].toString());
        }
      }
    }
    calculateTotal();
  }

  void decreaseCount(String id) async {
    for (var i = 0; i < grouped_items.length; i++) {
      for (var y = 0; y < grouped_items[i]['items'].length; y++) {
        if (grouped_items[i]['items'][y]['product_id'] == id) {
          grouped_items[i]['items'][y]['count'] = grouped_items[i]['items'][y]['count'] - 1;
          grouped_items[i]['total'] = double.parse(
                grouped_items[i]['total'].toString(),
              ) -
              double.parse(grouped_items[i]['items'][y]['price'].toString());
        }
      }
    }
    calculateTotal();
  }

  void removeItem(String id) async {
    for (var i = 0; i < grouped_items.length; i++) {
      for (var y = 0; y < grouped_items[i]['items'].length; y++) {
        if (grouped_items[i]['items'][y]['product_id'] == id) {
          grouped_items[i]['total'] = double.parse(
                grouped_items[i]['total'].toString(),
              ) -
              double.parse(grouped_items[i]['items'][y]['price'].toString());
        }
      }
    }
    for (var i = 0; i < grouped_items.length; i++) {
      grouped_items[i]['items'].removeWhere((item) => item['product_id'] == id);
    }
    grouped_items.removeWhere((element) => element['items'].length == 0);
    calculateTotal();
  }

  void clearCart() async {
    count.value = 0;
    grouped_items.value = [];
    total = 0.0;
    calculateTotal();
  }
}
