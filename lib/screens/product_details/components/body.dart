import 'package:flutter/material.dart';
import 'package:jummi/screens/product_details/components/product_description.dart';
import 'package:jummi/screens/product_details/components/product_images.dart';

import '../../../models/Product.dart';

class Body extends StatelessWidget {
  const Body({required this.product, super.key});
  final Product? product;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          product!.images!.isEmpty ? const SizedBox() : const SizedBox(height: 10),
          product!.images!.isEmpty ? const SizedBox() : ProductImages(product: product!),
          ProductDescription(
            product: product!,
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
