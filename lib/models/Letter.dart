import 'dart:convert';
// ignore_for_file: file_names

List<Letter> letterFromJson(String str) => List<Letter>.from(json.decode(str).map((x) => Letter.fromJson(x)));

String letterToJson(List<Letter> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Letter {
  final int? id;
  final String? text;
  final bool? read;
  final String? answer;
  final DateTime? createdAt;
  final int? user;

  Letter({
    this.id,
    this.text,
    this.read,
    this.answer,
    this.createdAt,
    this.user,
  });

  factory Letter.fromJson(Map<String, dynamic> json) => Letter(
        id: json['id'],
        text: json['text'],
        read: json['read'],
        answer: json['answer'],
        createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at']),
        user: json['user'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'read': read,
        'answer': answer,
        'created_at': createdAt?.toIso8601String(),
        'user': user,
      };
}
