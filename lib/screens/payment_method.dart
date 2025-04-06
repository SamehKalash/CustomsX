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
    return Scaffold(
      appBar: AppBar(title: const Text('Add Payment Method')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Section
                Text(
                  'Enter Card Details',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 24),

                // Card Number Field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Card Number',
                    hintText: '1234 5678 9012 3456',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.credit_card),
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
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.person),
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
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.calendar_today),
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

                          if (expiryDate.isBefore(
                            DateTime(now.year, now.month + 1),
                          )) {
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
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.lock),
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
                const SizedBox(height: 24),

                // Save Button
                Center(
                  child: ElevatedButton.icon(
                    onPressed:
                        isSubmitting
                            ? null
                            : () async {
                              setState(() => isSubmitting = true);
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                setState(() => isLoading = true);

                                // Simulate saving process
                                await Future.delayed(
                                  const Duration(seconds: 2),
                                );

                                setState(() => isLoading = false);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      'Payment method added successfully!',
                                    ),
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                  ),
                                );
                                Navigator.pop(context);
                              }
                              setState(() => isSubmitting = false);
                            },
                    icon:
                        isSubmitting
                            ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : const Icon(Icons.save),
                    label: const Text('Save Payment Method'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 32,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
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
