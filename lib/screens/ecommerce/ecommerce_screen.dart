// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jummi/components/something_went_wrong.dart';
import 'package:jummi/models/Ecommerce.dart';
import 'package:jummi/screens/ecommerce/components/body.dart';
import 'package:jummi/screens/home/home_screen.dart';
import 'package:jummi/services/ecommerce_services.dart';
import 'package:jummi/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EcommerceScreen extends StatefulWidget {
  const EcommerceScreen({required this.ecommerce_id, super.key});
  static String routeName = '/ecommerce';
  final int ecommerce_id;

  @override
  State<EcommerceScreen> createState() => _EcommerceScreenState();
}

class _EcommerceScreenState extends State<EcommerceScreen> {
  bool isEcommerceLoading = true;
  late Ecommerce? ecommerce;
  late String? ecommerceError;

  Future<void> _getEcommerce() async {
    setState(() {
      isEcommerceLoading = true;
    });
    final dynamic response = await EcommerceService.fetchEcommerce(widget.ecommerce_id.toString());
    if (response != null && response.statusCode == 200) {
      setState(() {
        ecommerce = Ecommerce.fromJson(json.decode(utf8.decode(response.bodyBytes)));
        isEcommerceLoading = !isEcommerceLoading;
      });
    } else if (response != null && response.statusCode == 404) {
      setState(() {
        ecommerceError = 'Not found'.tr;
        isEcommerceLoading = !isEcommerceLoading;
      });
    } else if (response != null && response.statusCode == 401) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('access_token');
    } else {
      setState(() {
        ecommerceError = 'Something went wrong!'.tr;
        isEcommerceLoading = !isEcommerceLoading;
      });
    }
  }

  @override
  void initState() {
    _getEcommerce();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: isEcommerceLoading == true
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : ecommerce == null
              ? Scaffold(
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SomethingWentWrong(
                        text: ecommerceError.toString(),
                        press: _getEcommerce,
                      ),
                      ElevatedButton(
                        onPressed: () => Get.to(const HomeScreen()),
                        child: Text('Home'.tr),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () {
                    return _getEcommerce();
                  },
                  child: Body(ecommerce: ecommerce!),
                ),
    );
  }
}
