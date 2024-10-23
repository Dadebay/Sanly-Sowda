import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jummi/components/custom_bottom_nav_bar.dart';
import 'package:jummi/components/product_card.dart';
import 'package:jummi/constants.dart';
import 'package:jummi/controllers/ecommerce_filter.dart';
import 'package:jummi/controllers/main_controller.dart';
import 'package:jummi/enums.dart';
import 'package:jummi/models/Ecommerce.dart';
import 'package:jummi/models/Product.dart';
import 'package:jummi/screens/ecommerce/components/filter_drawer.dart';
import 'package:jummi/screens/ecommerce/components/header.dart';
import 'package:jummi/screens/ecommerce/components/info.dart';
import 'package:jummi/screens/ecommerce/components/line.dart';
import 'package:jummi/screens/ecommerce/components/product_form.dart';
import 'package:jummi/services/product_services.dart';
import 'package:jummi/size_config.dart';

class Body extends StatefulWidget {
  const Body({required this.ecommerce, super.key});

  final Ecommerce ecommerce;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late ScrollController _scrollController;
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController = ScrollController();
  bool isProdcutsLoading = true;
  late List<Product> products = [];
  late String? productsError;
  int currentPage = 1;
  bool isPaginating = false;
  final MainController _mainC = Get.put(MainController());
  final TextEditingController _wordText = TextEditingController();
  final EcommerceFilterController _efController = Get.put(EcommerceFilterController());

  Future<void> _getProducts() async {
    final dynamic response = await ProductService.fetchEcommerceProducts(widget.ecommerce.id, currentPage);
    if (response != null && response.statusCode == 200) {
      setState(() {
        productsError = null;
        products.addAll(productFromJson(jsonEncode(jsonDecode(utf8.decode(response.bodyBytes))['results'])));
        isProdcutsLoading = false;
        isPaginating = false;
      });
    } else {
      setState(() {
        productsError = 'Something went wrong';
        isProdcutsLoading = false;
        isPaginating = false;
      });
    }
  }

  @override
  void initState() {
    _efController.clearFilter();
    _wordText.text = _efController.word.value;
    _getProducts();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.hasClients) {
        if (_scrollController.position.maxScrollExtent == _scrollController.offset) {
          currentPage = currentPage + 1;
          setState(() {
            isPaginating = true;
          });
          _getProducts();
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      endDrawer: FilterDrawer(_drawerKey),
      onEndDrawerChanged: (isOpened) {
        if (!isOpened && _efController.search.value == true) {
          _efController.setSearch(false);
          setState(() {
            currentPage = 1;
            products.removeRange(0, products.length);
            isProdcutsLoading = true;
          });
          _getProducts();
        }
      },
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            Header(ecommerce: widget.ecommerce),
            Info(ecommerce: widget.ecommerce),
            const SizedBox(height: 10),
            drawLine(),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: kSecondaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      height: SizeConfig.screenHeight * 0.06,
                      child: TextField(
                        controller: _wordText,
                        onChanged: (value) {
                          _efController.setWord(value);
                        },
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: 'Search'.tr,
                          suffixIcon: IconButton(
                            onPressed: () {
                              _efController.setSearch(false);
                              setState(() {
                                currentPage = 1;
                                products = [];
                                isProdcutsLoading = true;
                              });
                              _getProducts();
                            },
                            icon: const Icon(Icons.search),
                          ),
                          suffixIconConstraints: BoxConstraints(maxHeight: SizeConfig.screenHeight * 0.2, minWidth: SizeConfig.screenWidth * 0.12),
                          contentPadding: EdgeInsets.only(
                            left: getProportionateScreenWidth(20),
                          ),
                          isDense: true,
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => _mainC.user.value.userEcommerce != null && _mainC.user.value.userEcommerce!.id == widget.ecommerce.id ? const SizedBox(width: 10) : const SizedBox(),
                  ),
                  Obx(
                    () => _mainC.user.value.userEcommerce != null && _mainC.user.value.userEcommerce!.id == widget.ecommerce.id
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(15)),
                              color: kSecondaryColor.withOpacity(0.1),
                            ),
                            child: IconButton(
                              onPressed: () => Get.to(
                                ProductForm(product: null, ecommerce: widget.ecommerce),
                              ),
                              icon: const Icon(
                                Icons.add,
                                color: Colors.black54,
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ),
                ],
              ),
            ),
            isProdcutsLoading == true
                ? const Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : GridView.count(
                    primary: false,
                    shrinkWrap: true,
                    childAspectRatio: 0.68,
                    crossAxisCount: 2,
                    crossAxisSpacing: 15.0,
                    mainAxisSpacing: 15.0,
                    padding: const EdgeInsets.all(10.0),
                    children: List.generate(
                      products.length,
                      (index) {
                        return ProductCard(product: products[index]);
                      },
                    ),
                  ),
            isPaginating == true
                ? const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                      SizedBox(height: 10),
                    ],
                  )
                : const SizedBox(),
            const SizedBox(height: 50),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        selectedMenu: MenuState.ecommerces,
      ),
    );
  }
}
