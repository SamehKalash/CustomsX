import 'dart:convert';
import 'package:flutter/services.dart';

class TariffData {
  final String hsCode;
  final String description;
  final double adValoremOld;
  final double tariffRate;

  TariffData({
    required this.hsCode,
    required this.description,
    required this.adValoremOld,
    required this.tariffRate,
  });

  // Factory constructor to create a TariffData object from JSON
  factory TariffData.fromJson(Map<String, dynamic> json) {
    return TariffData(
      hsCode: json['HS Code'].toString(),
      description: json['Description'],
      adValoremOld: (json['AdValoremold'] as num).toDouble(),
      tariffRate:
          double.tryParse(json['Tariff Rate'].replaceAll('%', '')) ?? 0.0,
    );
  }

  // Default instance for fallback
  static TariffData defaultInstance() {
    return TariffData(
      hsCode: 'N/A',
      description: 'Not Found',
      adValoremOld: 0.0,
      tariffRate: 0.0,
    );
  }
}

class TariffService {
  static List<TariffData> _hsCodes = [];

  // Load and parse the JSON file
  static Future<void> loadHsCodes() async {
    try {
      final String response = await rootBundle.loadString(
        'lib/hs_codes_vehicles.json',
      );
      print('Loaded JSON: $response'); // Debug print to verify file content

      final List<dynamic> data = json.decode(response);
      print('Parsed JSON Data: $data'); // Debug print to verify parsed data

      _hsCodes = data.map((json) => TariffData.fromJson(json)).toList();
      print(
        'Mapped HS Codes: ${_hsCodes.map((e) => e.hsCode).toList()}',
      ); // Debug print to verify mapped objects
    } catch (e) {
      print('Error loading tariff data: $e');
    }
  }

  // Get all HS codes
  static List<TariffData> getHsCodes() {
    return _hsCodes;
  }

  // Find a specific tariff by HS Code
  static TariffData? findTariffByHsCode(String hsCode) {
    return _hsCodes.firstWhere(
      (tariff) => tariff.hsCode == hsCode,
      orElse: () => TariffData.defaultInstance(),
    );
  }
}
