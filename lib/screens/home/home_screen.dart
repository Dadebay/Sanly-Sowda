import 'package:flutter/material.dart';
import 'package:jummi/components/custom_bottom_nav_bar.dart';
import 'package:jummi/constants.dart';
import 'package:jummi/enums.dart';
import 'package:jummi/screens/home/components/header/home_header.dart';

import '../../size_config.dart';
import 'components/body.dart';

late DateTime currentBackPressTime;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    checkToken();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: SizeConfig.screenHeight * 0.07,
          automaticallyImplyLeading: false,
          flexibleSpace: const HomeHeader(),
        ),
        body: const Body(),
        bottomNavigationBar: const CustomBottomNavBar(
          selectedMenu: MenuState.home,
        ),
      ),
    );
  }
}
