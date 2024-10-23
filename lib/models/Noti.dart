// ignore_for_file: file_names

import 'dart:convert';

List<Noti> notiFromJson(String str) => List<Noti>.from(json.decode(str).map((x) => Noti.fromJson(x)));

String notiToJson(List<Noti> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Noti {
  final int? id;
  final String? title;
  final String? content;
  final String? slug;
  final String? type;
  final DateTime? createdAt;

  Noti({
    this.id,
    this.title,
    this.content,
    this.slug,
    this.type,
    this.createdAt,
  });

  factory Noti.fromJson(Map<String, dynamic> json) => Noti(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        slug: json['slug'],
        type: json['type'],
        createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'slug': slug,
        'type': type,
        'created_at': createdAt?.toIso8601String(),
      };
}
