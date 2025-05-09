import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static String get baseUrl => dotenv.env['API_URL'] ?? 'http://localhost:5000';
  static const Duration _timeoutDuration = Duration(seconds: 10);
  static const String _customsBaseUrl =
      'https://c2b-fbusiness.customs.gov.az/api/v1';

  // ================== IMEI Services ==================
  static Future<Map<String, dynamic>> fetchPhoneType(String imei) async {
    try {
      // Validate IMEI format
      if (imei.length != 15 || !RegExp(r'^\d{15}$').hasMatch(imei)) {
        throw Exception('Please enter a valid 15-digit IMEI number');
      }

      final response = await http
          .get(
            Uri.parse('$baseUrl/api/imei/$imei'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(_timeoutDuration);

      final responseBody = _handleResponse(response, 'IMEI check failed');

      // Handle invalid TAC
      if (responseBody['valid_tac'] != true) {
        throw Exception(
          'Invalid device identification (TAC validation failed)',
        );
      }

      return {
        'brand': responseBody['brand'] ?? 'Unknown',
        'model': responseBody['model'] ?? 'Unknown',
        'device_type': responseBody['device_type'] ?? 'Mobile Device',
        'operating_system': responseBody['operating_system'] ?? 'Unknown',
        'fee': responseBody['fee']?.toInt() ?? 5000,
        'is_registered': responseBody['is_registered'] ?? false,
        'valid_tac': responseBody['valid_tac'] ?? false,
        'origin_country': responseBody['origin_country'] ?? 'Unknown',
        'release_year': responseBody['release_year']?.toString() ?? 'N/A',
        'technical_specs':
            responseBody['technical_specs'] is Map
                ? Map<String, dynamic>.from(responseBody['technical_specs'])
                : <String, dynamic>{},
      };
    } on TimeoutException {
      throw Exception('IMEI check timed out. Please try again.');
    } catch (e) {
      throw _parseException(e, 'fetching device information');
    }
  }

  static Future<Map<String, dynamic>> registerIMEI(String imei) async {
    try {
      // Validate IMEI before registration
      if (imei.length != 15 || !RegExp(r'^\d{15}$').hasMatch(imei)) {
        throw Exception('Invalid IMEI format');
      }

      final response = await http
          .post(
            Uri.parse('$baseUrl/api/imei/register'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'imei_number': imei}),
          )
          .timeout(_timeoutDuration);

      final responseBody = _handleResponse(
        response,
        'IMEI registration failed',
      );

      return {
        'message': responseBody['message'] ?? 'Registration successful',
        'imeiRecord': {
          'imei_number': responseBody['imeiRecord']['imei_number'],
          'is_registered': responseBody['imeiRecord']['is_registered'] ?? false,
          'registration_date': responseBody['imeiRecord']['registration_date'],
          'fee': responseBody['imeiRecord']['fee']?.toInt() ?? 5000,
          'brand': responseBody['imeiRecord']['brand'],
          'model': responseBody['imeiRecord']['model'],
        },
      };
    } on TimeoutException {
      throw Exception('Registration process timed out');
    } catch (e) {
      throw _parseException(e, 'device registration');
    }
  }

  // ================== Country Services ==================
  static Future<List<dynamic>> getCountries() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/countries'))
          .timeout(_timeoutDuration);

      return _handleResponse(response, 'Failed to load countries');
    } catch (e) {
      throw _parseException(e, 'loading countries');
    }
  }

  // ================== User Services ==================
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
      throw _parseException(e, 'user registration');
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
      throw _parseException(e, 'user login');
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

  // ================== Customs Services ==================
  static Future<Map<String, dynamic>> validateHscode({
    required int declarationMode,
    required String code,
    String lang = 'en',
  }) async {
    try {
      final response = await http
          .get(
            Uri.parse(
              '${_customsBaseUrl}/goods/check-code?declarationMode=$declarationMode&code=$code',
            ),
            headers: _customsHeaders(lang: lang),
          )
          .timeout(_timeoutDuration);

      return _processCustomsResponse(response, 'HS code validation');
    } catch (e) {
      throw _parseException(e, 'HS code validation');
    }
  }

  static Future<Map<String, dynamic>> calculateDuty({
    required int declarationMode,
    required String hsCode,
    required double invoice,
    required double transportExpenses,
    required double otherExpenses,
    String? privilege,
    List<Map<String, dynamic>>? dependedFields,
    String lang = 'en',
  }) async {
    try {
      final body = {
        'declarationMode': declarationMode,
        'hsCode': hsCode,
        'invoice': invoice,
        'transportExpenses': transportExpenses,
        'otherExpenses': otherExpenses,
        'privilege': privilege,
        'dependedFields': dependedFields ?? [],
      };

      final response = await http
          .post(
            Uri.parse('${_customsBaseUrl}/goods/calculate-duty'),
            headers: _customsHeaders(lang: lang),
            body: jsonEncode(body),
          )
          .timeout(_timeoutDuration);

      return _processCustomsResponse(response, 'duty calculation');
    } catch (e) {
      throw _parseException(e, 'duty calculation');
    }
  }

  // ================== HS Code Services ==================
  static Future<List<dynamic>> getHscodes({String searchQuery = ''}) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/hscodes?search=$searchQuery'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(_timeoutDuration);

      return _handleResponse(response, 'Failed to load HS codes');
    } catch (e) {
      throw _parseException(e, 'loading HS codes');
    }
  }

  // ================== Helper Methods ==================
  static Map<String, dynamic> _processCustomsResponse(
    http.Response response,
    String operation,
  ) {
    final responseBody = _handleResponse(
      response,
      'Failed to complete $operation',
    );

    if (responseBody['code'] != 200) {
      final error =
          responseBody['exception']?['errorMessage'] ?? 'Unknown error';
      throw Exception('$operation failed: $error');
    }

    return responseBody['data'];
  }

  static Map<String, String> _customsHeaders({String lang = 'en'}) {
    return {'Content-Type': 'application/json', 'lang': lang};
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
      throw Exception('Invalid server response format');
    }
  }

  static Exception _parseException(dynamic error, String operation) {
    final message =
        error is TimeoutException
            ? 'Request timed out during $operation'
            : error is http.ClientException
            ? 'Network error during $operation'
            : error.toString().replaceAll('Exception: ', '');
    return Exception('$message. Please try again.');
  }
}
