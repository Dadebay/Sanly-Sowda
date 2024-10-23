import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jummi/constants.dart';

import '../../../size_config.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    required this.sectionTitle,
    required this.press,
    required this.buttonText,
    super.key,
  });

  final String sectionTitle;
  final GestureTapCallback press;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            sectionTitle,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(18),
              color: Colors.black,
            ),
          ),
          GestureDetector(
            onTap: press,
            child: Row(
              children: [
                Text(
                  'All'.tr,
                  style: TextStyle(
                    fontSize: SizeConfig.screenWidth * 0.04,
                    color: kPrimaryColor,
                    height: 1,
                  ),
                ),
                const SizedBox(width: 5),
                SvgPicture.asset(
                  'assets/icons/arrow_right.svg',
                  width: 6,
                  color: kPrimaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
