// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:convert';

import 'package:jummi/models/Category.dart';
import 'package:jummi/models/Location.dart';

List<Ecommerce> ecommerceFromJson(String str) => List<Ecommerce>.from(json.decode(str).map((x) => Ecommerce.fromJson(x)));

String ecommerceToJson(List<Ecommerce> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Ecommerce {
  Ecommerce({
    this.id,
    this.categories,
    this.location,
    this.name,
    this.description,
    this.urlA,
    this.urlB,
    this.urlC,
    this.urlD,
    this.urlE,
    this.phone,
    this.locationStr,
    this.avatar,
    this.avatarThumb,
    this.wallpaper,
    this.wallpaperThumb,
    this.delivery,
    this.delivery_price,
    this.verified,
    this.updatedAt,
    this.createdAt,
    this.user,
    this.followers_count,
    this.review_value,
    this.followed,
    this.rated,
    this.map_latitude,
    this.map_longitude,
  });

  final int? id;
  final List<Category>? categories;
  final Location? location;
  final String? name;
  final dynamic description;
  final String? urlA;
  final dynamic urlB;
  final dynamic urlC;
  final dynamic urlD;
  final dynamic urlE;
  final dynamic phone;
  final String? locationStr;
  final dynamic avatar;
  final dynamic avatarThumb;
  final dynamic wallpaper;
  final dynamic wallpaperThumb;
  final bool? delivery;
  final dynamic delivery_price;
  final bool? verified;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final int? user;
  final int? followers_count;
  final double? review_value;
  final bool? followed;
  final bool? rated;
  final String? map_latitude;
  final String? map_longitude;

  factory Ecommerce.fromJson(Map<String, dynamic> json) => Ecommerce(
        id: json['id'],
        categories: json['categories'] == null ? [] : List<Category>.from(json['categories']!.map((x) => Category.fromJson(x))),
        location: json['location'] == null ? null : Location.fromJson(json['location']),
        name: json['name'],
        description: json['description'],
        urlA: json['url_a'],
        urlB: json['url_b'],
        urlC: json['url_c'],
        urlD: json['url_d'],
        urlE: json['url_e'],
        phone: json['phone'],
        locationStr: json['location_str'],
        avatar: json['avatar'],
        avatarThumb: json['avatar_thumb'],
        wallpaper: json['wallpaper'],
        wallpaperThumb: json['wallpaper_thumb'],
        delivery: json['delivery'],
        delivery_price: json['delivery_price'],
        verified: json['verified'],
        updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at']),
        createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at']),
        user: json['user'],
        followers_count: json['followers_count'],
        review_value: json['review_value'],
        followed: json['followed'],
        rated: json['rated'],
        map_latitude: json['map_latitude'],
        map_longitude: json['map_longitude'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'categories': categories == null ? [] : List<dynamic>.from(categories!.map((x) => x.toJson())),
        'location': location?.toJson(),
        'name': name,
        'description': description,
        'url_a': urlA,
        'url_b': urlB,
        'url_c': urlC,
        'url_d': urlD,
        'url_e': urlE,
        'phone': phone,
        'location_str': locationStr,
        'avatar': avatar,
        'avatar_thumb': avatarThumb,
        'wallpaper': wallpaper,
        'wallpaper_thumb': wallpaperThumb,
        'delivery': delivery,
        'delivery_price': delivery_price,
        'verified': verified,
        'updated_at': updatedAt?.toIso8601String(),
        'created_at': createdAt?.toIso8601String(),
        'user': user,
        'followers_count': followers_count,
        'review_value': review_value,
        'followed': followed,
        'rated': rated,
        'map_latitude': map_latitude,
        'map_longitude': map_longitude,
      };
}
