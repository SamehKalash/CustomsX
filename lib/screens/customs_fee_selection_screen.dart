import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../services/tariff_service.dart';

class CustomsFeeSelectionScreen extends StatelessWidget {
  const CustomsFeeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final backgroundColor = isDarkMode ? const Color(0xFF1A120B) : Colors.white;
    final textColor =
        isDarkMode ? const Color(0xFFF5F5DC) : const Color(0xFF1A120B);
    final buttonColor = const Color(0xFFD4A373);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Customs Fee Options',
          style: TextStyle(
            fontSize: 20.sp,
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
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CustomsFeeScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                child: Text(
                  'Calculate Customs Fees',
                  style: TextStyle(fontSize: 16.sp, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () {
                // Add logic for another option if needed
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                child: Text(
                  'Other Option',
                  style: TextStyle(fontSize: 16.sp, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomsFeeScreen extends StatefulWidget {
  const CustomsFeeScreen({super.key});

  @override
  _CustomsFeeScreenState createState() => _CustomsFeeScreenState();
}

class _CustomsFeeScreenState extends State<CustomsFeeScreen> {
  final TextEditingController _hsCodeController = TextEditingController();
  final TextEditingController _customsValueController = TextEditingController();
  String _description = ''; // To store the description of the selected HS code
  double _tariffRate = 0.0; // To store the tariff rate of the selected HS code
  String _result = ''; // To display the calculated customs duty

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
        _result = ''; // Clear previous result
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
    return Scaffold(
      appBar: AppBar(title: const Text('Calculate Customs Fees')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _hsCodeController,
              decoration: const InputDecoration(
                labelText: 'Enter HS Code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _searchHsCode,
              child: const Text('Search'),
            ),
            const SizedBox(height: 16),
            Text('Description: $_description'),
            Text('Tariff Rate: $_tariffRate%'),
            const SizedBox(height: 16),
            TextField(
              controller: _customsValueController,
              decoration: const InputDecoration(
                labelText: 'Enter Customs Value (\$)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _calculateCustomsFee,
              child: const Text('Calculate'),
            ),
            const SizedBox(height: 16),
            Text(_result),
          ],
        ),
      ),
    );
  }
}

class CustomsFeeScreen extends StatefulWidget {

  @override
  _CustomsFeeScreenState createState() => _CustomsFeeScreenState();
}

class _CustomsFeeScreenState extends State<CustomsFeeScreen> {
  final TextEditingController _hsCodeController = TextEditingController();
  final TextEditingController _customsValueController = TextEditingController();
  String _description = ''; // To store the description of the selected HS code
  double _tariffRate = 0.0; // To store the tariff rate of the selected HS code
  String _result = ''; // To display the calculated customs duty

  @override
  void initState() {
    super.initState();
    _loadTariffData();
  }

  Future<void> _loadTariffData() async {
    await TariffService.loadHsCodes();
  }

  
  }

  
    );
  }
}
