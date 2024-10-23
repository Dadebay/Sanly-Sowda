import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jummi/screens/sign_up/sign_up_screen.dart';

import '../constants.dart';

class NoAccount extends StatelessWidget {
  const NoAccount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Don't have an account?".tr),
          TextButton(
            onPressed: () => Get.to(
              const SignUpScreen(),
            ),
            child: Text(
              'Sign Up'.tr,
              style: const TextStyle(
                color: kPrimaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
