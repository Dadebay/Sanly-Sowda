// ignore_for_file: file_names

import 'dart:convert';

SearchText searchTextFromJson(String str) => SearchText.fromJson(json.decode(str));

String searchTextToJson(SearchText data) => json.encode(data.toJson());

class SearchText {
  final String? id;
  final String? text;
  final String? createdAt;

  SearchText({
    this.id,
    this.text,
    this.createdAt,
  });

  factory SearchText.fromJson(Map<String, dynamic> json) => SearchText(
        id: json['id'],
        text: json['text'],
        createdAt: json['created_at'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'created_at': createdAt,
      };
}
