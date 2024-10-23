// ignore_for_file: unrelated_type_equality_checks

import 'dart:convert';

import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jummi/components/custom_bottom_nav_bar.dart';
import 'package:jummi/components/ecommerce_card.dart';
import 'package:jummi/constants.dart';
import 'package:jummi/controllers/ecommerces_filter.dart';
import 'package:jummi/endpoints.dart';
import 'package:jummi/enums.dart';
import 'package:jummi/models/Ecommerce.dart';
import 'package:jummi/screens/ecommerces/components/filter_drawer.dart';
import 'package:jummi/screens/home/home_screen.dart';
import 'package:jummi/services/ecommerce_services.dart';
import 'package:jummi/size_config.dart';

class EcommercesScreen extends StatefulWidget {
  const EcommercesScreen({super.key});

  @override
  State<EcommercesScreen> createState() => _EcommercesScreenState();
}

class _EcommercesScreenState extends State<EcommercesScreen> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey<ScaffoldState>();
  late ScrollController _scrollController;
  int currentPage = 1;
  bool isEcommercesLoading = true;
  late List<Ecommerce>? ecommerces = [];
  late String? ecommercesError;
  bool isPaginating = false;
  final EcommercesFilterController _efController = Get.put(EcommercesFilterController());

  final TextEditingController _wordText = TextEditingController();

  Future<void> _getEcommerces() async {
    final dynamic response = await EcommerceService.fetchEcommerces(currentPage);
    if (response != null && response.statusCode == 200) {
      setState(() {
        ecommercesError = null;
        ecommerces?.addAll(ecommerceFromJson(jsonEncode(jsonDecode(utf8.decode(response.bodyBytes))['results'])));
        isEcommercesLoading = false;
        isPaginating = false;
      });
    } else {
      setState(() {
        ecommercesError = 'Something went wrong!'.tr;
        isEcommercesLoading = false;
        isPaginating = false;
      });
    }
  }

  @override
  void initState() {
    _wordText.text = _efController.word.value;
    _efController.setSearch(false);
    _getEcommerces();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.hasClients) {
        if (_scrollController.position.maxScrollExtent == _scrollController.offset) {
          currentPage = currentPage + 1;
          setState(() {
            isPaginating = true;
          });
          _getEcommerces();
        }
      }
    });
    super.initState();
  }

  late FilterDrawer filter;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        key: _drawerKey,
        appBar: appBarBuilder(context),
        endDrawer: FilterDrawer(_drawerKey),
        onEndDrawerChanged: (isOpened) {
          if (!isOpened && _efController.search.value == true) {
            _efController.setSearch(false);
            setState(() {
              currentPage = 1;
              ecommerces!.removeRange(0, ecommerces!.length);
              isEcommercesLoading = true;
            });
            _getEcommerces();
          }
        },
        body: isEcommercesLoading == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ecommerces!.isEmpty
                ? Center(
                    child: Text('No stores'.tr),
                  )
                : RefreshIndicator(
                    onRefresh: () {
                      setState(() {
                        currentPage = 1;
                        ecommerces!.removeRange(0, ecommerces!.length);
                        isEcommercesLoading = true;
                      });
                      return _getEcommerces();
                    },
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          right: 0,
                          left: 0,
                          bottom: 0,
                          child: GridView.count(
                            childAspectRatio: 0.85,
                            controller: _scrollController,
                            physics: const ScrollPhysics(),
                            padding: const EdgeInsets.only(
                              top: 10,
                              left: 10,
                              right: 10,
                              bottom: 80,
                            ),
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            children: [
                              ...List.generate(
                                ecommerces!.length,
                                (index) {
                                  return EcommerceCard(detail: ecommerces![index]);
                                },
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          left: 0,
                          child: isPaginating == true
                              ? const Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 20),
                                    Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    SizedBox(height: 80),
                                  ],
                                )
                              : const SizedBox(),
                        ),
                      ],
                    ),
                  ),
        bottomNavigationBar: const CustomBottomNavBar(
          selectedMenu: MenuState.ecommerces,
        ),
      ),
    );
  }

  AppBar appBarBuilder(BuildContext context) {
    final client = http.Client();
    Future<List<String>> fetchSuggestions(String searchValue) async {
      final List<String> ss = [];
      if (searchValue.length >= 3) {
        final response = await client.get(Uri.parse('$get_search_URL?q=$searchValue'));
        if (response.statusCode == 200) {
          final stores = json.decode(utf8.decode(response.bodyBytes))['stores'];
          final products = json.decode(utf8.decode(response.bodyBytes))['products'];
          if (stores.length > 0) {
            for (var i = 0; i < stores.length; i++) {
              ss.add(stores[i]['name']);
            }
          }
          if (products.length > 0) {
            for (var i = 0; i < products.length; i++) {
              ss.add(products[i]['name']);
            }
          }
        }
      }
      return ss;
    }

    return AppBar(
      toolbarHeight: SizeConfig.screenHeight * 0.07,
      leading: IconButton(
        onPressed: () => Get.off(const HomeScreen()),
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
        child: EasyAutocomplete(
          initialValue: _efController.word.toString(),
          decoration: InputDecoration(
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            hintText: 'Search'.tr,
            suffixIcon: SizedBox(
              width: SizeConfig.screenWidth * 0.095,
              height: SizeConfig.screenWidth * 0.095,
              child: IconButton(
                onPressed: () {
                  _efController.setSearch(false);
                  setState(() {
                    currentPage = 1;
                    ecommerces = [];
                    isEcommercesLoading = true;
                  });
                  _getEcommerces();
                },
                icon: Icon(
                  Icons.search,
                  size: SizeConfig.screenWidth * 0.06,
                ),
              ),
            ),
            suffixIconConstraints: BoxConstraints(maxHeight: SizeConfig.screenHeight * 0.2, minWidth: SizeConfig.screenWidth * 0.12),
            contentPadding: EdgeInsets.only(
              top: getProportionateScreenWidth(12),
              bottom: getProportionateScreenWidth(12),
              left: getProportionateScreenWidth(20),
              right: getProportionateScreenWidth(0),
            ),
            isDense: true,
          ),
          asyncSuggestions: (searchValue) async => fetchSuggestions(searchValue),
          progressIndicatorBuilder: const Center(
            child: CircularProgressIndicator(),
          ),
          onChanged: (value) {
            _efController.setWord(value);
          },
          onSubmitted: (value) {
            _efController.setSearch(false);
            setState(() {
              currentPage = 1;
              ecommerces = [];
              isEcommercesLoading = true;
            });
            _getEcommerces();
          },
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            _drawerKey.currentState!.openEndDrawer();
          },
          icon: Obx(
            () => Icon(
              Icons.filter_alt_outlined,
              color: _efController.checkFilter() == true ? kPrimaryColor : Colors.black,
              size: SizeConfig.screenWidth * 0.07,
            ),
          ),
        ),
      ],
    );
  }
}
