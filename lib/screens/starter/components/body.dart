import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    // readQr();
    return const SafeArea(
      child: Center(),
    );
  }

  // @override
  // void dispose() {
  //   controller?.dispose();
  //   super.dispose();
  // }
}
