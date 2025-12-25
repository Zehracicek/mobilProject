// Note model sınıfı
// Özellikler: id, title, content, createdAt
// toMap, fromMap ve copyWith metodları içerir

class Note {
  final int? id;
  final String title;
  final String? content;
  final DateTime createdAt;

  // Constructor; createdAt verilmezse mevcut zaman atanır
  Note({this.id, required this.title, this.content, DateTime? createdAt})
    : createdAt = createdAt ?? DateTime.now();

  // Veritabanına yazmak için Map'e çevirir
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(), // ISO formatında sakla
    };
    if (id != null) map['id'] = id;
    return map;
  }

  // Veritabanından okunan Map'ten Note nesnesi oluşturur
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int?,
      title: map['title'] as String? ?? '',
      content: map['content'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  // copyWith: var olan nesneden bazı alanları değiştirerek yeni nesne oluşturma
  Note copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? createdAt,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() =>
      'Note{id: $id, title: $title, content: $content, createdAt: $createdAt}';
}
