import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static String get baseUrl => dotenv.env['API_URL'] ?? 'http://localhost:5000';
  static const Duration _timeoutDuration = Duration(seconds: 10);

  static Future<List<dynamic>> getCountries() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/countries'))
          .timeout(_timeoutDuration);

      return _handleResponse(response, 'Failed to load countries');
    } catch (e) {
      throw _parseException(e, 'countries');
    }
  }

  static Future<Map<String, dynamic>> registerUser(
    Map<String, dynamic> userData,
  ) async {
    try {
      if (userData['email'] == null || userData['password'] == null) {
        throw Exception('Email and password are required');
      }

      final response = await http
          .post(
            Uri.parse('$baseUrl/register'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(userData),
          )
          .timeout(_timeoutDuration);

      return _handleResponse(response, 'Registration failed');
    } catch (e) {
      throw _parseException(e, 'registration');
    }
  }

  static Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Both email and password are required');
      }

      final response = await http
          .post(
            Uri.parse('$baseUrl/login'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'email': email.trim().toLowerCase(),
              'password': password,
            }),
          )
          .timeout(_timeoutDuration);

      return _handleResponse(response, 'Login failed');
    } catch (e) {
      throw _parseException(e, 'login');
    }
  }

  static Future<Map<String, dynamic>> updateProfile(
    Map<String, dynamic> updatedData,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/updateProfile'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(updatedData),
          )
          .timeout(_timeoutDuration);

      return _handleResponse(response, 'Profile update failed');
    } catch (e) {
      throw _parseException(e, 'profile update');
    }
  }

  static Future<Map<String, dynamic>> changePassword({
    required String email,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/changePassword'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'email': email,
              'oldPassword': oldPassword,
              'newPassword': newPassword,
            }),
          )
          .timeout(_timeoutDuration);

      return _handleResponse(response, 'Password change failed');
    } catch (e) {
      throw _parseException(e, 'password change');
    }
  }

  static dynamic _handleResponse(http.Response response, String errorMessage) {
    try {
      final responseBody = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return responseBody;
      }

      final serverError = responseBody['error'] ?? 'Unknown server error';
      throw Exception('$errorMessage - $serverError');
    } on FormatException {
      throw Exception('Invalid response format from server');
    }
  }

  static Exception _parseException(dynamic error, String operation) {
    final message =
        error is TimeoutException
            ? 'Request timed out during $operation'
            : error is http.ClientException
            ? 'Network error during $operation'
            : error.toString();

    return Exception(message);
  }
}
