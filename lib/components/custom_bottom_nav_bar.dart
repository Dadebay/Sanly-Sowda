import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jummi/constants.dart';
import 'package:jummi/screens/home/home_screen.dart';
import 'package:jummi/screens/likeds/liked_products.dart';
import 'package:jummi/screens/settings/settings_screen.dart';
import 'package:jummi/screens/stores_catalog/stores_catalog_screen.dart';

import '../enums.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    this.selectedMenu,
  });

  final MenuState? selectedMenu;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    const Color inActiveIconColor = Color(0xFFB6B6B6);
    return Container(
      height: width * 0.15,
      color: const Color.fromARGB(255, 250, 250, 250),
      child: ClipRRect(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () => Get.to(
                () => const HomeScreen(),
              ),
              icon: SvgPicture.asset(
                'assets/icons/Home Icon.svg',
                width: width * 0.055,
                color: MenuState.home == selectedMenu ? kPrimaryColor : inActiveIconColor,
              ),
            ),
            IconButton(
              // onPressed: () => Get.to(() => EcommercesScreen()),
              onPressed: () => Get.to(() => const StoresCatalogScreen()),
              icon: SvgPicture.asset(
                'assets/icons/Shop Icon.svg',
                width: width * 0.055,
                color: MenuState.ecommerces == selectedMenu ? kPrimaryColor : inActiveIconColor,
              ),
            ),
            IconButton(
              onPressed: () => Get.to(const LikedProducts()),
              icon: SvgPicture.asset(
                'assets/icons/Heart Icon.svg',
                width: width * 0.055,
                color: MenuState.favorite == selectedMenu ? kPrimaryColor : inActiveIconColor,
              ),
            ),
            // IconButton(
            //   onPressed: () => Get.to(HuntingScreen()),
            //   icon: SvgPicture.asset(
            //     "assets/icons/Fishing Hook.svg",
            //     width: width * 0.065,
            //     color: MenuState.hunting == selectedMenu ? kPrimaryColor : inActiveIconColor,
            //   ),
            // ),
            IconButton(
              onPressed: () => Get.to(
                const SettingsScreen(),
              ),
              icon: SvgPicture.asset(
                'assets/icons/User Icon.svg',
                width: width * 0.055,
                color: MenuState.profile == selectedMenu ? kPrimaryColor : inActiveIconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
