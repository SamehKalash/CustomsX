import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import 'vehicle_tariff_result_screen.dart';

class VehicleTariffEntryScreen extends StatefulWidget {
  const VehicleTariffEntryScreen({super.key});

  @override
  _VehicleTariffEntryScreenState createState() =>
      _VehicleTariffEntryScreenState();
}

class _VehicleTariffEntryScreenState extends State<VehicleTariffEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _engineVolumeController = TextEditingController();
  final TextEditingController _invoiceValueController = TextEditingController();
  final TextEditingController _shippingCostController = TextEditingController();
  final TextEditingController _otherExpensesController = TextEditingController();
  final TextEditingController _yearOfManufactureController =
      TextEditingController();

  String _selectedVehicleType = 'Choose';
  String _selectedCountryOption = 'Other countries';

  void _calculateTariff() {
    if (_formKey.currentState!.validate()) {
      // Perform tariff calculation logic
      double engineVolume = double.parse(_engineVolumeController.text);
      double invoiceValue = double.parse(_invoiceValueController.text);
      double shippingCost = double.parse(_shippingCostController.text);
      double otherExpenses = double.parse(_otherExpensesController.text);
      int yearOfManufacture = int.parse(_yearOfManufactureController.text);

      // Example calculation logic
      double tariff = (invoiceValue + shippingCost + otherExpenses) * 0.1; // 10% tariff rate

      // Navigate to the result screen with calculated data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VehicleTariffResultScreen(
            engineVolume: engineVolume,
            invoiceValue: invoiceValue,
            shippingCost: shippingCost,
            otherExpenses: otherExpenses,
            yearOfManufacture: yearOfManufacture,
            tariff: tariff,
            vehicleType: _selectedVehicleType,
            countryOption: _selectedCountryOption,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields correctly.')),
      );
    }
  }

  void _resetForm() {
    setState(() {
      _engineVolumeController.clear();
      _invoiceValueController.clear();
      _shippingCostController.clear();
      _otherExpensesController.clear();
      _yearOfManufactureController.clear();
      _selectedVehicleType = 'Choose';
      _selectedCountryOption = 'Other countries';
    });
  }

  Future<void> _selectYear(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Body text color
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _yearOfManufactureController.text = picked.year.toString();
      });
    }
  }

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
        title: const Text('Vehicle Tariff Entry'),
        backgroundColor: backgroundColor,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Container(
        color: backgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedVehicleType,
                items: ['Choose', 'Car', 'Truck', 'Motorcycle']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type, style: TextStyle(color: textColor)),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedVehicleType = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Type of Vehicle',
                  labelStyle: TextStyle(color: textColor),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == 'Choose') {
                    return 'Please select a vehicle type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _engineVolumeController,
                decoration: InputDecoration(
                  labelText: 'Engine Volume (cm³)',
                  labelStyle: TextStyle(color: textColor),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter engine volume';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _invoiceValueController,
                decoration: InputDecoration(
                  labelText: 'Invoice Value (USD)',
                  labelStyle: TextStyle(color: textColor),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter invoice value';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _shippingCostController,
                decoration: InputDecoration(
                  labelText: 'Shipping Cost (USD)',
                  labelStyle: TextStyle(color: textColor),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter shipping cost';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _otherExpensesController,
                decoration: InputDecoration(
                  labelText: 'Other Expenses (USD)',
                  labelStyle: TextStyle(color: textColor),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter other expenses';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _yearOfManufactureController,
                decoration: InputDecoration(
                  labelText: 'Year of Manufacture',
                  labelStyle: TextStyle(color: textColor),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectYear(context),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter year of manufacture';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid year';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About the country of origin (production) and the country of dispatch',
                    style: TextStyle(color: textColor),
                  ),
                  RadioListTile<String>(
                    title: Text('Other countries', style: TextStyle(color: textColor)),
                    value: 'Other countries',
                    groupValue: _selectedCountryOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedCountryOption = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text(
                      'It is produced in and imported from a country with a free trade agreement',
                      style: TextStyle(color: textColor),
                    ),
                    value: 'Free trade agreement',
                    groupValue: _selectedCountryOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedCountryOption = value!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _calculateTariff,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('Calculate'),
                  ),
                  ElevatedButton(
                    onPressed: _resetForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('Reset'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}