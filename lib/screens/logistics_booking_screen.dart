import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

class LogisticsBookingScreen extends StatefulWidget {
  final String declarationId;

  const LogisticsBookingScreen({Key? key, required this.declarationId}) : super(key: key);

  @override
  State<LogisticsBookingScreen> createState() => _LogisticsBookingScreenState();
}

class _LogisticsBookingScreenState extends State<LogisticsBookingScreen> {
  String? _selectedCarrier; // State variable for selected carrier

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    final Color primaryColor = const Color(0xFFD4A373);
    final Color backgroundColor = isDarkMode ? const Color(0xFF1A120B) : Colors.white;
    final Color cardColor = isDarkMode ? const Color(0xFF3C2A21) : Colors.white;
    final Color textColor = isDarkMode ? const Color(0xFFF5F5DC) : const Color(0xFF1A120B);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryColor),
        title: Text(
          "Arrange Transport",
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAddressField("Pickup Location", "Customs Warehouse, Port Said", textColor, cardColor),
            const SizedBox(height: 16),
            _buildAddressField("Delivery Location", "Company Warehouse, Cairo", textColor, cardColor),
            const SizedBox(height: 16),
            _buildCarrierSelector(textColor, cardColor),
            const SizedBox(height: 24),
            _buildQuoteCard(cardColor, textColor),
            const Spacer(),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: _selectedCarrier != null
                    ? () => _confirmBooking(context)
                    : null, // Disable button if no carrier is selected
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedCarrier != null
                      ? primaryColor
                      : primaryColor.withOpacity(0.5), // Dim button if disabled
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  "Book Transport",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressField(String label, String placeholder, Color textColor, Color cardColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
            filled: true,
            fillColor: cardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: textColor.withOpacity(0.2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: textColor.withOpacity(0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: textColor.withOpacity(0.6)),
            ),
          ),
          style: TextStyle(color: textColor),
        ),
      ],
    );
  }

  Widget _buildCarrierSelector(Color textColor, Color cardColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Carrier",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedCarrier,
          items: const [
            DropdownMenuItem(value: "DHL", child: Text("DHL")),
            DropdownMenuItem(value: "Aramex", child: Text("Aramex")),
            DropdownMenuItem(value: "Local Provider", child: Text("Local Provider")),
          ],
          onChanged: (value) {
            setState(() {
              _selectedCarrier = value; // Update selected carrier
            });
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: cardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: textColor.withOpacity(0.2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: textColor.withOpacity(0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: textColor.withOpacity(0.6)),
            ),
          ),
          style: TextStyle(color: textColor),
          dropdownColor: cardColor,
        ),
      ],
    );
  }

  Widget _buildQuoteCard(Color cardColor, Color textColor) {
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Estimated Cost: \$2500",
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "ETA: 2-3 days",
              style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 14),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                _selectedCarrier ?? "Select a carrier",
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmBooking(BuildContext context) {
    // Navigate to Payments Screen
    Navigator.pushNamed(context, '/payments', arguments: {
      'amount': 2500,
      'paymentType': "Transport Fee ($_selectedCarrier)",
    });
  }
}