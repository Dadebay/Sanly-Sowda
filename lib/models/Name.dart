// ignore_for_file: file_names

class Name {
  Name({
    this.en,
    this.ru,
    this.tm,
  });

  final String? en;
  final String? ru;
  final String? tm;

  factory Name.fromJson(Map<String, dynamic> json) => Name(
        en: json['en'],
        ru: json['ru'],
        tm: json['tm'],
      );

  Map<String, dynamic> toJson() => {
        'en': en,
        'ru': ru,
        'tm': tm,
      };
}
