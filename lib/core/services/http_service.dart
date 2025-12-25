import 'dart:convert';
import 'package:http/http.dart' as http;

/// HTTP istekleri için temel servis sınıfı
/// GET, POST, PUT, DELETE operasyonlarını destekler
class HttpService {
  // Singleton instance
  static final HttpService instance = HttpService._init();

  HttpService._init();

  // Base URL - gerçek API endpoint'i ile değiştirilmeli
  // TODO: Kişi 3 - Gerçek API URL'ini buraya ekleyin
  static const String baseUrl = 'https://api.example.com';

  /// Default headers
  Map<String, String> _getHeaders({String? token}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Token varsa ekle
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  /// GET isteği
  /// [endpoint]: API endpoint'i (örn: '/users')
  /// [token]: Authentication token (opsiyonel)
  Future<Map<String, dynamic>> get(
    String endpoint, {
    String? token,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await http.get(
        url,
        headers: _getHeaders(token: token),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('GET isteği başarısız: $e');
    }
  }

  /// POST isteği
  /// [endpoint]: API endpoint'i
  /// [body]: Gönderilecek veri
  /// [token]: Authentication token (opsiyonel)
  Future<Map<String, dynamic>> post(
    String endpoint, {
    required Map<String, dynamic> body,
    String? token,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await http.post(
        url,
        headers: _getHeaders(token: token),
        body: jsonEncode(body),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('POST isteği başarısız: $e');
    }
  }

  /// PUT isteği (güncelleme)
  /// [endpoint]: API endpoint'i
  /// [body]: Güncellenecek veri
  /// [token]: Authentication token (opsiyonel)
  Future<Map<String, dynamic>> put(
    String endpoint, {
    required Map<String, dynamic> body,
    String? token,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await http.put(
        url,
        headers: _getHeaders(token: token),
        body: jsonEncode(body),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('PUT isteği başarısız: $e');
    }
  }

  /// DELETE isteği
  /// [endpoint]: API endpoint'i
  /// [token]: Authentication token (opsiyonel)
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    String? token,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await http.delete(
        url,
        headers: _getHeaders(token: token),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('DELETE isteği başarısız: $e');
    }
  }

  /// Response'u işle ve parse et
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Başarılı response
      if (response.body.isEmpty) {
        return {'success': true};
      }
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      // Hata durumu
      String errorMessage = 'HTTP Hatası: ${response.statusCode}';
      try {
        final errorBody = jsonDecode(response.body) as Map<String, dynamic>;
        errorMessage = errorBody['message'] ?? errorMessage;
      } catch (e) {
        // JSON parse edilemezse, default mesajı kullan
      }
      throw Exception(errorMessage);
    }
  }
}
