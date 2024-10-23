// ignore_for_file: file_names

import 'dart:convert';

List<Contact> contactFromJson(String str) => List<Contact>.from(json.decode(str).map((x) => Contact.fromJson(x)));

String contactToJson(List<Contact> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Contact {
  final int? id;
  final Text? text;
  final Text? value;
  final int? order;

  Contact({
    this.id,
    this.text,
    this.value,
    this.order,
  });

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        id: json['id'],
        text: json['text'] == null ? null : Text.fromJson(json['text']),
        value: json['value'] == null ? null : Text.fromJson(json['value']),
        order: json['order'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text?.toJson(),
        'value': value?.toJson(),
        'order': order,
      };
}

class Text {
  final String? ru;
  final String? tm;

  Text({
    this.ru,
    this.tm,
  });

  factory Text.fromJson(Map<String, dynamic> json) => Text(
        ru: json['ru'],
        tm: json['tm'],
      );

  Map<String, dynamic> toJson() => {
        'ru': ru,
        'tm': tm,
      };
}
