import 'package:flutter/material.dart';

import 'components/body.dart';

class LoginSuccessScreen extends StatelessWidget {
  const LoginSuccessScreen({super.key});
  static String routeName = '/login_success';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarBuilder(context),
      body: const Body(),
    );
  }

  AppBar appBarBuilder(BuildContext context) {
    return AppBar(
      leading: const SizedBox(),
      centerTitle: true,
      title: const Text(
        'Login Success',
      ),
    );
  }
}
