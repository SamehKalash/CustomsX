import 'package:flutter/material.dart';

class IMEICheckerScreen extends StatefulWidget {
  const IMEICheckerScreen({Key? key}) : super(key: key);

  @override
  _IMEICheckerScreenState createState() => _IMEICheckerScreenState();
}

class _IMEICheckerScreenState extends State<IMEICheckerScreen> {
  final TextEditingController _imeiController = TextEditingController();
  String? _result;

  void _checkIMEI() {
    final imei = _imeiController.text.trim();
    if (imei.isEmpty) {
      setState(() {
        _result = 'Please enter a valid IMEI number.';
      });
      return;
    }

    // Simulate a database check
    final isRegistered = imei == '123456789012345'; 
    if (isRegistered) {
      setState(() {
        _result = 'This IMEI is registered in our database.';
      });
    } else {
      setState(() {
        _result = 'This IMEI is not registered. You need to pay 5000 EGP.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('IMEI Checker'),
        backgroundColor: isDarkMode ? const Color(0xFF1A120B) : const Color(0xFFD4A373),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [const Color(0xFF1A120B), const Color(0xFF3C2A21)]
                : [const Color(0xFFF5F5DC), const Color(0xFFD4A373)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              color: isDarkMode ? const Color(0xFF3C2A21) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Enter IMEI Number:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _imeiController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter IMEI',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _checkIMEI,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4A373),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Check IMEI',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Explicitly set text color to white
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_result != null)
              Card(
                elevation: 4,
                color: isDarkMode ? const Color(0xFF3C2A21) : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _result!,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode ? const Color(0xFFF5F5DC) : Colors.red,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}