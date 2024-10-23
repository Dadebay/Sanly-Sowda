import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jummi/models/Cart.dart';
import 'package:jummi/services/cart_services.dart';

class BottomPart extends StatefulWidget {
  const BottomPart({required this.order, super.key});
  final Cart order;

  @override
  State<BottomPart> createState() => _BottomPartState();
}

class _BottomPartState extends State<BottomPart> {
  bool rejectLoading = false;
  bool acceptLoading = false;
  late String status = 'pending';

  Future<void> _rejectOrder() async {
    setState(() {
      rejectLoading = true;
    });
    final dynamic response = await CartService.rejectOrder(widget.order.id);
    if (response != null && response.statusCode == 200) {
      setState(() {
        status = 'failed';
        rejectLoading = false;
      });
    } else if (response != null && response.statusCode == 404) {
      Get.snackbar(
        'Error',
        'Order not found!',
        snackPosition: SnackPosition.TOP,
      );
      setState(() {
        rejectLoading = false;
      });
    } else {
      Get.snackbar(
        'Error',
        'Something went wrong!',
        snackPosition: SnackPosition.TOP,
      );
      setState(() {
        rejectLoading = false;
      });
    }
  }

  Future<void> _acceptOrder() async {
    setState(() {
      acceptLoading = true;
    });
    final dynamic response = await CartService.acceptOrder(widget.order.id);
    if (response != null && response.statusCode == 200) {
      setState(() {
        status = 'success';
        acceptLoading = false;
      });
    } else if (response != null && response.statusCode == 404) {
      Get.snackbar(
        'Error',
        'Order not found!',
        snackPosition: SnackPosition.TOP,
      );
      setState(() {
        acceptLoading = false;
      });
    } else {
      Get.snackbar(
        'Error',
        'Something went wrong!',
        snackPosition: SnackPosition.TOP,
      );
      setState(() {
        acceptLoading = false;
      });
    }
  }

  @override
  void initState() {
    status = widget.order.status.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: status == 'failed'
          ? const Row(
              children: [
                Text(
                  'Status:',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  'Order rejected',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              ],
            )
          : status == 'success'
              ? Container(
                  decoration: const BoxDecoration(),
                  child: const Row(
                    children: [
                      Text(
                        'Status:',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Order accepted',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              : Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: rejectLoading == true ? Colors.red.withOpacity(0.5) : Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        onPressed: () => rejectLoading == true ? {} : _rejectOrder(),
                        child: const Text(
                          'Reject',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: acceptLoading == true ? Colors.green.withOpacity(0.5) : Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        onPressed: () => acceptLoading == true ? {} : _acceptOrder(),
                        child: const Text(
                          'Accept',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
