// ignore_for_file: non_constant_identifier_names, file_names

import 'dart:convert';

List<Hunting> huntingFromJson(String str) => List<Hunting>.from(json.decode(str).map((x) => Hunting.fromJson(x)));

String huntingToJson(List<Hunting> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Hunting {
  final int? id;
  final String? title_tm;
  final String? title_ru;
  final String? content_tm;
  final String? content_ru;

  Hunting({
    this.id,
    this.title_tm,
    this.title_ru,
    this.content_tm,
    this.content_ru,
  });

  factory Hunting.fromJson(Map<String, dynamic> json) => Hunting(
        id: json['id'],
        title_tm: json['title_tm'],
        title_ru: json['title_ru'],
        content_tm: json['content_tm'],
        content_ru: json['content_ru'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title_tm': title_tm,
        'title_ru': title_ru,
        'content_tm': content_tm,
        'content_ru': content_ru,
      };
}
