// ignore_for_file: file_names

import 'dart:convert';

import 'package:jummi/models/Category.dart';
import 'package:jummi/models/Ecommerce.dart';
import 'package:jummi/models/Image.dart';

List<Product> productFromJson(String str) => List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  Product({
    this.id,
    this.category,
    this.images,
    this.liked,
    this.name,
    this.content,
    this.price,
    this.discountPrice,
    this.discountPercent,
    this.status,
    this.ecommerce,
    this.tags,
    this.likesCount,
    this.viewsCount,
  });

  final int? id;
  final Category? category;
  final List<Image>? images;
  final bool? liked;
  final String? name;
  final dynamic content;
  final String? price;
  final dynamic discountPrice;
  final dynamic discountPercent;
  final String? status;
  final Ecommerce? ecommerce;
  final List<dynamic>? tags;
  final int? likesCount;
  final int? viewsCount;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        category: json['category'] == null ? null : Category.fromJson(json['category']),
        images: json['images'] == null ? [] : List<Image>.from(json['images']!.map((x) => Image.fromJson(x))),
        liked: json['liked'],
        name: json['name'],
        content: json['content'],
        price: json['price'],
        discountPrice: json['discount_price'],
        discountPercent: json['discount_percent'],
        status: json['status'],
        ecommerce: json['ecommerce'] == null ? null : Ecommerce.fromJson(json['ecommerce']),
        tags: json['tags'] == null ? [] : List<dynamic>.from(json['tags']!.map((x) => x)),
        likesCount: json['likes_count'],
        viewsCount: json['views_count'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category?.toJson(),
        'images': images == null ? [] : List<dynamic>.from(images!.map((x) => x.toJson())),
        'liked': liked,
        'name': name,
        'content': content,
        'price': price,
        'discount_price': discountPrice,
        'discount_percent': discountPercent,
        'status': status,
        'ecommerce': ecommerce?.toJson(),
        'tags': tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
        'likes_count': likesCount,
        'views_count': viewsCount,
      };
}
