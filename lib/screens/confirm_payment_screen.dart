import 'package:flutter/material.dart';
import 'receipt_screen.dart';

class ConfirmPaymentScreen extends StatelessWidget {
  final String paymentType;
  final String documentNumber;

  const ConfirmPaymentScreen({
    Key? key,
    required this.paymentType,
    required this.documentNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Navigate to ReceiptScreen as soon as this screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => ReceiptScreen(
                paymentType: paymentType,
                documentNumber: documentNumber,
              ),
        ),
      );
    });

    // Optionally, show a loading indicator while redirecting
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: const Color(0xFFD4A373)),
      ),
    );
  }
}
