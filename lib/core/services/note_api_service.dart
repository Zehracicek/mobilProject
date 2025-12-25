import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/note_model.dart';
import 'http_service.dart';
import 'local_storage_service.dart';
import 'database_helper.dart';

class NoteApiService {
  static final NoteApiService instance = NoteApiService._init();

  final HttpService _httpService = HttpService.instance;
  final LocalStorageService _localStorage = LocalStorageService.instance;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  NoteApiService._init();

  String? _getToken() {
    return _localStorage.getString(LocalStorageService.keyAuthToken);
  }

  int? _getCurrentUserId() {
    return _localStorage.getInt(LocalStorageService.keyUserId);
  }

  Future<List<NoteModel>> fetchNotes() async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) throw Exception('Kullanıcı oturumu bulunamadı');

      if (kIsWeb) {
        final allNotes = await _localStorage.getObjectList('web_notes');
        final userNotes = allNotes
            .where((n) => n['userId'] == userId)
            .map((e) => NoteModel.fromJson(e))
            .toList();
            
        userNotes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return userNotes;
      }

      return await _dbHelper.getNotesByUserId(userId);
    } catch (e) {
      throw Exception('Notlar getirilemedi: $e');
    }
  }

  Future<NoteModel> createNote(NoteModel note) async {
    try {
      if (kIsWeb) {
        final allNotes = await _localStorage.getObjectList('web_notes');
        
        final newId = DateTime.now().millisecondsSinceEpoch;
        final newNote = note.copyWith(id: newId).toJson();
        
        allNotes.add(newNote);
        await _localStorage.setObjectList('web_notes', allNotes);
        
        return NoteModel.fromJson(newNote);
      }

      final id = await _dbHelper.insertNote(note);
      return note.copyWith(id: id);
    } catch (e) {
      throw Exception('Not oluşturulamadı: $e');
    }
  }

  Future<NoteModel> updateNote(NoteModel note) async {
    try {
      if (kIsWeb) {
        final allNotes = await _localStorage.getObjectList('web_notes');
        final index = allNotes.indexWhere((n) => n['id'] == note.id);
        
        if (index != -1) {
          allNotes[index] = note.toJson();
          await _localStorage.setObjectList('web_notes', allNotes);
        }
        return note;
      }

      await _dbHelper.updateNote(note);
      return note;
    } catch (e) {
      throw Exception('Not güncellenemedi: $e');
    }
  }

  Future<void> deleteNote(int noteId) async {
    try {
      if (kIsWeb) {
        final allNotes = await _localStorage.getObjectList('web_notes');
        allNotes.removeWhere((n) => n['id'] == noteId);
        await _localStorage.setObjectList('web_notes', allNotes);
        return;
      }

      await _dbHelper.deleteNote(noteId);
    } catch (e) {
      throw Exception('Not silinemedi: $e');
    }
  }

  Future<NoteModel> fetchNoteById(int noteId) async {
    try {
      if (kIsWeb) {
         final allNotes = await _localStorage.getObjectList('web_notes');
         final noteMap = allNotes.firstWhere(
           (n) => n['id'] == noteId,
           orElse: () => {},
         );
         
         if (noteMap.isEmpty) throw Exception('Not bulunamadı (Web)');
         return NoteModel.fromJson(noteMap);
      }

      final note = await _dbHelper.getNoteById(noteId);
      if (note == null) throw Exception('Not bulunamadı');
      return note;
    } catch (e) {
      throw Exception('Not getirilemedi: $e');
    }
  }

  Future<void> syncNotes() async {
    return;
  }
}
