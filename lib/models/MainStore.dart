import 'dart:convert';

// ignore_for_file: file_names

import 'package:jummi/models/Ecommerce.dart';

List<MainStore> mainStoreFromJson(String str) => List<MainStore>.from(json.decode(str).map((x) => MainStore.fromJson(x)));

String mainStoreToJson(List<MainStore> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MainStore {
  final int? id;
  final Ecommerce? ecommerce;
  final String? title;
  final String? subtitle;
  final String? image;
  final int? order;

  MainStore({
    this.id,
    this.ecommerce,
    this.title,
    this.subtitle,
    this.image,
    this.order,
  });

  factory MainStore.fromJson(Map<String, dynamic> json) => MainStore(
        id: json['id'],
        ecommerce: json['store'] == null ? null : Ecommerce.fromJson(json['store']),
        title: json['title'],
        subtitle: json['subtitle'],
        image: json['image'],
        order: json['order'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'store': ecommerce?.toJson(),
        'title': title,
        'subtitle': subtitle,
        'image': image,
        'order': order,
      };
}
