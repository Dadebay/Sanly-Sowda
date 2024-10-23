// ignore_for_file: invalid_use_of_protected_member, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jummi/components/product_card.dart';
import 'package:jummi/components/something_went_wrong.dart';
import 'package:jummi/controllers/home_controller.dart';
import 'package:jummi/screens/home/components/section_title.dart';
import 'package:jummi/screens/products/products_screen.dart';
import 'package:shimmer/shimmer.dart';

import '../../../size_config.dart';

class VipProducts extends StatelessWidget {
  VipProducts({super.key});

  final HomeController _homeC = Get.put(HomeController());

  void _refreshHomeProducts() async {
    _homeC.getHomeProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitle(
          buttonText: '',
          press: () {
            Get.to(const ProductsScreen());
          },
          sectionTitle: 'Special products for you'.tr,
        ),
        SizedBox(
          height: getProportionateScreenWidth(10),
        ),
        Obx(
          () => _homeC.homeProductsLoading == true
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Shimmer.fromColors(
                          highlightColor: Colors.white,
                          baseColor: Colors.grey.shade300,
                          child: Container(
                            width: SizeConfig.screenWidth * 0.51,
                            height: 250,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Shimmer.fromColors(
                          highlightColor: Colors.white,
                          baseColor: Colors.grey.shade300,
                          child: Container(
                            width: SizeConfig.screenWidth * 0.51,
                            height: 250,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : _homeC.homeProductsError != ''
                  ? SomethingWentWrong(
                      text: 'Something went wrong!'.tr,
                      press: _refreshHomeProducts,
                    )
                  : _homeC.homeProducts.isEmpty
                      ? Center(
                          child: Text('No data'.tr),
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...List.generate(
                                  _homeC.homeProducts.value.length,
                                  (index) => Container(
                                    width: SizeConfig.screenWidth * 0.5,
                                    height: SizeConfig.screenWidth * 0.66,
                                    margin: const EdgeInsets.only(
                                      right: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: ProductCard(
                                      product: _homeC.homeProducts.value[index],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: getProportionateScreenWidth(20),
                                ),
                              ],
                            ),
                          ),
                        ),
        ),
      ],
    );
  }
}
