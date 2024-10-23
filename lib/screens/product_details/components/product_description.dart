// ignore_for_file: unrelated_type_equality_checks

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:jummi/screens/product_details/components/product_ecommerce.dart';
import 'package:jummi/services/product_services.dart';

import '../../../constants.dart';
import '../../../models/Product.dart';
import '../../../size_config.dart';

class ProductDescription extends StatefulWidget {
  const ProductDescription({
    required this.product,
    super.key,
  });

  final Product product;

  @override
  State<ProductDescription> createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  bool _liked = false;
  int _likeClickCount = 0;
  int _likesCount = 0;
  bool _likeLoading = false;

  void _handleLike() async {
    setState(() {
      _likeLoading = true;
    });
    if (_likeClickCount < 5) {
      final response = await ProductService.likeProduct(widget.product.id);
      if (response != null && response.statusCode == 200) {
        setState(() {
          if (_liked) {
            _likesCount = _likesCount - 1;
          } else {
            _likesCount = _likesCount + 1;
          }
          _liked = !_liked;
          _likeLoading = false;
        });
      } else if (response == null) {
        setState(() {
          _likeLoading = false;
        });
        Get.snackbar(
          'Error',
          'Something went wrong!'.tr,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.black,
          margin: const EdgeInsets.all(10),
        );
      } else {
        setState(() {
          _likeLoading = false;
        });
        Get.snackbar(
          'Error',
          json.decode(utf8.decode(response.bodyBytes))['detail'].toString(),
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.black,
          margin: const EdgeInsets.all(10),
        );
      }
    } else {
      setState(() {
        _likeLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Info: Clicked like button many!'.tr),
          margin: const EdgeInsets.all(10),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
        ),
      );
    }
    setState(() {
      _likeClickCount++;
    });
  }

  @override
  void initState() {
    _liked = widget.product.liked!;
    _likesCount = widget.product.likesCount!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.product.images!.isEmpty ? const SizedBox(height: 10) : const SizedBox(height: 20),
        // Name and prices
        Padding(
          padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.product.status != 'success'
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            margin: const EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                              color: widget.product.status == 'failed' ? Colors.red : Colors.amber,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${"Status".tr}: ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    height: 1,
                                    fontSize: SizeConfig.screenWidth * 0.04,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    widget.product.status == 'failed' ? 'Failed'.tr : 'Pending'.tr,
                                    style: TextStyle(
                                      color: Colors.white,
                                      height: 1,
                                      fontSize: SizeConfig.screenWidth * 0.04,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.product.name.toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: SizeConfig.screenWidth * 0.045,
                              height: 1.1,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.visibility_outlined,
                                  color: Colors.black54,
                                  size: SizeConfig.screenWidth * 0.04,
                                ),
                                const SizedBox(width: 2),
                                Text(widget.product.viewsCount.toString()),
                              ],
                            ),
                            const SizedBox(width: 10),
                            Row(
                              children: [
                                Icon(
                                  Icons.favorite_outline_rounded,
                                  color: Colors.black54,
                                  size: SizeConfig.screenWidth * 0.04,
                                ),
                                const SizedBox(width: 2),
                                Text(_likesCount.toString()),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.category_outlined,
                                    size: SizeConfig.screenWidth * 0.035,
                                    color: Colors.black54,
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      widget.product.category!.name!.tm.toString(),
                                      style: TextStyle(
                                        fontSize: SizeConfig.screenWidth * 0.04,
                                        height: 1.2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "${"Code".tr}:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontSize: SizeConfig.screenWidth * 0.045,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    widget.product.id.toString(),
                                    style: TextStyle(
                                      fontSize: SizeConfig.screenWidth * 0.045,
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      await Clipboard.setData(
                                        ClipboardData(text: widget.product.id.toString()),
                                      );
                                      await Fluttertoast.showToast(
                                        msg: 'Code copied to clipboard!'.tr,
                                      );
                                    },
                                    icon: Icon(
                                      Icons.copy,
                                      size: SizeConfig.screenWidth * 0.045,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        widget.product.price == '0.00'
                            ? const SizedBox()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "${widget.product.discountPrice == null || widget.product.discountPrice == "0.00" ? "${widget.product.price}" : "${widget.product.discountPrice}"} TMT",
                                    style: TextStyle(
                                      fontSize: SizeConfig.screenWidth * 0.045,
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  widget.product.discountPrice != null && widget.product.discountPrice != '0.00' && widget.product.price != 0
                                      ? Text(
                                          '${widget.product.price} TMT',
                                          style: TextStyle(
                                            fontSize: SizeConfig.screenWidth * 0.04,
                                            decoration: TextDecoration.lineThrough,
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Description
        Padding(
          padding: EdgeInsets.only(
            left: getProportionateScreenWidth(10),
            right: getProportionateScreenWidth(10),
          ),
          child: Text(
            widget.product.content == null || widget.product.content == '' ? '' : widget.product.content,
            style: const TextStyle(
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Product ecommerce details
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Expanded(child: ProductEcommerce(ecommerce: widget.product.ecommerce)),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: () {
                  if (_likeLoading == false && checkUserAuth()) {
                    _handleLike();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Icon(
                        _liked ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                        color: _likeLoading == true
                            ? const Color.fromARGB(15, 0, 0, 0)
                            : _liked
                                ? const Color(0xFFFF4848)
                                : const Color.fromARGB(50, 0, 0, 0),
                        size: SizeConfig.screenWidth * 0.1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
