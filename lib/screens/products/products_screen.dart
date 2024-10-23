import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jummi/components/custom_bottom_nav_bar.dart';
import 'package:jummi/components/product_card.dart';
import 'package:jummi/components/something_went_wrong.dart';
import 'package:jummi/constants.dart';
import 'package:jummi/controllers/products_filter.dart';
import 'package:jummi/enums.dart';
import 'package:jummi/models/Product.dart';
import 'package:jummi/screens/home/home_screen.dart';
import 'package:jummi/screens/products/components/filter_drawer.dart';
import 'package:jummi/services/product_services.dart';
import 'package:jummi/size_config.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey<ScaffoldState>();

  late ScrollController _scrollController;
  ScrollController scrollController = ScrollController();
  bool isProdcutsLoading = true;
  late List<Product> products = [];
  late String? productsError;
  int currentPage = 1;
  bool isPaginating = false;

  final ProductsFilterController _pfController = Get.put(ProductsFilterController());

  final TextEditingController _wordText = TextEditingController();

  Future<void> _getProducts() async {
    final dynamic response = await ProductService.fetchExploreProducts(currentPage);
    if (response != null && response.statusCode == 200) {
      setState(() {
        productsError = null;
        products.addAll(
          productFromJson(
            jsonEncode(
              jsonDecode(utf8.decode(response.bodyBytes))['results'],
            ),
          ),
        );
        isProdcutsLoading = false;
        isPaginating = false;
      });
    } else if (response != null && response.statusCode == 404) {
      setState(() {
        isProdcutsLoading = false;
        isPaginating = false;
      });
    } else {
      setState(() {
        productsError = 'Something went wrong!'.tr;
        isProdcutsLoading = false;
        isPaginating = false;
      });
    }
  }

  @override
  void initState() {
    _wordText.text = _pfController.word.value;
    _pfController.setSearch(false);
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
    return SafeArea(
      child: Scaffold(
        appBar: appBarBuilder(context),
        key: _drawerKey,
        endDrawer: FilterDrawer(_drawerKey),
        onEndDrawerChanged: (isOpened) {
          if (!isOpened && _pfController.search.value == true) {
            _pfController.setSearch(false);
            setState(() {
              currentPage = 1;
              products.removeRange(0, products.length);
              isProdcutsLoading = true;
            });
            _getProducts();
          }
        },
        body: RefreshIndicator(
          onRefresh: () {
            setState(() {
              currentPage = 1;
              products.removeRange(0, products.length);
              isProdcutsLoading = true;
            });
            return _getProducts();
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const ScrollPhysics(),
            child: Column(
              children: [
                isProdcutsLoading == true
                    ? const Padding(
                        padding: EdgeInsets.only(top: 300),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : productsError != null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SomethingWentWrong(
                                text: productsError.toString(),
                                press: () {
                                  setState(() {
                                    currentPage = 1;
                                    products.removeRange(0, products.length);
                                    isProdcutsLoading = true;
                                  });
                                  _getProducts();
                                },
                              ),
                              ElevatedButton(
                                onPressed: () => Get.to(const HomeScreen()),
                                child: Text('Home'.tr),
                              ),
                            ],
                          )
                        : products.isEmpty
                            ? Container(
                                padding: const EdgeInsets.only(top: 20),
                                width: double.infinity,
                                child: Center(
                                  child: Text('No products'.tr),
                                ),
                              )
                            : GridView.count(
                                primary: false,
                                shrinkWrap: true,
                                childAspectRatio: 0.7,
                                crossAxisCount: 2,
                                crossAxisSpacing: 15.0,
                                mainAxisSpacing: 15.0,
                                padding: const EdgeInsets.all(10.0),
                                children: List.generate(
                                  products.length,
                                  (index) {
                                    return ProductCard(
                                      product: products[index],
                                    );
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
              ],
            ),
          ),
        ),
        bottomNavigationBar: const CustomBottomNavBar(
          selectedMenu: MenuState.ecommerces,
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
      title: Container(
        width: SizeConfig.screenWidth * 0.65,
        height: SizeConfig.screenHeight * 0.055,
        decoration: BoxDecoration(
          color: kSecondaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          controller: _wordText,
          onChanged: (value) async {
            _pfController.setWord(value);
          },
          onEditingComplete: () {
            _pfController.setSearch(false);
            setState(() {
              currentPage = 1;
              products = [];
              isProdcutsLoading = true;
            });
            _getProducts();
          },
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            hintText: 'Products'.tr,
            suffixIcon: IconButton(
              onPressed: () {
                _pfController.setSearch(false);
                setState(() {
                  currentPage = 1;
                  products = [];
                  isProdcutsLoading = true;
                });
                _getProducts();
              },
              icon: Icon(
                Icons.search,
                size: SizeConfig.screenWidth * 0.06,
              ),
            ),
            suffixIconConstraints: BoxConstraints(
              maxHeight: SizeConfig.screenHeight * 0.2,
              minWidth: SizeConfig.screenWidth * 0.12,
            ),
            contentPadding: EdgeInsets.only(
              left: getProportionateScreenWidth(20),
            ),
            isDense: true,
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            _drawerKey.currentState!.openEndDrawer();
          },
          icon: Icon(
            Icons.filter_alt_outlined,
            size: SizeConfig.screenWidth * 0.07,
          ),
        ),
      ],
    );
  }
}
