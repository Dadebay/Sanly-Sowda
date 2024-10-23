import 'dart:convert';

// ignore_for_file: file_names

import 'package:jummi/models/Product.dart';

List<Liked> likedFromJson(String str) => List<Liked>.from(json.decode(str).map((x) => Liked.fromJson(x)));

String likedToJson(List<Liked> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Liked {
  final String? id;
  final Product? product;
  final DateTime? createdAt;
  final int? user;

  Liked({
    this.id,
    this.product,
    this.createdAt,
    this.user,
  });

  factory Liked.fromJson(Map<String, dynamic> json) => Liked(
        id: json['id'],
        product: json['product'] == null ? null : Product.fromJson(json['product']),
        createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at']),
        user: json['user'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'product': product?.toJson(),
        'created_at': createdAt?.toIso8601String(),
        'user': user,
      };
}
