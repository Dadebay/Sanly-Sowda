// ignore_for_file: unrelated_type_equality_checks

import 'package:get/state_manager.dart';

class EcommerceFilterController extends GetxController {
  final word = ''.obs;
  final categories = <int>[].obs;
  var favorite = false.obs;
  var discount = false.obs;
  var search = false.obs;

  void setWord(String w) async {
    word.value = w;
  }

  void setCategory(int? id) async {
    if (categories.contains(id!)) {
      categories.remove(id);
    } else {
      categories.add(id);
    }
  }

  void setFavorite() async {
    favorite.value = !favorite.value;
  }

  void setDiscount() async {
    discount.value = !discount.value;
  }

  void setSearch(bool flag) async {
    search.value = flag;
  }

  void clearFilter() async {
    categories.value = [];
    favorite.value = false;
    discount.value = false;
    search.value = false;
  }

  Future<bool> checkFilter() async {
    if (categories.isEmpty && favorite == false) {
      return false;
    } else {
      return true;
    }
  }
}
