class Note {
  final int? id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int? categoryId;
  final bool isArchived;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    this.categoryId,
    this.isArchived = false,
  });

  // JSON'dan Note oluşturma (API servisleri için)
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      categoryId: json['categoryId'],
      isArchived: json['isArchived'] ?? false,
    );
  }

  // Note'u JSON'a çevirme (API servisleri için)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'categoryId': categoryId,
      'isArchived': isArchived,
    };
  }

  // Database için Map'e çevirme (SQLite için)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'categoryId': categoryId,
      'isArchived': isArchived ? 1 : 0,
    };
  }

  // Map'ten Note oluşturma (SQLite için)
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'])
          : null,
      categoryId: map['categoryId'],
      isArchived: map['isArchived'] == 1,
    );
  }

  // Note kopyalama (güncelleme için)
  Note copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? categoryId,
    bool? isArchived,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      categoryId: categoryId ?? this.categoryId,
      isArchived: isArchived ?? this.isArchived,
    );
  }
}
