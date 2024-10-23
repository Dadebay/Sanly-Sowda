import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jummi/components/custom_bottom_nav_bar.dart';
import 'package:jummi/constants.dart';
import 'package:jummi/enums.dart';
import 'package:jummi/screens/search_page/components/body.dart';
import 'package:jummi/size_config.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({required this.query, super.key});
  final String query;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late String type = 'Products';
  late String query = '';

  @override
  Widget build(BuildContext context) {
    final Size mySize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: SizeConfig.screenHeight * 0.07,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.chevron_left_rounded,
              size: mySize.width * 0.07,
            ),
          ),
          // centerTitle: true,
          title: TextField(
            decoration: InputDecoration(
              hintText: "${"Search".tr}: ${type.tr}",
              isDense: true,
              filled: true,
              fillColor: kSecondaryColor.withOpacity(0.1),
              contentPadding: const EdgeInsets.all(10),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
        body: Body(
          query: widget.query,
        ),
        bottomNavigationBar: const CustomBottomNavBar(
          selectedMenu: MenuState.home,
        ),
      ),
    );
  }
}
