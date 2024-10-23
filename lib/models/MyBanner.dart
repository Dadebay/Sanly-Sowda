import 'dart:convert';
// ignore_for_file: file_names

List<MyBanner> bannerFromJson(String str) => List<MyBanner>.from(json.decode(str).map((x) => MyBanner.fromJson(x)));

String bannerToJson(List<MyBanner> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MyBanner {
  MyBanner({
    required this.image,
    this.id,
    this.name,
    this.content,
    this.imageThumb,
    this.url,
  });

  final int? id;
  final String? name;
  final String? content;
  final String image;
  final String? imageThumb;
  final dynamic url;

  factory MyBanner.fromJson(Map<String, dynamic> json) => MyBanner(
        id: json['id'],
        name: json['name'],
        content: json['content'],
        image: json['image'],
        imageThumb: json['image_thumb'],
        url: json['url'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'content': content,
        'image': image,
        'image_thumb': imageThumb,
        'url': url,
      };
}
