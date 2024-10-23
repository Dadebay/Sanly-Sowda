// ignore_for_file: file_names

import 'dart:convert';

List<Help> helpFromJson(String str) => List<Help>.from(json.decode(str).map((x) => Help.fromJson(x)));

String helpToJson(List<Help> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Help {
  final int? id;
  final Content? title;
  final Content? content;
  final int? order;

  Help({
    this.id,
    this.title,
    this.content,
    this.order,
  });

  factory Help.fromJson(Map<String, dynamic> json) => Help(
        id: json['id'],
        title: json['title'] == null ? null : Content.fromJson(json['title']),
        content: json['content'] == null ? null : Content.fromJson(json['content']),
        order: json['order'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title?.toJson(),
        'content': content?.toJson(),
        'order': order,
      };
}

class Content {
  final String? ru;
  final String? tm;

  Content({
    this.ru,
    this.tm,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        ru: json['ru'],
        tm: json['tm'],
      );

  Map<String, dynamic> toJson() => {
        'ru': ru,
        'tm': tm,
      };
}
