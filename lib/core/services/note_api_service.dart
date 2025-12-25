import '../models/note_model.dart';
import 'http_service.dart';
import 'local_storage_service.dart';

/// Not API servisi
/// HTTP servisini kullanarak not CRUD işlemlerini gerçekleştirir
class NoteApiService {
  // Singleton instance
  static final NoteApiService instance = NoteApiService._init();

  final HttpService _httpService = HttpService.instance;
  final LocalStorageService _localStorage = LocalStorageService.instance;

  NoteApiService._init();

  /// Auth token'ı al
  String? _getToken() {
    return _localStorage.getString(LocalStorageService.keyAuthToken);
  }

  /// Tüm notları API'den getir
  /// TODO: Kişi 3 - Gerçek API endpoint'i ile test edin
  Future<List<NoteModel>> fetchNotes() async {
    try {
      final response = await _httpService.get(
        '/notes',
        token: _getToken(),
      );

      final notesJson = response['data'] as List;
      return notesJson
          .map((json) => NoteModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Notlar getirilemedi: $e');
    }
  }

  /// Yeni not oluştur (API'ye gönder)
  /// TODO: Kişi 3 - Gerçek API endpoint'i ile test edin
  Future<NoteModel> createNote(NoteModel note) async {
    try {
      final response = await _httpService.post(
        '/notes',
        body: note.toJson(),
        token: _getToken(),
      );

      return NoteModel.fromJson(response['data'] as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Not oluşturulamadı: $e');
    }
  }

  /// Notu güncelle (API'de)
  /// TODO: Kişi 3 - Gerçek API endpoint'i ile test edin
  Future<NoteModel> updateNote(NoteModel note) async {
    try {
      final response = await _httpService.put(
        '/notes/${note.id}',
        body: note.toJson(),
        token: _getToken(),
      );

      return NoteModel.fromJson(response['data'] as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Not güncellenemedi: $e');
    }
  }

  /// Notu sil (API'den)
  /// TODO: Kişi 3 - Gerçek API endpoint'i ile test edin
  Future<void> deleteNote(int noteId) async {
    try {
      await _httpService.delete(
        '/notes/$noteId',
        token: _getToken(),
      );
    } catch (e) {
      throw Exception('Not silinemedi: $e');
    }
  }

  /// Belirli bir notu ID ile getir
  /// TODO: Kişi 3 - Gerçek API endpoint'i ile test edin
  Future<NoteModel> fetchNoteById(int noteId) async {
    try {
      final response = await _httpService.get(
        '/notes/$noteId',
        token: _getToken(),
      );

      return NoteModel.fromJson(response['data'] as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Not getirilemedi: $e');
    }
  }

  /// Notları senkronize et (local ve remote arasında)
  /// TODO: Kişi 2 ile birlikte senkronizasyon mantığını geliştirin
  Future<void> syncNotes() async {
    // Bu fonksiyon Kişi 2'nin database yönetimi ile entegre edilecek
    // Örnek senkronizasyon mantığı:
    // 1. API'den tüm notları çek
    // 2. Local database'deki notları kontrol et
    // 3. Farklılıkları güncelle
    throw UnimplementedError('Senkronizasyon Kişi 2 ile birlikte tamamlanacak');
  }
}
