class NoteModel {
  final int? id;
  final String userId;
  String title;
  String content;
  String category;
  DateTime createdAt;
  DateTime updatedAt;

  NoteModel({
    this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  // SQLite'dan veri çekerken
  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'],
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      category: map['category'] ?? 'Diğer',
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  // SQLite'a veri gönderirken
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'content': content,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Kategori rengini getir
  static String getCategoryColor(String category) {
    switch (category) {
      case 'Kişisel':
        return 'blue';
      case 'İş':
        return 'purple';
      case 'Hobi':
        return 'green';
      case 'Sağlık':
        return 'red';
      default:
        return 'gray';
    }
  }

  // Compatibility methods
  factory NoteModel.fromJson(Map<String, dynamic> json) =>
      NoteModel.fromMap(json);
  Map<String, dynamic> toJson() => toMap();

  NoteModel copyWith({
    int? id,
    String? userId,
    String? title,
    String? content,
    String? category,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NoteModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
