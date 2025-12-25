// DatabaseHelper: SQLite ile tam CRUD işlemleri için singleton sınıfı
// Kullanılan paketler: sqflite, path
// Kişi 2 + Kişi 3 birleşik versiyon

import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note_model.dart';

class DatabaseHelper {
  // Singleton örneği - tek instance kullanılır
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  static const String _dbName = 'notes.db';
  static const int _dbVersion = 1;
  static const String _tableNotes = 'notes';
  static const String _tableUsers = 'users';

  /// Veritabanı nesnesini asenkron olarak döner
  /// Eğer database yoksa ilk çağrıda oluşturulur
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Veritabanını başlatır ve tabloları oluşturur
  Future<Database> _initDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, _dbName);

      // openDatabase: eğer yoksa onCreate çalışır
      return await openDatabase(
        path,
        version: _dbVersion,
        onCreate: _onCreate,
      );
    } catch (e) {
      // Hata yönetimi: hata loglanır ve tekrar fırlatılır
      throw Exception('Veritabanı başlatılırken hata: $e');
    }
  }

  /// notes ve users tablolarını oluşturur
  Future<void> _onCreate(Database db, int version) async {
    // Kullanıcılar tablosu (Kişi 1 için)
    await db.execute('''
      CREATE TABLE $_tableUsers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    // Notlar tablosu (Kişi 2 için)
    await db.execute('''
      CREATE TABLE $_tableNotes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        userId INTEGER NOT NULL,
        FOREIGN KEY (userId) REFERENCES $_tableUsers (id) ON DELETE CASCADE
      )
    ''');
  }

  // ============================================================================
  // NOT CRUD İŞLEMLERİ (Kişi 2 için)
  // ============================================================================

  /// Yeni not ekleme (Create)
  /// Başarılı olursa yeni notun ID'sini döner
  Future<int> insertNote(NoteModel note) async {
    try {
      final db = await database;
      // toMap() -> {title, content, createdAt, updatedAt, userId}
      return await db.insert(_tableNotes, note.toMap());
    } catch (e) {
      throw Exception('insertNote hatası: $e');
    }
  }

  /// Tüm notları getir (Read All)
  /// Tarihe göre sıralı: en yeni ilk (updatedAt DESC)
  Future<List<NoteModel>> getAllNotes() async {
    try {
      final db = await database;
      final maps = await db.query(_tableNotes, orderBy: 'updatedAt DESC');
      return maps.map((m) => NoteModel.fromMap(m)).toList();
    } catch (e) {
      throw Exception('getAllNotes hatası: $e');
    }
  }

  /// ID'ye göre not getir (Read by ID)
  /// Bulunamazsa null döner
  Future<NoteModel?> getNoteById(int id) async {
    try {
      final db = await database;
      final maps = await db.query(
        _tableNotes,
        where: 'id = ?',
        whereArgs: [id],
      );
      if (maps.isNotEmpty) return NoteModel.fromMap(maps.first);
      return null;
    } catch (e) {
      throw Exception('getNoteById hatası: $e');
    }
  }

  /// Belirli bir kullanıcının notlarını getir
  /// userId'ye göre filtreler ve tarihe göre sıralar
  Future<List<NoteModel>> getNotesByUserId(int userId) async {
    try {
      final db = await database;
      final result = await db.query(
        _tableNotes,
        where: 'userId = ?',
        whereArgs: [userId],
        orderBy: 'updatedAt DESC',
      );
      return result.map((json) => NoteModel.fromMap(json)).toList();
    } catch (e) {
      throw Exception('getNotesByUserId hatası: $e');
    }
  }

  /// Notu güncelle (Update)
  /// Güncellenen satır sayısını döner (genellikle 1)
  Future<int> updateNote(NoteModel note) async {
    try {
      final db = await database;
      return await db.update(
        _tableNotes,
        note.toMap(),
        where: 'id = ?',
        whereArgs: [note.id],
      );
    } catch (e) {
      throw Exception('updateNote hatası: $e');
    }
  }

  /// Notu sil (Delete)
  /// Silinen satır sayısını döner (genellikle 1)
  Future<int> deleteNote(int id) async {
    try {
      final db = await database;
      return await db.delete(
        _tableNotes,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('deleteNote hatası: $e');
    }
  }

  // ============================================================================
  // KULLANICI İŞLEMLERİ (Kişi 1 için yardımcı)
  // ============================================================================

  /// Kullanıcı ekleme (Register için)
  Future<int> createUser(Map<String, dynamic> user) async {
    try {
      final db = await database;
      return await db.insert(_tableUsers, user);
    } catch (e) {
      throw Exception('createUser hatası: $e');
    }
  }

  /// Email ile kullanıcı bulma (Login için)
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    try {
      final db = await database;
      final result = await db.query(
        _tableUsers,
        where: 'email = ?',
        whereArgs: [email],
      );
      if (result.isEmpty) return null;
      return result.first;
    } catch (e) {
      throw Exception('getUserByEmail hatası: $e');
    }
  }

  // ============================================================================
  // VERİTABANI YÖNETİMİ
  // ============================================================================

  /// Veritabanını kapatma
  /// Uygulama kapatılırken veya test sonunda çağrılabilir
  Future<void> close() async {
    try {
      final db = await database;
      await db.close();
      _database = null;
    } catch (e) {
      throw Exception('close hatası: $e');
    }
  }
}

/*
============================================================================
KULLANIM ÖRNEKLERİ (Kişi 2 için)
============================================================================

final db = DatabaseHelper.instance;

// 1. Yeni not ekleme
final yeniNot = NoteModel(
  title: 'Alışveriş Listesi',
  content: 'Süt, ekmek, yumurta',
  userId: 1,
);
final notId = await db.insertNote(yeniNot);
print('Eklenen not ID: $notId');

// 2. Tüm notları getirme
final tumNotlar = await db.getAllNotes();
print('Toplam ${tumNotlar.length} not var');

// 3. Belirli kullanıcının notlarını getirme
final kullaniciNotlari = await db.getNotesByUserId(1);

// 4. Not güncelleme (copyWith kullanarak)
final guncellenecekNot = tumNotlar.first.copyWith(
  title: 'Güncellenmiş Başlık',
  content: 'Güncellenmiş içerik',
  updatedAt: DateTime.now(),
);
await db.updateNote(guncellenecekNot);

// 5. Not silme
await db.deleteNote(notId);

============================================================================
*/

