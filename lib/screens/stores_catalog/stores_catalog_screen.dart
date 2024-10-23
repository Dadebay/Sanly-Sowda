import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jummi/components/custom_bottom_nav_bar.dart';
import 'package:jummi/enums.dart';
import 'package:jummi/screens/stores_catalog/components/body.dart';
import 'package:jummi/size_config.dart';

class StoresCatalogScreen extends StatelessWidget {
  const StoresCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarBuilder(context),
        body: const Body(),
        bottomNavigationBar: const CustomBottomNavBar(
          selectedMenu: MenuState.ecommerces,
        ),
      ),
    );
  }

  AppBar appBarBuilder(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return AppBar(
      toolbarHeight: SizeConfig.screenHeight * 0.07,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Icon(
          Icons.chevron_left_rounded,
          size: width * 0.07,
        ),
      ),
      centerTitle: true,
      title: Text(
        'Stores Catalog'.tr,
        style: TextStyle(fontSize: width * 0.05),
      ),
    );
  }
}
