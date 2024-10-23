import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jummi/components/product_card.dart';
import 'package:jummi/components/something_went_wrong.dart';
import 'package:jummi/models/Liked.dart';
import 'package:jummi/screens/home/home_screen.dart';
import 'package:jummi/services/product_services.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final ScrollController _scrollController = ScrollController();
  ScrollController scrollController = ScrollController();
  bool isProdcutsLoading = true;
  late List<Liked> likeds = [];
  late String? productsError;
  int currentPage = 1;
  bool isPaginating = false;

  Future<void> _getProducts() async {
    final dynamic response = await ProductService.getLastVisitedProducts(currentPage);
    if (response != null && response.statusCode == 200) {
      setState(() {
        productsError = null;
        likeds.addAll(likedFromJson(jsonEncode(jsonDecode(utf8.decode(response.bodyBytes))['results'])));
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
    _getProducts();
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
    return RefreshIndicator(
      onRefresh: () {
        setState(() {
          currentPage = 1;
          likeds.removeRange(0, likeds.length);
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
                                isProdcutsLoading = true;
                              });
                              _getProducts();
                            },
                          ),
                          ElevatedButton(
                            onPressed: () => Get.to(const HomeScreen()),
                            child: const Text('Home'),
                          ),
                        ],
                      )
                    : likeds.isEmpty
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
                              likeds.length,
                              (index) {
                                return ProductCard(product: likeds[index].product!);
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
    );
  }
}
