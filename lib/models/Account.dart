// To parse this JSON data, do
//
//     final account = accountFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

import 'package:jummi/models/Ecommerce.dart';
import 'package:jummi/models/Location.dart';
import 'package:jummi/models/SearchText.dart';

List<Account> accountFromJson(String str) => List<Account>.from(json.decode(str).map((x) => Account.fromJson(x)));

String accountToJson(List<Account> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Account {
  final int? id;
  final String? phone;
  final dynamic email;
  final String? name;
  final dynamic avatar;
  final dynamic avatarThumb;
  final dynamic wallpaper;
  final dynamic wallpaperThumb;
  final dynamic bio;
  final Location? location;
  final dynamic locationStr;
  final dynamic web;
  final int? verificationLevel;
  final dynamic refCode;
  final dynamic usedRefCode;
  final Ecommerce? lovelyEcommerce;
  final Ecommerce? userEcommerce;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic loginIp;
  final dynamic lastLoginIp;
  final dynamic lastLoginDate;
  final bool? isDeleted;
  final int? followersCount;
  final int? followingsCount;
  final List<SearchText>? searchTexts;

  Account({
    this.id,
    this.phone,
    this.email,
    this.name,
    this.avatar,
    this.avatarThumb,
    this.wallpaper,
    this.wallpaperThumb,
    this.bio,
    this.location,
    this.locationStr,
    this.web,
    this.verificationLevel,
    this.refCode,
    this.usedRefCode,
    this.lovelyEcommerce,
    this.userEcommerce,
    this.createdAt,
    this.updatedAt,
    this.loginIp,
    this.lastLoginIp,
    this.lastLoginDate,
    this.isDeleted,
    this.followersCount,
    this.followingsCount,
    this.searchTexts,
  });

  factory Account.fromJson(Map<String, dynamic> json) => Account(
        id: json['id'],
        phone: json['phone'],
        email: json['email'],
        name: json['name'],
        avatar: json['avatar'],
        avatarThumb: json['avatar_thumb'],
        wallpaper: json['wallpaper'],
        wallpaperThumb: json['wallpaper_thumb'],
        bio: json['bio'],
        location: json['location'] == null ? null : Location.fromJson(json['location']),
        locationStr: json['location_str'],
        web: json['web'],
        verificationLevel: json['verification_level'],
        refCode: json['ref_code'],
        usedRefCode: json['used_ref_code'],
        lovelyEcommerce: json['lovely_ecommerce'] == null ? null : Ecommerce.fromJson(json['lovely_ecommerce']),
        userEcommerce: json['user_ecommerce'] == null ? null : Ecommerce.fromJson(json['user_ecommerce']),
        createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at']),
        updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at']),
        loginIp: json['login_ip'],
        lastLoginIp: json['last_login_ip'],
        lastLoginDate: json['last_login_date'],
        isDeleted: json['is_deleted'],
        followersCount: json['followers_count'],
        followingsCount: json['followings_count'],
        searchTexts: json['search_texts'] == null ? [] : List<SearchText>.from(json['search_texts']!.map((x) => SearchText.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'phone': phone,
        'email': email,
        'name': name,
        'avatar': avatar,
        'avatar_thumb': avatarThumb,
        'wallpaper': wallpaper,
        'wallpaper_thumb': wallpaperThumb,
        'bio': bio,
        'location': location,
        'location_str': locationStr,
        'web': web,
        'verification_level': verificationLevel,
        'ref_code': refCode,
        'used_ref_code': usedRefCode,
        'lovely_ecommerce': lovelyEcommerce,
        'user_ecommerce': userEcommerce,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'login_ip': loginIp,
        'last_login_ip': lastLoginIp,
        'last_login_date': lastLoginDate,
        'is_deleted': isDeleted,
        'followers_count': followersCount,
        'followings_count': followingsCount,
        'search_texts': searchTexts == null ? [] : List<dynamic>.from(searchTexts!.map((x) => x.toJson())),
      };
}
