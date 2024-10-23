// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:convert';

import 'package:jummi/models/Name.dart';

List<Category> categoryFromJson(String str) => List<Category>.from(json.decode(str).map((x) => Category.fromJson(x)));

String categoryToJson(List<Category> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Category {
  Category({
    this.id,
    this.name,
    this.image,
    this.lft,
    this.rght,
    this.treeId,
    this.level,
    this.parent,
    this.children,
    this.stores_count,
    this.products_count,
    this.storesSum,
    this.productsSum,
  });

  final int? id;
  final Name? name;
  final dynamic image;
  final int? lft;
  final int? rght;
  final int? treeId;
  final int? level;
  final int? parent;
  final List<Category>? children;
  final int? stores_count;
  final int? products_count;
  final int? storesSum;
  final int? productsSum;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'],
        name: json['name'] == null ? null : Name.fromJson(json['name']),
        image: json['image'],
        lft: json['lft'],
        rght: json['rght'],
        treeId: json['tree_id'],
        level: json['level'],
        parent: json['parent'],
        children: json['children'] == null ? [] : List<Category>.from(json['children']!.map((x) => Category.fromJson(x))),
        stores_count: json['stores_count'], // Dine ozune degishli magazinlaryn jemi
        products_count: json['products_count'],
        storesSum: json['stores_sum'], // Ozunin we subcategoriyalarynyn ichindaki magazinlaryn jemi
        productsSum: json['productsSum'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name?.toJson(),
        'image': image,
        'lft': lft,
        'rght': rght,
        'tree_id': treeId,
        'level': level,
        'parent': parent,
        'children': children == null ? [] : List<Category>.from(children!.map((x) => x.toJson())),
        'stores_count': stores_count,
        'products_count': products_count,
        'storesSum': storesSum,
        'productsSum': productsSum,
      };
}
