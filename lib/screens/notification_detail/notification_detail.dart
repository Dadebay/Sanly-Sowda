import 'package:flutter/material.dart';
import 'package:jummi/components/custom_bottom_nav_bar.dart';
import 'package:jummi/enums.dart';
import 'package:jummi/size_config.dart';

import 'components/body.dart';

class NotificationDetail extends StatelessWidget {
  const NotificationDetail({required this.id, super.key});
  final String id;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarBuilder(context),
        body: Body(id: id),
        bottomNavigationBar: const CustomBottomNavBar(
          selectedMenu: MenuState.profile,
        ),
      ),
    );
  }

  AppBar appBarBuilder(BuildContext context) {
    return AppBar(
      toolbarHeight: SizeConfig.screenHeight * 0.07,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(
          Icons.chevron_left_rounded,
          size: 28,
        ),
      ),
      centerTitle: true,
      title: const Text('Notification'),
    );
  }
}
