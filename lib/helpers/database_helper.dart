// DatabaseHelper: SQLite ile tam CRUD işlemleri için singleton sınıfı
// Kullanılan paketler: sqflite, path

import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note.dart';

class DatabaseHelper {
  // Singleton örneği
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  static const String _dbName = 'notes.db';
  static const int _dbVersion = 1;
  static const String _tableName = 'notes';

  // Veritabanı nesnesini asenkron olarak döner
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Veritabanını başlatır ve tabloyu oluşturur
  Future<Database> _initDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, _dbName);

      // openDatabase: eğer yoksa onCreate çalışır
      return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
    } catch (e) {
      // Hata yönetimi: hata loglanır ve tekrar fırlatılır
      print('Veritabanı başlatılırken hata: $e');
      rethrow;
    }
  }

  // notes tablosunu oluşturur
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  // Yeni not ekleme
  Future<int> insertNote(Note note) async {
    try {
      final db = await database;
      // toMap() -> {title, content, createdAt}
      return await db.insert(_tableName, note.toMap());
    } catch (e) {
      print('insertNote hatası: $e');
      throw Exception('Not eklenirken hata oluştu');
    }
  }

  // Tüm notları getir (tarihe göre sıralı: en yeni ilk)
  Future<List<Note>> getAllNotes() async {
    try {
      final db = await database;
      final maps = await db.query(_tableName, orderBy: 'createdAt DESC');
      return maps.map((m) => Note.fromMap(m)).toList();
    } catch (e) {
      print('getAllNotes hatası: $e');
      throw Exception('Notlar getirilirken hata oluştu');
    }
  }

  // ID'ye göre not getir
  Future<Note?> getNoteById(int id) async {
    try {
      final db = await database;
      final maps = await db.query(_tableName, where: 'id = ?', whereArgs: [id]);
      if (maps.isNotEmpty) return Note.fromMap(maps.first);
      return null;
    } catch (e) {
      print('getNoteById hatası: $e');
      throw Exception('Not getirilirken hata oluştu');
    }
  }

  // Notu güncelle
  Future<int> updateNote(Note note) async {
    try {
      final db = await database;
      return await db.update(
        _tableName,
        note.toMap(),
        where: 'id = ?',
        whereArgs: [note.id],
      );
    } catch (e) {
      print('updateNote hatası: $e');
      throw Exception('Not güncellenirken hata oluştu');
    }
  }

  // Notu sil
  Future<int> deleteNote(int id) async {
    try {
      final db = await database;
      return await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print('deleteNote hatası: $e');
      throw Exception('Not silinirken hata oluştu');
    }
  }

  // Veritabanını kapatma
  Future<void> close() async {
    try {
      final db = await database;
      await db.close();
      _database = null;
    } catch (e) {
      print('close hatası: $e');
      throw Exception('Veritabanı kapatılırken hata oluştu');
    }
  }
}

/*
Kısa kullanım örneği:

final db = DatabaseHelper.instance;

// Ekleme
await db.insertNote(Note(title: 'Başlık', content: 'İçerik'));

// Tümünü alma
final notes = await db.getAllNotes();

// Güncelleme
final n = notes.first.copyWith(title: 'Yeni başlık');
await db.updateNote(n);

// Silme
await db.deleteNote(n.id!);
*/
