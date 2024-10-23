// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:convert';

List<Policy> policyFromJson(String str) => List<Policy>.from(json.decode(str).map((x) => Policy.fromJson(x)));

String policyToJson(List<Policy> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Policy {
  Policy({
    this.id,
    this.title_tm,
    this.title_ru,
    this.content_tm,
    this.content_ru,
  });

  final int? id;
  final String? title_tm;
  final String? title_ru;
  final String? content_tm;
  final String? content_ru;

  factory Policy.fromJson(Map<String, dynamic> json) => Policy(
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
