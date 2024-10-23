// To parse this JSON data, do
//
//     final image = imageFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

List<Image> imageFromJson(String str) => List<Image>.from(json.decode(str).map((x) => Image.fromJson(x)));

String imageToJson(List<Image> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Image {
  Image({
    this.id,
    this.src,
    this.srcThumb,
    this.product,
  });

  final String? id;
  final String? src;
  final String? srcThumb;
  final int? product;

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        id: json['id'],
        src: json['src'],
        srcThumb: json['src_thumb'],
        product: json['product'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'src': src,
        'src_thumb': srcThumb,
        'product': product,
      };
}
