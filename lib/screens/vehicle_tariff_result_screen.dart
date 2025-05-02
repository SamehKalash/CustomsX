import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

class VehicleTariffResultScreen extends StatefulWidget {
  final double engineVolume;
  final double invoiceValue;
  final double shippingCost;
  final double otherExpenses;
  final int yearOfManufacture;
  final double tariff;
  final String vehicleType;
  final String countryOption;

  const VehicleTariffResultScreen({
    super.key,
    required this.engineVolume,
    required this.invoiceValue,
    required this.shippingCost,
    required this.otherExpenses,
    required this.yearOfManufacture,
    required this.tariff,
    required this.vehicleType,
    required this.countryOption,
  });

  @override
  _VehicleTariffResultScreenState createState() =>
      _VehicleTariffResultScreenState();
}

class _VehicleTariffResultScreenState extends State<VehicleTariffResultScreen> {
  String _selectedCurrency = 'EGP'; // Default currency set to Egyptian Pound
  Map<String, Map<String, String>> _exchangeRates = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchExchangeRates();
  }

  Future<void> _fetchExchangeRates() async {
    // Simulate fetching exchange rates from the ExchangeRateWidget
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    setState(() {
      _exchangeRates = {
        'USD': {'rate': '50.65', 'symbol': '\$'},
        'GBP': {'rate': '65.51', 'symbol': '£'},
        'CAD': {'rate': '35.44', 'symbol': '\$'},
        'DKK': {'rate': '7.32', 'symbol': 'kr'},
        'NOK': {'rate': '4.81', 'symbol': 'kr'},
        'SEK': {'rate': '5.05', 'symbol': 'kr'},
        'CHF': {'rate': '57.28', 'symbol': 'CHF'},
        'JPY': {'rate': '0.34', 'symbol': '¥'},
        'EUR': {'rate': '54.62', 'symbol': '€'},
        'EGP': {'rate': '1.00', 'symbol': 'E£'}, // Default currency
        'AUD': {'rate': '33.12', 'symbol': '\$'},
        'INR': {'rate': '0.61', 'symbol': '₹'},
        'CNY': {'rate': '7.25', 'symbol': '¥'},
        'ZAR': {'rate': '3.25', 'symbol': 'R'},
      };
      _isLoading = false;
    });
  }

  double _convertTariff(double tariff, String currency) {
    double rate = double.parse(_exchangeRates[currency]?['rate'] ?? '1.0');
    return tariff * rate;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final backgroundColor = isDarkMode ? const Color(0xFF1A120B) : Colors.white;
    final textColor =
        isDarkMode ? const Color(0xFFF5F5DC) : const Color(0xFF1A120B);
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodyLarge?.copyWith(fontSize: 16);

    double convertedTariff = _convertTariff(widget.tariff, _selectedCurrency);
    String currencySymbol = _exchangeRates[_selectedCurrency]?['symbol'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tariff Calculation Result'),
        backgroundColor: backgroundColor,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: textColor,
              ),
            )
          : Container(
              color: backgroundColor,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Calculation Summary',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildResultRow('Vehicle Type:', widget.vehicleType, textStyle),
                  _buildResultRow(
                      'Engine Volume:', '${widget.engineVolume.toStringAsFixed(2)} cm³', textStyle),
                  _buildResultRow(
                      'Invoice Value:', '\$${widget.invoiceValue.toStringAsFixed(2)}', textStyle),
                  _buildResultRow(
                      'Shipping Cost:', '\$${widget.shippingCost.toStringAsFixed(2)}', textStyle),
                  _buildResultRow(
                      'Other Expenses:', '\$${widget.otherExpenses.toStringAsFixed(2)}', textStyle),
                  _buildResultRow(
                      'Year of Manufacture:', '${widget.yearOfManufacture}', textStyle),
                  _buildResultRow('Country Option:', widget.countryOption, textStyle),
                  const Divider(height: 30, thickness: 1.5),
                  Center(
                    child: Text(
                      'Calculated Tariff',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      '$currencySymbol ${convertedTariff.toStringAsFixed(2)}',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: DropdownButton<String>(
                      value: _selectedCurrency,
                      items: _exchangeRates.keys
                          .map((currency) => DropdownMenuItem(
                                value: currency,
                                child: Text(
                                  currency,
                                  style: TextStyle(color: textColor),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCurrency = value!;
                        });
                      },
                      dropdownColor: backgroundColor,
                      style: TextStyle(color: textColor),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Navigate back to entry screen
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          'Edit Calculations',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/dashboard', (route) => false);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          'Return to Dashboard',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildResultRow(String label, String value, TextStyle? textStyle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: textStyle?.copyWith(fontWeight: FontWeight.bold)),
          Text(value, style: textStyle),
        ],
      ),
    );
  }
}