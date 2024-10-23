import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jummi/constants.dart';
import 'package:jummi/screens/forgot_password/forgot_password_screen.dart';
import 'package:jummi/screens/sign_in/components/sign_form.dart';
import 'package:jummi/size_config.dart';

import '../../../components/no_account.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
          ),
          child: Column(
            children: [
              SizedBox(
                height: getProportionateScreenWidth(100),
              ),
              Text(
                'Welcome Back'.tr,
                style: headingStyle,
              ),
              SizedBox(
                height: getProportionateScreenWidth(10),
              ),
              Text(
                "Sign in with your phone number \nor you don't have any account yet, \nSign up.".tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: SizeConfig.screenWidth * 0.04,
                  height: 1.2,
                ),
              ),
              SizedBox(
                height: getProportionateScreenWidth(20),
              ),
              const SignForm(),
              const NoAccount(),
              TextButton(
                onPressed: () => Get.to(const ForgotPasswordScreen()),
                child: Text('Forgot password?'.tr),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
