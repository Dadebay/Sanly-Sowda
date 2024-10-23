import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jummi/components/ecommerce_card.dart';
import 'package:jummi/components/product_card.dart';
import 'package:jummi/components/something_went_wrong.dart';
import 'package:jummi/endpoints.dart';
import 'package:jummi/models/Ecommerce.dart';
import 'package:jummi/models/Product.dart';
import 'package:jummi/screens/home/components/discount_banner.dart';
import 'package:jummi/size_config.dart';

class Body extends StatefulWidget {
  const Body({required this.query, super.key});

  final String query;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late bool loading = true;
  late List<Ecommerce> ecommerces = [];
  late List<Product> products = [];
  late String errorMessage = '';
  var client = http.Client();

  void _getSearchResult(String query) async {
    setState(() {
      loading = true;
    });
    if (query.length >= 3) {
      final response = await client.get(Uri.parse('$get_search_result_URL?q=$query'));
      if (response.statusCode == 200) {
        setState(() {
          ecommerces = ecommerceFromJson(json.encode(json.decode(utf8.decode(response.bodyBytes))['stores']));
          products = productFromJson(json.encode(json.decode(utf8.decode(response.bodyBytes))['products']));
          loading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Something went wrong!'.tr;
          loading = false;
        });
      }
    } else {
      setState(() {
        errorMessage = 'Search text length must be longer than 3!'.tr;
        loading = false;
      });
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getSearchResult(widget.query);
  }

  @override
  Widget build(BuildContext context) {
    return loading == true
        ? const Center(child: CircularProgressIndicator())
        : errorMessage != ''
            ? SomethingWentWrong(
                text: errorMessage,
                press: () => _getSearchResult(widget.query),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Stores'.tr,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: getProportionateScreenWidth(20),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ecommerces.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text('No data'.tr),
                              )
                            : Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ...List.generate(
                                      ecommerces.length,
                                      (index) => Container(
                                        width: SizeConfig.screenWidth * 0.5,
                                        height: SizeConfig.screenWidth * 0.52,
                                        margin: const EdgeInsets.only(
                                          right: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: EcommerceCard(detail: ecommerces[index]),
                                      ),
                                    ),
                                    SizedBox(width: getProportionateScreenWidth(20)),
                                  ],
                                ),
                              ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Products'.tr,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: getProportionateScreenWidth(20),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: products.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text('No data'.tr),
                              )
                            : Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ...List.generate(
                                      products.length,
                                      (index) => Container(
                                        width: SizeConfig.screenWidth * 0.5,
                                        height: SizeConfig.screenWidth * 0.66,
                                        margin: const EdgeInsets.only(
                                          right: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: ProductCard(product: products[index]),
                                      ),
                                    ),
                                    SizedBox(width: getProportionateScreenWidth(20)),
                                  ],
                                ),
                              ),
                      ),
                      const SizedBox(height: 20),
                      DiscountBanner(),
                    ],
                  ),
                ),
              );
  }
}
