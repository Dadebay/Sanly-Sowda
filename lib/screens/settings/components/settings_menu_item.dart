import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jummi/size_config.dart';

import '../../../constants.dart';

class SettingsMenuItem extends StatelessWidget {
  const SettingsMenuItem({
    required this.text,
    required this.icon,
    required this.press,
    super.key,
  });

  final String text, icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: 10,
      ),
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: const WidgetStatePropertyAll(Colors.white),
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(
              horizontal: width * 0.05,
              vertical: width * 0.04,
            ),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
        onPressed: press,
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              width: width * 0.05,
              color: kPrimaryColor,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: SizeConfig.screenWidth * 0.04,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
