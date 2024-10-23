import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jummi/size_config.dart';

import 'components/body.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({required this.phone, super.key});

  final String? phone;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarBuilder(context),
        body: Body(phone: phone!),
      ),
    );
  }

  AppBar appBarBuilder(BuildContext context) {
    return AppBar(
      toolbarHeight: SizeConfig.screenHeight * 0.07,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(
          Icons.chevron_left_rounded,
          size: 28,
        ),
      ),
      centerTitle: true,
      title: Text(
        'OTP Verification'.tr,
      ),
    );
  }
}
