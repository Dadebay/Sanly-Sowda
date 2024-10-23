import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jummi/screens/policy/components/body.dart';
import 'package:jummi/size_config.dart';

class PolicyScreen extends StatelessWidget {
  const PolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarBuilder(context),
        body: const Body(),
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
        'Privacy policy, terms of services, and community guidlines.'.tr,
        style: TextStyle(fontSize: width * 0.05),
      ),
    );
  }
}
