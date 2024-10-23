import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jummi/constants.dart';
import 'package:jummi/screens/sign_in/sign_in_screen.dart';
import 'package:jummi/screens/sign_up/components/sign_up_form.dart';

import '../../../size_config.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: getProportionateScreenWidth(60),
              ),
              Text(
                'Sign Up'.tr,
                style: headingStyle,
              ),
              SizedBox(
                height: getProportionateScreenWidth(20),
              ),
              const SignUpForm(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('You have an account already?'.tr),
                  TextButton(
                    onPressed: () => Get.to(
                      const SignInScreen(),
                    ),
                    child: Text(
                      'Sign In'.tr,
                      style: const TextStyle(
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
