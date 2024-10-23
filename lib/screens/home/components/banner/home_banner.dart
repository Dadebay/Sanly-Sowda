import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jummi/components/something_went_wrong.dart';
import 'package:jummi/controllers/home_controller.dart';
import 'package:jummi/screens/home/components/banner/banner_loading.dart';
import 'package:jummi/screens/home/components/banner/banner_slider.dart';

class HomeBanner extends StatelessWidget {
  HomeBanner({super.key});

  final HomeController _homeC = Get.put(HomeController());

  void _refreshBanner() async {
    _homeC.getBanners();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _homeC.bannersLoading.value
          ? const BannerLoading()
          : _homeC.bannersError.value != ''
              ? SomethingWentWrong(
                  text: 'Something went wrong!'.tr,
                  press: _refreshBanner,
                )
              : _homeC.banners.isEmpty
                  ? Text('No banner'.tr)
                  : BannerSlider(bannerList: _homeC.banners),
    );
  }
}
