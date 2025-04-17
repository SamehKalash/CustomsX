import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static String get baseUrl => dotenv.env['API_URL'] ?? 'http://localhost:5000';

  // Existing country data method
  static Future<List<dynamic>> getCountries() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/countries'));
      return _handleResponse(response, 'Failed to load countries');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Enhanced registration method
  static Future<Map<String, dynamic>> registerUser(
    Map<String, dynamic> userData,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );
      return _handleResponse(response, 'Registration failed');
    } catch (e) {
      throw Exception('Registration error: ${e.toString()}');
    }
  }

  // Generic response handler
  static dynamic _handleResponse(http.Response response, String errorMessage) {
    final responseBody = json.decode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return responseBody;
    } else {
      throw Exception(responseBody['error'] ?? errorMessage);
    }
  }
}
