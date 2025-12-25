// Note Provider - CRUD ekibi bu dosyayı geliştirecek
import 'package:flutter/foundation.dart';
import '../models/note.dart';
import '../models/category.dart';

class NoteProvider with ChangeNotifier {
  List<Note> _notes = [];
  List<Category> _categories = [];
  bool _isLoading = false;
  String _searchQuery = '';
  int? _selectedCategoryId;

  // Getters
  List<Note> get notes => _filteredNotes;
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  int? get selectedCategoryId => _selectedCategoryId;

  List<Note> get _filteredNotes {
    List<Note> filtered = _notes;

    // Arama filtresi
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((note) =>
          note.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          note.content.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    // Kategori filtresi
    if (_selectedCategoryId != null) {
      filtered = filtered.where((note) => note.categoryId == _selectedCategoryId).toList();
    }

    // Arşivlenmemiş notları göster
    filtered = filtered.where((note) => !note.isArchived).toList();

    // Tarihe göre sırala (en yeni önce)
    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return filtered;
  }

  // CRUD ekibi bu metodları implement edecek
  Future<void> loadNotes() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: SQLite'tan notları yükle
      // TODO: API'den senkronize et

      // Demo veriler
      await Future.delayed(const Duration(milliseconds: 500));
      _notes = [
        Note(
          id: 1,
          title: 'İlk Notum',
          content: 'Bu bir örnek not içeriğidir. Uygulama geliştikçe burada gerçek notlar görünecek.',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          categoryId: 1,
        ),
        Note(
          id: 2,
          title: 'Alışveriş Listesi',
          content: 'Süt, Ekmek, Yumurta, Domates, Soğan',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          categoryId: 4,
        ),
        Note(
          id: 3,
          title: 'Toplantı Notları',
          content: 'Proje planlaması toplantısında alınan notlar...',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          categoryId: 2,
        ),
      ];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> loadCategories() async {
    try {
      // TODO: SQLite'tan kategorileri yükle
      _categories = Category.getDefaultCategories();
      // ID'leri manuel olarak atayalım
      for (int i = 0; i < _categories.length; i++) {
        _categories[i] = _categories[i].copyWith(id: i + 1);
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> addNote(Note note) async {
    try {
      // TODO: SQLite'a kaydet
      // TODO: API'ye gönder

      await Future.delayed(const Duration(milliseconds: 300));

      final newNote = note.copyWith(
        id: DateTime.now().millisecondsSinceEpoch, // Geçici ID
        createdAt: DateTime.now(),
      );

      _notes.insert(0, newNote);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateNote(Note updatedNote) async {
    try {
      // TODO: SQLite'da güncelle
      // TODO: API'ye gönder

      await Future.delayed(const Duration(milliseconds: 300));

      final index = _notes.indexWhere((note) => note.id == updatedNote.id);
      if (index != -1) {
        _notes[index] = updatedNote.copyWith(updatedAt: DateTime.now());
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteNote(int noteId) async {
    try {
      // TODO: SQLite'dan sil
      // TODO: API'ye delete isteği gönder

      await Future.delayed(const Duration(milliseconds: 300));

      _notes.removeWhere((note) => note.id == noteId);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> archiveNote(int noteId) async {
    try {
      // TODO: SQLite'da arşiv durumunu güncelle

      final index = _notes.indexWhere((note) => note.id == noteId);
      if (index != -1) {
        _notes[index] = _notes[index].copyWith(
          isArchived: true,
          updatedAt: DateTime.now(),
        );
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Note? getNoteById(int id) {
    try {
      return _notes.firstWhere((note) => note.id == id);
    } catch (e) {
      return null;
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategoryFilter(int? categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCategoryId = null;
    notifyListeners();
  }

  // İstatistikler için yardımcı metodlar
  int get totalNotesCount => _notes.where((note) => !note.isArchived).length;
  int get archivedNotesCount => _notes.where((note) => note.isArchived).length;
  int get thisWeekNotesCount {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return _notes.where((note) =>
        !note.isArchived && note.createdAt.isAfter(weekAgo)).length;
  }
}
