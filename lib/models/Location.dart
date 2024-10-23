import 'dart:convert';

// ignore_for_file: file_names

import 'package:jummi/models/Name.dart';

List<Location> locationFromJson(String str) => List<Location>.from(json.decode(str).map((x) => Location.fromJson(x)));

String locationToJson(List<Location> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Location {
  Location({
    this.id,
    this.name,
    this.lft,
    this.rght,
    this.treeId,
    this.level,
    this.parent,
    this.children,
  });

  final int? id;
  final Name? name;
  final int? lft;
  final int? rght;
  final int? treeId;
  final int? level;
  final int? parent;
  final List<Location>? children;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        id: json['id'],
        name: json['name'] == null ? null : Name.fromJson(json['name']),
        lft: json['lft'],
        rght: json['rght'],
        treeId: json['tree_id'],
        level: json['level'],
        parent: json['parent'],
        children: json['children'] == null
            ? []
            : List<Location>.from(
                json['children']!.map((x) => Location.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name?.toJson(),
        'lft': lft,
        'rght': rght,
        'tree_id': treeId,
        'level': level,
        'parent': parent,
        'children': children == null ? [] : List<Location>.from(children!.map((x) => x.toJson())),
      };
}
