// ignore_for_file: deprecated_member_use, unrelated_type_equality_checks

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jummi/constants.dart';
import 'package:jummi/models/Cart.dart';
import 'package:jummi/screens/order_details/components/bottom_part.dart';
import 'package:jummi/screens/product_details/product_details_screen.dart';
import 'package:jummi/services/cart_services.dart';
import 'package:url_launcher/url_launcher.dart';

class Body extends StatefulWidget {
  const Body({required this.order, super.key});
  final Cart order;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool loading = true;
  late Cart? order;
  late String? orderError;

  Future<void> _getOrder() async {
    setState(() {
      loading = true;
    });
    final dynamic response = await CartService.fetchOrder(widget.order.id);
    if (response != null && response.statusCode == 200) {
      setState(() {
        order = Cart.fromJson(json.decode(utf8.decode(response.bodyBytes)));
        loading = false;
      });
    } else if (response != null && response.statusCode == 404) {
      setState(() {
        orderError = 'Order not found';
        loading = false;
      });
    } else {
      setState(() {
        orderError = 'Something went wrong';
        loading = false;
      });
    }
  }

  @override
  void initState() {
    _getOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: loading == true
          ? const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: CircularProgressIndicator(),
              ),
            )
          : orderError != null
              ? const Center(
                  child: Text('Error'),
                )
              : Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'User detils',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Text(
                                'Address:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text('${order!.address}'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Phone:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text('${order!.customer!.phone}'),
                                ],
                              ),
                              OutlinedButton(
                                onPressed: () async {
                                  final url = 'tel:${order!.customer!.phone}';
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 20),
                                  side: const BorderSide(width: 1.0, color: kPrimaryColor),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.phone,
                                      size: 14,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Call',
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      margin: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        bottom: 10,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Products',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          for (var i = 0; i < order!.items!.length; i++)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: i + 1 != order!.items!.length
                                    ? const Border(
                                        bottom: BorderSide(
                                          color: Colors.black12,
                                          width: 1,
                                        ),
                                      )
                                    : const Border(),
                              ),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => Get.to(
                                      DetailsScreen(product_id: order!.items![i].product!.id!, editable: false),
                                    ),
                                    child: Container(
                                      height: 80,
                                      width: 80,
                                      decoration: order!.items![i].product!.images!.isNotEmpty
                                          ? BoxDecoration(
                                              border: Border.all(color: Colors.black12),
                                              color: kSecondaryColor.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(5),
                                              image: DecorationImage(
                                                image: NetworkImage(media_host + order!.items![i].product!.images![0].srcThumb.toString()),
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : BoxDecoration(
                                              border: Border.all(color: Colors.black12),
                                              color: kSecondaryColor.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(5),
                                              image: const DecorationImage(
                                                image: AssetImage('assets/images/noimage-product.png'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          order!.items![i].product!.name.toString(),
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                        order!.items![i].product!.price == '0.00'
                                            ? const SizedBox()
                                            : Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${order!.items![i].product!.discountPrice == null || order!.items![i].product!.discountPrice == "0.00" ? "${order!.items![i].product!.price}" : "${order!.items![i].product!.discountPrice}"} TMT",
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      color: kPrimaryColor,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  order!.items![i].product!.discountPrice != null && order!.items![i].product!.discountPrice != '0.00' && order!.items![i].product!.price != 0
                                                      ? Text(
                                                          '${order!.items![i].product!.price} TMT',
                                                          style: const TextStyle(
                                                            decoration: TextDecoration.lineThrough,
                                                          ),
                                                        )
                                                      : const SizedBox(),
                                                ],
                                              ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        'x${double.parse(order!.items![i].count.toString()).toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      margin: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        bottom: 10,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Order info',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Text(
                                'Order date:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(DateFormat('dd.MM.yyyy / HH:mm:ss').format(order!.createdAt!)),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Text(
                                'Total:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text('${order!.total} TMT'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    BottomPart(order: order!),
                  ],
                ),
    );
  }
}
