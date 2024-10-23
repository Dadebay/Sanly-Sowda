import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jummi/constants.dart';
import 'package:jummi/screens/products/products_screen.dart';
// import 'package:http/http.dart' as http;
import 'package:jummi/size_config.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  // late String query = "";
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Get.to(const ProductsScreen());
      },
      child: Container(
        width: SizeConfig.screenWidth * 0.65,
        height: SizeConfig.screenHeight * 0.055,
        decoration: BoxDecoration(
          color: kSecondaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Search'.tr),
            Icon(
              Icons.search,
              size: width * 0.06,
            ),
          ],
        ),
      ),
    );
  }
}
