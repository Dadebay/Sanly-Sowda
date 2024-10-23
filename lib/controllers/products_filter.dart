// ignore_for_file: unrelated_type_equality_checks

import 'package:get/state_manager.dart';
import 'package:jummi/models/Category.dart';
import 'package:jummi/models/Location.dart';

class ProductsFilterController extends GetxController {
  final word = ''.obs;
  final categories = <Category>[].obs;
  final locations = <Location>[].obs;
  var favorite = false.obs;
  var discount = false.obs;
  var delivery = false.obs;
  var search = false.obs;

  void setWord(String w) async {
    word.value = w;
  }

  void setCategory(Category? category) async {
    if (categories.contains(category!)) {
      categories.remove(category);
    } else {
      categories.add(category);
    }
  }

  void setLocation(Location? location) async {
    if (locations.contains(location!)) {
      locations.remove(location);
    } else {
      locations.add(location);
    }
  }

  void setFavorite() async {
    favorite.value = !favorite.value;
  }

  void setDiscount() async {
    discount.value = !discount.value;
  }

  void setDelivery() async {
    delivery.value = !delivery.value;
  }

  void setSearch(bool flag) async {
    search.value = flag;
  }

  void clearFilter() async {
    categories.value = [];
    locations.value = [];
    favorite.value = false;
    discount.value = false;
    delivery.value = false;
    search.value = false;
  }

  Future<bool> checkFilter() async {
    if (categories.isEmpty && locations.isEmpty && favorite == false && discount == false && delivery == false) {
      return false;
    } else {
      return true;
    }
  }
}
