import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jummi/models/Cart.dart';
import 'package:jummi/screens/order_details/order_details_screen.dart';
import 'package:jummi/services/cart_services.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool loading = true;
  late List<Cart> orders = [];
  late String? ordersError;

  Future<void> _getEcommerceOrders() async {
    setState(() {
      loading = true;
    });
    final dynamic response = await CartService.fetchEcommerceOrders();
    if (response != null && response.statusCode == 200) {
      setState(() {
        ordersError = null;
        orders.addAll(
          cartsFromJson(
            jsonEncode(jsonDecode(utf8.decode(response.bodyBytes))),
          ),
        );
        loading = false;
      });
    } else if (response != null && response.statusCode == 404) {
      setState(() {
        ordersError = 'Orders not found';
        loading = false;
      });
    } else {
      setState(() {
        ordersError = 'Something went wrong';
        loading = false;
      });
    }
  }

  @override
  void initState() {
    _getEcommerceOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        setState(() {
          orders = [];
        });
        return _getEcommerceOrders();
      },
      child: SingleChildScrollView(
        child: loading == true
            ? Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : ordersError != null
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 50),
                    child: Center(
                      child: Text(ordersError.toString()),
                    ),
                  )
                : Column(
                    children: [
                      const SizedBox(height: 10),
                      for (var i = 0; i < orders.length; i++)
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                            bottom: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: Offset.zero,
                              ),
                            ],
                            color: orders[i].viewed == true ? Colors.white : const Color.fromARGB(255, 255, 226, 215),
                          ),
                          child: TextButton(
                            onPressed: () => Get.to(
                              OrderDetailsScreen(
                                order: orders[i],
                              ),
                            )?.then(
                              (value) => {
                                setState(() {
                                  orders = [];
                                }),
                                _getEcommerceOrders(),
                              },
                            ),
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 10,
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            orders[i].customer!.phone.toString(),
                                            style: const TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.location_pin,
                                                size: 14,
                                                color: Colors.black38,
                                              ),
                                              const SizedBox(width: 3),
                                              Text(
                                                orders[i].address.toString(),
                                                style: const TextStyle(
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 2,
                                            horizontal: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: orders[i].status == 'pending'
                                                ? Colors.amber
                                                : orders[i].status == 'success'
                                                    ? Colors.green
                                                    : Colors.red,
                                          ),
                                          child: Text(
                                            orders[i].status.toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Text(
                                              '${orders[i].items!.length} items',
                                              style: const TextStyle(
                                                color: Colors.black54,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              '${orders[i].total} TMT',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  height: 1,
                                  color: Colors.black26,
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_month,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 3),
                                        Text(
                                          DateFormat('dd.MM.yyyy / HH:mm:ss').format(orders[i].createdAt!),
                                        ),
                                      ],
                                    ),
                                    const Icon(Icons.chevron_right),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 700),
                    ],
                  ),
      ),
    );
  }
}
