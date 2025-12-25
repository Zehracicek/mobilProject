// Note model sınıfı (Kişi 2 + Kişi 3 birleşik versiyon)
// Özellikler: id, title, content, createdAt, updatedAt, userId
// toMap, fromMap, toJson, fromJson ve copyWith metodları içerir
// Hem SQLite hem de API için kullanılabilir

class NoteModel {
  final int? id; // Veritabanı ID'si (null ise yeni not)
  final String title; // Not başlığı
  final String? content; // Not içeriği (opsiyonel)
  final DateTime createdAt; // Oluşturulma tarihi
  final DateTime updatedAt; // Güncellenme tarihi
  final int userId; // Hangi kullanıcıya ait olduğu

  // Constructor; createdAt ve updatedAt verilmezse mevcut zaman atanır
  NoteModel({
    this.id,
    required this.title,
    this.content,
    DateTime? createdAt,
    DateTime? updatedAt,
    required this.userId,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Veritabanına yazmak için Map'e çevirir (SQLite için)
  /// Tarihler ISO 8601 formatında saklanır (daha okunabilir)
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(), // ISO formatında sakla
      'updatedAt': updatedAt.toIso8601String(), // ISO formatında sakla
      'userId': userId,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  /// Veritabanından okunan Map'ten NoteModel nesnesi oluşturur (SQLite için)
  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'] as int?,
      title: map['title'] as String? ?? '',
      content: map['content'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      userId: map['userId'] as int? ?? 0,
    );
  }

  /// JSON'dan NoteModel oluştur (API response için)
  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] as int?,
      title: json['title'] as String,
      content: json['content'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      userId: json['userId'] as int,
    );
  }

  /// NoteModel'i JSON'a dönüştür (API request için)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'userId': userId,
    };
  }

  /// copyWith: var olan nesneden bazı alanları değiştirerek yeni nesne oluşturma
  /// güncelleme işlemlerinde çok kullanışlı
  NoteModel copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? userId,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
    );
  }

  /// toString metodu: debug ve loglama için kullanışlı
  @override
  String toString() =>
      'NoteModel{id: $id, title: $title, content: $content, createdAt: $createdAt, updatedAt: $updatedAt, userId: $userId}';
}

/*
Kısa kullanım örneği (Kişi 2 için):

final db = DatabaseHelper.instance;

// Yeni not ekleme
final note = NoteModel(
  title: 'Başlık',
  content: 'İçerik',
  userId: 1,
);
await db.insertNote(note);

// Tümünü alma
final notes = await db.getAllNotes();

// Güncelleme (copyWith kullanarak)
final updatedNote = notes.first.copyWith(
  title: 'Yeni başlık',
  updatedAt: DateTime.now(),
);
await db.updateNote(updatedNote);

// Silme
await db.deleteNote(updatedNote.id!);
*/

