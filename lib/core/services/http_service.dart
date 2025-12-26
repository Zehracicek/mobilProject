import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;

class HttpService {
  static final HttpService instance = HttpService._init();

  HttpService._init();

  static const String baseUrl = 'https://api.example.com';

  Map<String, String> _getHeaders({String? token}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Future<Map<String, dynamic>> get(String endpoint, {String? token}) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await http.get(url, headers: _getHeaders(token: token));

      return _handleResponse(response);
    } catch (e) {
      throw Exception('GET isteği başarısız: $e');
    }
  }

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

  Future<Map<String, dynamic>> delete(String endpoint, {String? token}) async {
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

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {'success': true};
      }
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      String errorMessage = 'HTTP Hatası: ${response.statusCode}';
      try {
        final errorBody = jsonDecode(response.body) as Map<String, dynamic>;
        errorMessage = errorBody['message'] ?? errorMessage;
      } catch (e) {
        developer.log('Failed to parse error body: $e');
      }
      throw Exception(errorMessage);
    }
  }
}
