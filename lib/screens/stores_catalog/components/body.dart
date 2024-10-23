// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jummi/controllers/main_controller.dart';
import 'package:jummi/screens/stores_catalog/components/catalog_item.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final MainController _mainController = Get.put(MainController());

  @override
  void initState() {
    super.initState();
    _mainController.fetchAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10),
          for (var i = 0; i < _mainController.allCategoryData.value.length; i++)
            _mainController.allCategoryData[i].storesSum == 0 || _mainController.allCategoryData[i].storesSum == null
                ? const SizedBox()
                : CatalogItem(
                    category: _mainController.allCategoryData[i],
                  ),
        ],
      ),
    );
  }
}
