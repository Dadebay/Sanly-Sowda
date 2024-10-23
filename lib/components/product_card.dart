import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jummi/constants.dart';
import 'package:jummi/controllers/main_controller.dart';
import 'package:jummi/models/Product.dart';
import 'package:jummi/screens/product_details/product_details_screen.dart';
import 'package:jummi/size_config.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({required this.product, super.key});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final MainController mainC = Get.put(MainController());

    return Container(
      decoration: BoxDecoration(
        color: product.status == 'pending'
            ? Colors.amber.shade100
            : product.status == 'failed'
                ? Colors.red.shade100
                : Colors.white,
        borderRadius: BorderRadius.circular(7),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: () => Get.to(
          Obx(
            () => mainC.user.value.userEcommerce != null && mainC.user.value.userEcommerce!.id == product.ecommerce!.id
                ? DetailsScreen(
                    product_id: product.id!,
                    editable: true,
                  )
                : DetailsScreen(
                    product_id: product.id!,
                    editable: false,
                  ),
          ),
        ),
        child: Column(
          children: [
            Container(
              height: SizeConfig.screenHeight * 0.2,
              width: double.infinity,
              decoration: product.images!.isNotEmpty
                  ? BoxDecoration(
                      color: kSecondaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          media_host + product.images![0].srcThumb.toString(),
                        ),
                        fit: BoxFit.cover,
                      ),
                    )
                  : BoxDecoration(
                      color: kSecondaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/noimage-product.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
              child: Stack(
                children: [
                  product.discountPercent != 0 && product.discountPercent != null
                      ? Positioned(
                          bottom: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              product.discountPercent == -1 ? '<1%' : '${product.discountPercent}%',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  product.ecommerce!.delivery == true
                      ? const Positioned(
                          right: 0,
                          top: 0,
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: CircleAvatar(
                              radius: 13,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.local_shipping,
                                size: 15,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Text(
              product.name.toString(),
              style: TextStyle(
                color: Colors.black,
                fontSize: SizeConfig.screenWidth * 0.04,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
            const SizedBox(height: 2),
            Column(
              children: [
                Text(
                  product.price != null && double.parse(product.price!) > 0
                      ? product.discountPrice != null && double.parse(product.discountPrice) > 0
                          ? (product.discountPrice + ' TMT')
                          : ('${product.price!} TMT')
                      : '',
                  style: TextStyle(
                    fontSize: SizeConfig.screenWidth * 0.035,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor,
                  ),
                ),
                product.discountPrice != null && double.parse(product.discountPrice) > 0 && double.parse(product.price!) > 0
                    ? Text(
                        '${product.price} TMT',
                        style: TextStyle(
                          fontSize: SizeConfig.screenWidth * 0.03,
                          fontWeight: FontWeight.w600,
                          color: Colors.black26,
                          decoration: TextDecoration.lineThrough,
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
