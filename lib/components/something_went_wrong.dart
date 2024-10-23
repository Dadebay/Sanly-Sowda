// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:jummi/constants.dart';

class SomethingWentWrong extends StatelessWidget {
  late String text;
  final Function() press;
  SomethingWentWrong({required this.text, required this.press, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Column(
          children: [
            IconButton(
              icon: const Icon(
                Icons.replay_rounded,
                color: kPrimaryColor,
              ),
              onPressed: press,
            ),
            Text(
              text,
              style: const TextStyle(
                color: kPrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
