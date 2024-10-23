// ignore_for_file: file_names

import 'dart:convert';

List<HomeStore> homeStoreFromJson(String str) => List<HomeStore>.from(json.decode(str).map((x) => HomeStore.fromJson(x)));

String homeStoreToJson(List<HomeStore> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HomeStore {
  final int? store;
  final String? title;
  final String? subtitle;
  final String? image;

  HomeStore({
    this.store,
    this.title,
    this.subtitle,
    this.image,
  });

  factory HomeStore.fromJson(Map<String, dynamic> json) => HomeStore(
        store: json['store'],
        title: json['title'],
        subtitle: json['subtitle'],
        image: json['image'],
      );

  Map<String, dynamic> toJson() => {
        'store': store,
        'title': title,
        'subtitle': subtitle,
        'image': image,
      };
}
