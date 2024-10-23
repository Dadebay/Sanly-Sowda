import 'package:flutter/material.dart';

import '../size_config.dart';

class CustomPrefixIcon extends StatelessWidget {
  const CustomPrefixIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        getProportionateScreenWidth(18),
        getProportionateScreenWidth(16),
        getProportionateScreenWidth(0),
        getProportionateScreenWidth(18),
      ),
      child: const Text(
        '+993 ',
        style: TextStyle(
          fontSize: 16,
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
