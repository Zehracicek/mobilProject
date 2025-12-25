import 'package:flutter/material.dart';

class Category {
  final int? id;
  final String name;
  final Color color;
  final IconData icon;
  final DateTime createdAt;

  Category({
    this.id,
    required this.name,
    required this.color,
    required this.icon,
    required this.createdAt,
  });

  // JSON'dan Category oluşturma (API servisleri için)
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      color: Color(json['color']),
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // Category'yi JSON'a çevirme (API servisleri için)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color.value,
      'icon': icon.codePoint,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Database için Map'e çevirme (SQLite için)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color.value,
      'icon': icon.codePoint,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  // Map'ten Category oluşturma (SQLite için)
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      color: Color(map['color']),
      icon: IconData(map['icon'], fontFamily: 'MaterialIcons'),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  Category copyWith({
    int? id,
    String? name,
    Color? color,
    IconData? icon,
    DateTime? createdAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Varsayılan kategoriler
  static List<Category> getDefaultCategories() {
    return [
      Category(
        name: 'Genel',
        color: Colors.blue,
        icon: Icons.note,
        createdAt: DateTime.now(),
      ),
      Category(
        name: 'İş',
        color: Colors.orange,
        icon: Icons.work,
        createdAt: DateTime.now(),
      ),
      Category(
        name: 'Kişisel',
        color: Colors.green,
        icon: Icons.person,
        createdAt: DateTime.now(),
      ),
      Category(
        name: 'Alışveriş',
        color: Colors.purple,
        icon: Icons.shopping_cart,
        createdAt: DateTime.now(),
      ),
      Category(
        name: 'Seyahat',
        color: Colors.red,
        icon: Icons.flight,
        createdAt: DateTime.now(),
      ),
    ];
  }
}
