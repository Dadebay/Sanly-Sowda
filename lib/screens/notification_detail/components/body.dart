import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jummi/constants.dart';
import 'package:jummi/models/Noti.dart';
import 'package:jummi/screens/ecommerce/ecommerce_screen.dart';
import 'package:jummi/screens/product_details/product_details_screen.dart';
import 'package:jummi/services/noti_services.dart';
import 'package:url_launcher/url_launcher.dart';

class Body extends StatefulWidget {
  const Body({required this.id, super.key});
  final String id;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool loading = true;
  late Noti? notification;
  late String? notificationError;
  late bool linked = false;

  Future<void> _getNotification() async {
    setState(() {
      loading = true;
    });
    final dynamic response = await NotiService.fetchNotification(widget.id);
    if (response != null && response.statusCode == 200) {
      setState(() {
        notification = Noti.fromJson(json.decode(utf8.decode(response.bodyBytes)));
        loading = false;
      });
      if (notification!.slug != null && notification!.slug.toString().startsWith('http')) {
        setState(() {
          linked = true;
        });
      } else if (notification!.slug != null && notification!.slug.toString().startsWith('product:')) {
        setState(() {
          linked = true;
        });
      } else if (notification!.slug != null && notification!.slug.toString().startsWith('ecommerce:')) {
        setState(() {
          linked = true;
        });
      } else {
        setState(() {
          linked = false;
        });
      }
    } else if (response != null && response.statusCode == 404) {
      setState(() {
        notificationError = 'Notification not found';
        loading = false;
      });
    } else {
      setState(() {
        notificationError = 'Something went wrong';
        loading = false;
      });
    }
  }

  @override
  void initState() {
    _getNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading == true
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : notificationError != null
            ? Center(
                child: Text('$notificationError'),
              )
            : notification == null
                ? const Center(
                    child: Text('No Notification'),
                  )
                : SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification!.title.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            DateFormat('dd.MM.yyyy / HH:mm:ss').format(notification!.createdAt!),
                            style: const TextStyle(
                              color: kPrimaryColor,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(notification!.content.toString()),
                          const SizedBox(height: 10),
                          linked == true
                              ? SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (notification!.slug != null && notification!.slug.toString().startsWith('http')) {
                                        // Web url
                                        await launchUrl(Uri.parse(notification!.slug.toString()));
                                      } else if (notification!.slug != null && notification!.slug.toString().startsWith('product:')) {
                                        // Product
                                        await Get.to(
                                          DetailsScreen(
                                            product_id: int.parse(notification!.slug.toString().substring(8)),
                                            editable: false,
                                          ),
                                        );
                                      } else if (notification!.slug != null && notification!.slug.toString().startsWith('ecommerce:')) {
                                        // Ecommerce
                                        await Get.to(
                                          EcommerceScreen(
                                            ecommerce_id: int.parse(notification!.slug.toString().substring(10)),
                                          ),
                                        );
                                      } else {
                                        // Nothing
                                      }
                                    },
                                    child: const Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.open_in_new),
                                        SizedBox(width: 5),
                                        Text(
                                          'View',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
  }
}
