import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../services/tariff_service.dart';

class CustomsFeeScreen extends StatefulWidget {
  const CustomsFeeScreen({super.key});

  @override
  _CustomsFeeScreenState createState() => _CustomsFeeScreenState();
}

class _CustomsFeeScreenState extends State<CustomsFeeScreen> {
  final TextEditingController _hsCodeController = TextEditingController();
  final TextEditingController _customsValueController = TextEditingController();
  String _description = '';
  double _tariffRate = 0.0;
  String _result = '';

  @override
  void initState() {
    super.initState();
    _loadTariffData();
  }

  Future<void> _loadTariffData() async {
    await TariffService.loadHsCodes();
  }

  void _searchHsCode() {
    String hsCode = _hsCodeController.text.trim();
    TariffData? tariff = TariffService.findTariffByHsCode(hsCode);

    if (tariff != null && tariff.hsCode != 'N/A') {
      setState(() {
        _description = tariff.description;
        _tariffRate = tariff.tariffRate;
        _result = '';
      });
    } else {
      setState(() {
        _description = 'HS Code not found!';
        _tariffRate = 0.0;
        _result = '';
      });
    }
  }

  void _calculateCustomsFee() {
    double customsValue = double.tryParse(_customsValueController.text) ?? 0.0;

    if (_tariffRate > 0) {
      double duty = customsValue * (_tariffRate / 100);
      setState(() {
        _result = 'Customs Duty: \$${duty.toStringAsFixed(2)}';
      });
    } else {
      setState(() {
        _result = 'Please search and select a valid HS Code first.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    // Dynamically set colors based on the theme
    final backgroundColor = isDarkMode ? const Color(0xFF1A120B) : Colors.white;
    final textColor = isDarkMode ? const Color(0xFFF5F5DC) : Colors.black;
    final buttonColor = isDarkMode ? const Color(0xFFD4A373) : const Color(0xFF6A994E);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Calculate Customs Fees',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          backgroundColor: backgroundColor,
          iconTheme: IconThemeData(color: textColor),
          elevation: 4,
        ),
        body: Container(
          color: backgroundColor,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Input for HS Code
              TextFormField(
                controller: _hsCodeController,
                decoration: InputDecoration(
                  labelText: 'Enter HS Code',
                  labelStyle: TextStyle(color: textColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: textColor),
                  ),
                ),
                style: TextStyle(color: textColor),
              ),
              const SizedBox(height: 16),

              // Search Button
              ElevatedButton(
                onPressed: _searchHsCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Search',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),

              // Display the description and tariff rate
              Text(
                'Description: $_description',
                style: TextStyle(fontSize: 16, color: textColor),
              ),
              const SizedBox(height: 8),
              Text(
                'Tariff Rate: $_tariffRate%',
                style: TextStyle(fontSize: 16, color: textColor),
              ),
              const SizedBox(height: 16),

              // Input for customs value
              TextFormField(
                controller: _customsValueController,
                decoration: InputDecoration(
                  labelText: 'Enter Customs Value (\$)',
                  labelStyle: TextStyle(color: textColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: textColor),
                  ),
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(color: textColor),
              ),
              const SizedBox(height: 16),

              // Calculate Button
              ElevatedButton(
                onPressed: _calculateCustomsFee,
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Calculate',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),

              // Display the result
              Text(
                _result,
                style: TextStyle(fontSize: 16, color: textColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
