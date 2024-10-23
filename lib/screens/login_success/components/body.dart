import 'package:flutter/material.dart';
import 'package:jummi/components/default_button.dart';
import 'package:jummi/constants.dart';
import 'package:jummi/size_config.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: SizeConfig.screenHeight * 0.04),
        Image.asset(
          'assets/images/success.png',
          height: SizeConfig.screenHeight * 0.4,
        ),
        SizedBox(height: SizeConfig.screenHeight * 0.08),
        Text(
          'Login Success',
          style: headingStyle,
        ),
        const Spacer(),
        SizedBox(
          width: SizeConfig.screenWidth * 0.6,
          child: DefaultButton(text: 'Back to Home', press: () {}),
        ),
        const Spacer(),
      ],
    );
  }
}
