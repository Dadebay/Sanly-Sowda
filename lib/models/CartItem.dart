// ignore_for_file: file_names

import 'package:jummi/models/Product.dart';

class CartItem {
  final int? id;
  final Product? product;
  final String? count;
  final String? cart;

  CartItem({
    this.id,
    this.product,
    this.count,
    this.cart,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: json['id'],
        product: json['product'] == null ? null : Product.fromJson(json['product']),
        count: json['count'],
        cart: json['cart'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'product': product?.toJson(),
        'count': count,
        'cart': cart,
      };
}
