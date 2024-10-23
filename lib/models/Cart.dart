// ignore_for_file: file_names

import 'dart:convert';

import 'package:jummi/models/Account.dart';
import 'package:jummi/models/CartItem.dart';
import 'package:jummi/models/Ecommerce.dart';

List<Cart> cartsFromJson(String str) => List<Cart>.from(json.decode(str).map((x) => Cart.fromJson(x)));

String cartToJson(List<Cart> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Cart {
  final int? id;
  final List<CartItem>? items;
  final Ecommerce? vendor;
  final Account? customer;
  final String? note;
  final String? address;
  final String? total;
  final String? status;
  final bool? viewed;
  final DateTime? createdAt;

  Cart({
    this.id,
    this.items,
    this.vendor,
    this.customer,
    this.note,
    this.address,
    this.total,
    this.status,
    this.viewed,
    this.createdAt,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        id: json['id'],
        items: json['items'] == null ? [] : List<CartItem>.from(json['items']!.map((x) => CartItem.fromJson(x))),
        vendor: json['vendor'] == null ? null : Ecommerce.fromJson(json['vendor']),
        customer: json['customer'] == null ? null : Account.fromJson(json['customer']),
        note: json['note'],
        address: json['address'],
        total: json['total'],
        status: json['status'],
        viewed: json['viewed'],
        createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'items': items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
        'vendor': vendor?.toJson(),
        'customer': customer?.toJson(),
        'note': note,
        'address': address,
        'total': total,
        'status': status,
        'viewed': viewed,
        'created_at': createdAt?.toIso8601String(),
      };
}
