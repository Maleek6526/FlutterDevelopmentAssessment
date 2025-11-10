import 'dart:convert';

class Item {
  final String id;
  final String title;
  final String? note;

  const Item({required this.id, required this.title, this.note});

  Item copyWith({String? id, String? title, String? note}) {
    return Item(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
    );
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as String,
      title: json['title'] as String,
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'note': note,
      };

  static Item fromJsonString(String value) => Item.fromJson(jsonDecode(value) as Map<String, dynamic>);
  static String toJsonString(Item item) => jsonEncode(item.toJson());
}