import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jummi/constants.dart';
import 'package:jummi/models/Ecommerce.dart';
import 'package:jummi/screens/ecommerce/ecommerce_screen.dart';
import 'package:jummi/size_config.dart';

class ProductEcommerce extends StatelessWidget {
  const ProductEcommerce({required this.ecommerce, super.key});
  final Ecommerce? ecommerce;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(
        EcommerceScreen(ecommerce_id: ecommerce!.id!),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset.zero,
                  ),
                ],
              ),
              width: 40,
              height: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: ecommerce!.avatarThumb == null
                    ? Image.asset('assets/images/noimage-profile.png')
                    : Image.network(
                        media_host + ecommerce!.avatarThumb,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(width: 7),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ecommerce!.name!.length > 20 ? ecommerce!.name!.substring(0, 20) + (ecommerce!.name!.length > 10 ? '...' : '') : ecommerce!.name.toString(),
                  maxLines: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: SizeConfig.screenWidth * 0.05,
                    color: Colors.black,
                  ),
                ),
                Text(
                  ecommerce!.phone.toString(),
                  style: TextStyle(
                    fontSize: SizeConfig.screenWidth * 0.04,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
