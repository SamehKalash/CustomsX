import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static String get baseUrl => dotenv.env['API_URL'] ?? 'http://localhost:5000';
  static const Duration _timeoutDuration = Duration(seconds: 10);
  static const String _customsBaseUrl =
      'https://c2b-fbusiness.customs.gov.az/api/v1';

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
      throw _parseException(e, 'HS codes fetch');
    }
  }
// These are just the updated IMEI-related methods for the ApiService class
// Add these to your existing api_service.dart file

  // Updated Fetch phone information based on IMEI number
  static Future<Map<String, dynamic>> fetchPhoneType(String imeiNumber) async {
    try {
      // Input validation on client side
      if (imeiNumber.length != 15 || !RegExp(r'^\d{15}$').hasMatch(imeiNumber)) {
        throw Exception('Please enter a valid 15-digit IMEI number.');
      }

      final response = await http
          .get(
            Uri.parse('$baseUrl/api/phone-type/$imeiNumber'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(_timeoutDuration);

      // Handle response based on status code
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        
        // Additional device information processing
        if (responseBody['brand'] == 'Unknown' && responseBody['model'] == 'Unknown') {
          responseBody['warning'] = 'Limited device information available';
        }
        
        return responseBody;
      } else if (response.statusCode == 404) {
        // Handle specific 404 error (IMEI not found)
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['error'] ?? 'IMEI not found in the database.');
      } else {
        // Handle other errors
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['error'] ?? 'Unknown error occurred.');
      }
    } on TimeoutException {
      throw Exception('Request timed out. Please check your connection and try again.');
    } on FormatException {
      throw Exception('Invalid response from server. Please try again later.');
    } catch (e) {
      if (e is Exception) {
        throw e;
      }
      throw Exception('Error fetching phone information: $e');
    }
  }

  // Register IMEI after payment
  static Future<Map<String, dynamic>> registerIMEI(String imeiNumber) async {
    try {
      // Input validation on client side
      if (imeiNumber.length != 15 || !RegExp(r'^\d{15}$').hasMatch(imeiNumber)) {
        throw Exception('Please enter a valid 15-digit IMEI number.');
      }

      final response = await http
          .post(
            Uri.parse('$baseUrl/api/register-imei'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'imei_number': imeiNumber}),
          )
          .timeout(_timeoutDuration);

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        
        // Add confirmation timestamp
        if (result['imeiRecord'] != null) {
          result['imeiRecord']['registered_date'] = DateTime.now().toIso8601String();
        }
        
        return result;
      } else if (response.statusCode == 400) {
        // Handle specific 400 errors (like already registered)
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['error'] ?? 'Failed to register IMEI. It may already be registered.');
      } else {
        // Handle other errors
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['error'] ?? 'Failed to register IMEI.');
      }
    } on TimeoutException {
      throw Exception('Request timed out. Please check your connection and try again.');
    } on FormatException {
      throw Exception('Invalid response from server. Please try again later.');
    } catch (e) {
      if (e is Exception) {
        throw e;
      }
      throw _parseException(e, 'registering IMEI');
    }
  }
  
  // New method to check detailed IMEI information
  static Future<Map<String, dynamic>> getDetailedImeiInfo(String imeiNumber) async {
    try {
      // Input validation on client side
      if (imeiNumber.length != 15 || !RegExp(r'^\d{15}$').hasMatch(imeiNumber)) {
        throw Exception('Please enter a valid 15-digit IMEI number.');
      }

      final response = await http
          .get(
            Uri.parse('$baseUrl/api/imei-details/$imeiNumber'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(_timeoutDuration);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['error'] ?? 'Failed to fetch detailed IMEI information.');
      }
    } catch (e) {
      if (e is Exception) {
        throw e;
      }
      throw _parseException(e, 'fetching detailed IMEI information');
    }
  }

  // -- Helper methods --
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
          responseBody['exception']?['errorMessage'] ??
          'Unknown $operation error';
      throw Exception('$operation failed: $error');
    }

    return responseBody['data'];
  }

  static Map<String, String> _customsHeaders({String lang = 'en'}) {
    return {
      'Content-Type': 'application/json',
      'lang': lang,
      // Add authorization if needed:
      // 'Authorization': 'Bearer ${dotenv.env['CUSTOMS_TOKEN']}',
    };
  }

  // -- Keep existing response handlers unchanged --
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