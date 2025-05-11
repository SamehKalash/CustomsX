import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  _PaymentMethodsScreenState createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final formKey = GlobalKey<FormState>();
  String? cardNumber, cardHolderName, expiryDate, cvv;
  bool isLoading = false;
  bool isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color cardColor = isDarkMode ? const Color(0xFF23272F) : Colors.white;
    final Color borderColor = isDarkMode ? Colors.white12 : Colors.grey.shade300;
    final Color labelColor = isDarkMode ? Colors.white70 : Colors.black87;
    final Color iconColor = isDarkMode ? const Color(0xFFD4A373) : Colors.blueGrey;
    final Color buttonColor = isDarkMode ? const Color(0xFFD4A373) : Colors.blue;
    final Color hintColor = isDarkMode ? Colors.white38 : Colors.grey;

    // Dashboard-like background gradient
    final BoxDecoration backgroundDecoration = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDarkMode
            ? [const Color(0xFF1A120B), const Color(0xFF3C2A21), const Color(0xFF1A120B)]
            : [Colors.white, const Color(0xFFF5F5DC), Colors.white],
        stops: const [0.0, 0.5, 1.0],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Payment Method'),
        backgroundColor: isDarkMode ? const Color(0xFF1A120B) : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        elevation: 2,
      ),
      body: Container(
        decoration: backgroundDecoration,
        width: double.infinity,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 420),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Card(
                color: cardColor,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: BorderSide(color: borderColor, width: 1.2),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 28),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title Section
                        Center(
                          child: Text(
                            'Enter Card Details',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode ? Colors.white : Colors.black,
                                ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Card Number Field
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Card Number',
                            hintText: '1234 5678 9012 3456',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: Icon(Icons.credit_card, color: iconColor),
                            filled: true,
                            fillColor: cardColor,
                            labelStyle: TextStyle(color: labelColor),
                            hintStyle: TextStyle(color: hintColor),
                          ),
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 2,
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(16),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your card number';
                            }
                            if (value.length != 16) {
                              return 'Card number must be 16 digits';
                            }
                            return null;
                          },
                          onSaved: (value) => cardNumber = value,
                        ),
                        const SizedBox(height: 20),

                        // Card Holder Name Field
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Card Holder Name',
                            hintText: 'John Doe',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: Icon(Icons.person, color: iconColor),
                            filled: true,
                            fillColor: cardColor,
                            labelStyle: TextStyle(color: labelColor),
                            hintStyle: TextStyle(color: hintColor),
                          ),
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the card holder name';
                            }
                            if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                              return 'Name must contain only letters';
                            }
                            return null;
                          },
                          onSaved: (value) => cardHolderName = value,
                        ),
                        const SizedBox(height: 20),

                        // Expiry Date and CVV Fields
                        Row(
                          children: [
                            // Expiry Date Field
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Expiry Date',
                                  hintText: 'MM/YY',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  prefixIcon: Icon(Icons.calendar_today, color: iconColor),
                                  filled: true,
                                  fillColor: cardColor,
                                  labelStyle: TextStyle(color: labelColor),
                                  hintStyle: TextStyle(color: hintColor),
                                ),
                                style: TextStyle(
                                  color: isDarkMode ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(5),
                                  _ExpiryDateFormatter(),
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the expiry date';
                                  }
                                  final regex = RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$');
                                  if (!regex.hasMatch(value)) {
                                    return 'Invalid expiry date format (MM/YY)';
                                  }
                                  final now = DateTime.now();
                                  final parts = value.split('/');
                                  final month = int.parse(parts[0]);
                                  final year = int.parse(parts[1]) + 2000;
                                  final expiryDate = DateTime(year, month);
                                  if (expiryDate.isBefore(DateTime(now.year, now.month + 1))) {
                                    return 'Expiry date cannot be in the past';
                                  }
                                  return null;
                                },
                                onSaved: (value) => expiryDate = value,
                              ),
                            ),
                            const SizedBox(width: 16),
                            // CVV Field
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'CVV',
                                  hintText: '123',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  prefixIcon: Icon(Icons.lock, color: iconColor),
                                  filled: true,
                                  fillColor: cardColor,
                                  labelStyle: TextStyle(color: labelColor),
                                  hintStyle: TextStyle(color: hintColor),
                                ),
                                style: TextStyle(
                                  color: isDarkMode ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                                obscureText: true,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(3),
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the CVV';
                                  }
                                  if (value.length != 3) {
                                    return 'CVV must be 3 digits';
                                  }
                                  return null;
                                },
                                onSaved: (value) => cvv = value,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),

                        // Save Button
                        Center(
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isSubmitting
                                  ? null
                                  : () async {
                                      setState(() => isSubmitting = true);
                                      if (formKey.currentState!.validate()) {
                                        formKey.currentState!.save();
                                        setState(() => isLoading = true);

                                        await Future.delayed(const Duration(seconds: 2));

                                        setState(() => isLoading = false);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: const Text(
                                              'Payment method added successfully!',
                                            ),
                                            backgroundColor: buttonColor,
                                          ),
                                        );
                                        Navigator.pop(context);
                                      } else {
                                        print('Form validation failed');
                                      }
                                      setState(() => isSubmitting = false);
                                    },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: buttonColor,
                                foregroundColor: Colors.white,
                                textStyle: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                                elevation: 2,
                              ),
                              child: isSubmitting
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text('Save Payment'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll('/', '');
    if (text.isEmpty) {
      return newValue;
    } else if (text.length <= 2) {
      return TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    } else if (text.length <= 4) {
      final formatted = '${text.substring(0, 2)}/${text.substring(2)}';
      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    } else {
      return oldValue;
    }
  }
}
