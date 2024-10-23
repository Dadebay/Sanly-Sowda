import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jummi/models/Noti.dart';
import 'package:jummi/screens/notification_detail/notification_detail.dart';
import 'package:jummi/services/noti_services.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late bool loading = true;
  late List<Noti> notifications = [];
  late String? notificationsError;

  Future<void> _getNotifications() async {
    setState(() {
      loading = true;
    });
    final dynamic response = await NotiService.fetchNotifications();
    if (response != null && response.statusCode == 200) {
      setState(() {
        notificationsError = null;
        notifications.addAll(notiFromJson(jsonEncode(jsonDecode(utf8.decode(response.bodyBytes)))));
        loading = false;
      });
    } else if (response != null && response.statusCode == 404) {
      setState(() {
        notificationsError = 'Error occured!'.tr;
        loading = false;
      });
    } else {
      setState(() {
        notificationsError = 'Something went wrong!'.tr;
        loading = false;
      });
    }
  }

  @override
  void initState() {
    _getNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: loading == true
          ? const CircularProgressIndicator()
          : notificationsError != null
              ? Text('$notificationsError')
              : notifications.isEmpty
                  ? Text('No data'.tr)
                  : Column(
                      children: [
                        const SizedBox(height: 10),
                        for (var i = 0; i < notifications.length; i++)
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
                                  spreadRadius: 5,
                                  blurRadius: 2,
                                  offset: Offset.zero,
                                ),
                              ],
                              color: Colors.white,
                            ),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 10,
                                ),
                              ),
                              onPressed: () => Get.to(
                                NotificationDetail(
                                  id: notifications[i].id.toString(),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.notifications_none),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${notifications[i].title}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                        ),
                                        Text(
                                          '${notifications[i].content}',
                                          style: const TextStyle(
                                            color: Colors.black54,
                                          ),
                                          maxLines: 1,
                                        ),
                                        Text(DateFormat('dd.MM.yyyy / HH:mm:ss').format(notifications[i].createdAt!)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Icon(Icons.chevron_right),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
    );
  }
}
