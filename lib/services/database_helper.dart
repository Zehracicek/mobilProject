// Database Helper - Services ekibi bu dosyayı geliştirecek
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note.dart';
import '../models/user.dart';
import '../models/category.dart';

class DatabaseHelper {
  static Database? _database;
  static const String _databaseName = 'notes_app.db';
  static const int _databaseVersion = 1;

  // Tablo isimleri
  static const String tableNotes = 'notes';
  static const String tableUsers = 'users';
  static const String tableCategories = 'categories';

  // Services ekibi bu metodları implement edecek

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Users tablosu
    await db.execute('''
      CREATE TABLE $tableUsers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        createdAt INTEGER NOT NULL,
        lastLoginAt INTEGER
      )
    ''');

    // Categories tablosu
    await db.execute('''
      CREATE TABLE $tableCategories(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        color INTEGER NOT NULL,
        icon INTEGER NOT NULL,
        createdAt INTEGER NOT NULL
      )
    ''');

    // Notes tablosu
    await db.execute('''
      CREATE TABLE $tableNotes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER,
        categoryId INTEGER,
        isArchived INTEGER DEFAULT 0,
        FOREIGN KEY (categoryId) REFERENCES $tableCategories (id)
      )
    ''');

    // Varsayılan kategorileri ekle
    await _insertDefaultCategories(db);
  }

  Future<void> _insertDefaultCategories(Database db) async {
    final defaultCategories = Category.getDefaultCategories();
    for (final category in defaultCategories) {
      await db.insert(tableCategories, category.toMap());
    }
  }

  // Notes CRUD operations
  Future<int> insertNote(Note note) async {
    final db = await database;
    return await db.insert(tableNotes, note.toMap());
  }

  Future<List<Note>> getAllNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableNotes,
      orderBy: 'createdAt DESC',
    );

    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }

  Future<Note?> getNoteById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableNotes,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Note>> getNotesByCategory(int categoryId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableNotes,
      where: 'categoryId = ? AND isArchived = 0',
      whereArgs: [categoryId],
      orderBy: 'createdAt DESC',
    );

    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }

  Future<List<Note>> searchNotes(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableNotes,
      where: '(title LIKE ? OR content LIKE ?) AND isArchived = 0',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'createdAt DESC',
    );

    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }

  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update(
      tableNotes,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete(
      tableNotes,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> archiveNote(int id) async {
    final db = await database;
    return await db.update(
      tableNotes,
      {'isArchived': 1, 'updatedAt': DateTime.now().millisecondsSinceEpoch},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Note>> getArchivedNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableNotes,
      where: 'isArchived = 1',
      orderBy: 'updatedAt DESC',
    );

    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }

  // Categories CRUD operations
  Future<List<Category>> getAllCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableCategories,
      orderBy: 'name ASC',
    );

    return List.generate(maps.length, (i) {
      return Category.fromMap(maps[i]);
    });
  }

  Future<int> insertCategory(Category category) async {
    final db = await database;
    return await db.insert(tableCategories, category.toMap());
  }

  Future<int> updateCategory(Category category) async {
    final db = await database;
    return await db.update(
      tableCategories,
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<int> deleteCategory(int id) async {
    final db = await database;
    // Önce bu kategorideki notları genel kategoriye taşı
    await db.update(
      tableNotes,
      {'categoryId': 1}, // Genel kategori ID'si
      where: 'categoryId = ?',
      whereArgs: [id],
    );

    // Sonra kategoriyi sil
    return await db.delete(
      tableCategories,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // User operations
  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert(tableUsers, user.toMap());
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableUsers,
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
      tableUsers,
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // İstatistikler için yardımcı metodlar
  Future<int> getTotalNotesCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM $tableNotes WHERE isArchived = 0');
    return result.first['count'] as int;
  }

  Future<int> getThisWeekNotesCount() async {
    final db = await database;
    final weekAgo = DateTime.now().subtract(const Duration(days: 7)).millisecondsSinceEpoch;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $tableNotes WHERE createdAt > ? AND isArchived = 0',
      [weekAgo]
    );
    return result.first['count'] as int;
  }

  Future<int> getArchivedNotesCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM $tableNotes WHERE isArchived = 1');
    return result.first['count'] as int;
  }

  // Veritabanını temizle (test için)
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete(tableNotes);
    await db.delete(tableUsers);
    await db.delete(tableCategories);
    await _insertDefaultCategories(db);
  }

  // Veritabanını kapat
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
