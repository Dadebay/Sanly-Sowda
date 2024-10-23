// ignore_for_file: non_constant_identifier_names, deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jummi/components/custom_bottom_nav_bar.dart';
import 'package:jummi/components/something_went_wrong.dart';
import 'package:jummi/constants.dart';
import 'package:jummi/enums.dart';
import 'package:jummi/screens/ecommerce/components/product_form.dart';
import 'package:jummi/screens/home/home_screen.dart';
import 'package:jummi/services/product_services.dart';
import 'package:jummi/size_config.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/Product.dart';
import 'components/body.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({required this.product_id, required this.editable, super.key});
  final int product_id;
  final bool editable;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool isProductLoading = true;
  late Product? product;
  late String? productError;

  Future<void> _getProduct() async {
    setState(() {
      isProductLoading = true;
    });
    final dynamic response = await ProductService.fetchProduct(widget.product_id.toString());
    if (response != null && response.statusCode == 200) {
      if (mounted) {
        setState(() {
          product = Product.fromJson(json.decode(utf8.decode(response.bodyBytes)));
          isProductLoading = false;
        });
      }
    } else if (response != null && response.statusCode == 404) {
      setState(() {
        productError = 'Product not found';
        isProductLoading = false;
      });
    } else {
      setState(() {
        productError = 'Something went wrong';
        isProductLoading = false;
      });
    }
  }

  @override
  void initState() {
    _getProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6F9),
        appBar: appBarBuilder(context, widget.editable, product),
        body: isProductLoading == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : product == null
                ? Scaffold(
                    body: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SomethingWentWrong(
                          text: productError.toString(),
                          press: _getProduct,
                        ),
                        ElevatedButton(
                          onPressed: () => Get.to(const HomeScreen()),
                          child: const Text('Home'),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () {
                      return _getProduct();
                    },
                    child: Body(product: product),
                  ),
        floatingActionButton: isProductLoading == true
            ? const SizedBox()
            : product == null
                ? const SizedBox()
                : FloatingActionButton(
                    onPressed: () async {
                      final url = 'tel:${product!.ecommerce!.phone}';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        // throw 'Could not launch $url';
                        Get.snackbar('Error', 'Could not launch $url!');
                      }
                    },
                    backgroundColor: kPrimaryColor,
                    child: const Icon(
                      Icons.phone_enabled_rounded,
                    ),
                  ),
        bottomNavigationBar: const CustomBottomNavBar(
          selectedMenu: MenuState.ecommerces,
        ),
      ),
    );
  }
}

class ProductDetailsArguments {
  final Product product;

  ProductDetailsArguments({required this.product});
}

AppBar appBarBuilder(BuildContext context, bool editable, Product? product) {
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
    title: Text(
      'Product details'.tr,
    ),
    actions: [
      editable == true && product != null
          ? IconButton(
              onPressed: () => Get.to(
                ProductForm(product: product, ecommerce: product.ecommerce),
              ),
              icon: const Icon(Icons.edit_note),
            )
          : const SizedBox(),
    ],
  );
}
