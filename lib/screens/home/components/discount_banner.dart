import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jummi/controllers/home_controller.dart';
import 'package:jummi/controllers/products_filter.dart';
import 'package:jummi/screens/products/products_screen.dart';

import '../../../size_config.dart';

class DiscountBanner extends StatelessWidget {
  DiscountBanner({
    super.key,
  });

  final HomeController _homeC = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final ProductsFilterController pfController = Get.put(ProductsFilterController());
    return GestureDetector(
      onTap: () {
        pfController.clearFilter();
        pfController.setDiscount();
        Get.to(const ProductsScreen());
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(10),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20),
          vertical: getProportionateScreenWidth(15),
        ),
        width: double.infinity,
        height: 90,
        decoration: BoxDecoration(
          // color: Color(0xFF4A3298),
          image: const DecorationImage(
            image: AssetImage('assets/images/banner.jpg'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Today's biggest discount!".tr,
              style: TextStyle(
                color: Colors.white,
                fontSize: SizeConfig.screenWidth * 0.035,
                fontWeight: FontWeight.w500,
                shadows: const [
                  Shadow(
                    color: Colors.black54,
                    blurRadius: 5,
                    offset: Offset.zero,
                  ),
                ],
              ),
            ),
            Obx(
              () => _homeC.topDiscountLoading.value
                  ? Text(
                      "${"Discount".tr}!",
                      style: TextStyle(
                        fontSize: SizeConfig.screenWidth * 0.07,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'Discount'.tr +
                          (_homeC.topDiscountError.value == ''
                              ? _homeC.topDiscount.value.discountPercent == null
                                  ? '!'
                                  : ' ${_homeC.topDiscount.value.discountPercent}%'
                              : '!'),
                      style: TextStyle(
                        fontSize: SizeConfig.screenWidth * 0.07,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
