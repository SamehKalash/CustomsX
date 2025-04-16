import 'package:flutter/material.dart';
import '../widgets/exhannge_rate.dart';

class ExchangeRateScreen extends StatelessWidget {
  const ExchangeRateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exchange Rates'),
        backgroundColor: const Color(0xFFE3B505), // Yellowish color for branding
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Current Exchange Rates',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ExchangeRateWidget(), // Reuse the existing widget
            ),
          ],
        ),
      ),
    );
  }
}