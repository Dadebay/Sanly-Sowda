// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jummi/components/something_went_wrong.dart';
import 'package:jummi/constants.dart';
import 'package:jummi/controllers/home_controller.dart';
import 'package:jummi/controllers/products_filter.dart';
import 'package:jummi/models/Category.dart';
import 'package:jummi/screens/products/products_screen.dart';
import 'package:shimmer/shimmer.dart';

import '../../../size_config.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeC = Get.put(HomeController());

    void refreshTopCategories() async {
      homeC.getTopCategories();
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(10),
      ),
      child: Obx(
        () => homeC.topCategoriesLoading.value
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildCategoryIcon(),
                  buildCategoryIcon(),
                  buildCategoryIcon(),
                  buildCategoryIcon(),
                  buildCategoryIcon(),
                ],
              )
            : homeC.topCategoriesError.value != ''
                ? SomethingWentWrong(
                    text: 'Something went wrong!'.tr,
                    press: refreshTopCategories,
                  )
                : homeC.topCategories.value.isEmpty
                    ? Text('No categories'.tr)
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ...List.generate(
                              homeC.topCategories.length,
                              (index) => CategoryCard(
                                icon: homeC.topCategories[index].image,
                                category: homeC.topCategories[index],
                                text: homeC.topCategories[index].name!.tm.toString(),
                                press: () {},
                              ),
                            ),
                          ],
                        ),
                      ),
      ),
    );
  }
}

Shimmer buildCategoryIcon() {
  return Shimmer.fromColors(
    highlightColor: Colors.white,
    baseColor: Colors.grey.shade300,
    child: Container(
      width: 60,
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    ),
  );
}

class CategoryCard extends StatelessWidget {
  CategoryCard({
    required this.icon,
    required this.category,
    required this.text,
    required this.press,
    super.key,
  });

  final String icon, text;
  final Category category;
  final GestureTapCallback press;

  final ProductsFilterController _pfController = Get.put(ProductsFilterController());

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            _pfController.clearFilter();
            _pfController.setCategory(category);
            Get.to(const ProductsScreen());
          },
          child: SizedBox(
            width: getProportionateScreenWidth(60),
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                padding: EdgeInsets.all(getProportionateScreenWidth(7)),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFECDF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SvgPicture.network(
                  media_host + icon,
                  color: kPrimaryColor,
                  placeholderBuilder: (BuildContext context) => Container(
                    padding: const EdgeInsets.all(30.0),
                    child: const CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
      ],
    );
  }
}
