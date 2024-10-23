// ignore_for_file: unrelated_type_equality_checks, duplicate_ignore

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jummi/components/something_went_wrong.dart';
import 'package:jummi/constants.dart';
import 'package:jummi/controllers/home_controller.dart';
import 'package:jummi/screens/ecommerce/ecommerce_screen.dart';
import 'package:jummi/screens/ecommerces/ecommerces_screen.dart';
import 'package:jummi/screens/home/components/section_title.dart';
import 'package:shimmer/shimmer.dart';

import '../../../size_config.dart';

class VipStores extends StatelessWidget {
  VipStores({super.key});

  final HomeController _homeC = Get.put(HomeController());

  void _refreshHomeStores() async {
    _homeC.getHomeStores();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitle(
          sectionTitle: 'Special for you'.tr,
          buttonText: 'See More'.tr,
          press: () {
            Get.to(const EcommercesScreen());
          },
        ),
        SizedBox(
          height: getProportionateScreenWidth(10),
        ),
        Obx(
          () => _homeC.homeStoresLoading.value == true
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
                            width: SizeConfig.screenWidth * 0.6,
                            height: 110,
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
                            width: SizeConfig.screenWidth * 0.6,
                            height: 110,
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
              : _homeC.homeStoresError != ''
                  ? SomethingWentWrong(
                      // ignore: unrelated_type_equality_checks
                      text: 'Something went wrong!'.tr,
                      press: _refreshHomeStores,
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (var i = 0; i < _homeC.homeStores.length; i++)
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: GestureDetector(
                                onTap: () => Get.to(
                                  EcommerceScreen(
                                    ecommerce_id: _homeC.homeStores[i].store!,
                                  ),
                                ),
                                child: SizedBox(
                                  width: getProportionateScreenWidth(242),
                                  height: getProportionateScreenWidth(100),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Stack(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: media_host + _homeC.homeStores[i].image.toString(),
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                          errorWidget: (context, url, error) => Icon(
                                            Icons.image_not_supported_rounded,
                                            color: Colors.black26,
                                            size: SizeConfig.screenWidth * 0.1,
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                const Color(0xFF343434).withOpacity(0.7),
                                                const Color(0xFF343434).withOpacity(0.2),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: getProportionateScreenWidth(15),
                                            vertical: getProportionateScreenWidth(10),
                                          ),
                                          child: Text.rich(
                                            TextSpan(
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: '${_homeC.homeStores[i].title}\n',
                                                  style: TextStyle(
                                                    fontSize: getProportionateScreenWidth(
                                                      20,
                                                    ),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: '${_homeC.homeStores[i].subtitle}',
                                                  style: TextStyle(
                                                    fontSize: getProportionateScreenWidth(
                                                      14,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
        ),
      ],
    );
  }
}
