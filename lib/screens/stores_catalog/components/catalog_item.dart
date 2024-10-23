import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jummi/constants.dart';
import 'package:jummi/controllers/ecommerces_filter.dart';
import 'package:jummi/models/Category.dart';
import 'package:jummi/screens/ecommerces/ecommerces_screen.dart';
import 'package:jummi/size_config.dart';

class CatalogItem extends StatelessWidget {
  const CatalogItem({required this.category, super.key});
  final Category category;

  @override
  Widget build(BuildContext context) {
    final EcommercesFilterController efController = Get.put(EcommercesFilterController());
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: 10,
      ),
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: const WidgetStatePropertyAll(Colors.white),
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(
              horizontal: SizeConfig.screenWidth * 0.05,
              vertical: SizeConfig.screenWidth * 0.04,
            ),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
        onPressed: () {
          efController.clearFilter();
          efController.setCategory(category);
          Get.to(const EcommercesScreen());
        },
        child: Row(
          children: [
            SvgPicture.network(
              media_host + category.image,
              // "https://migration.gov.tm/cdn/media/multimedia/images/2024/01/02/0M9A0460.JPG",
              width: SizeConfig.screenWidth * 0.08,
              color: kPrimaryColor,
              placeholderBuilder: (BuildContext context) => Container(
                padding: const EdgeInsets.all(2),
                child: const SizedBox(
                  width: 20,
                  height: 20,
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Row(
                children: [
                  Text(
                    category.name!.tm.toString(),
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: SizeConfig.screenWidth * 0.04,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text('(${category.storesSum})'),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
