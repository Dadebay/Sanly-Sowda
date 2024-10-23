import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../size_config.dart';

class FormErrors extends StatelessWidget {
  const FormErrors({
    required this.errors,
    super.key,
  });

  final List<String> errors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(errors.length, (index) => formError(error: errors[index])),
    );
  }

  Container formError({String? error}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/Error.svg',
            height: getProportionateScreenWidth(14),
            width: getProportionateScreenWidth(14),
          ),
          SizedBox(
            width: getProportionateScreenWidth(10),
          ),
          Expanded(
            child: Text(error!),
          ),
        ],
      ),
    );
  }
}
