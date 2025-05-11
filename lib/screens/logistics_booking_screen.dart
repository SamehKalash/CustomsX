import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

class LogisticsBookingScreen extends StatelessWidget {
  final String declarationId;

  const LogisticsBookingScreen({Key? key, required this.declarationId}) : super(key: key);

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
            const SizedBox(height: 16),
            _buildQuoteCard(cardColor, textColor),
            const Spacer(),
            ElevatedButton(
              onPressed: () => _confirmBooking(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 14), // Adjusted padding for better proportions
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Book Transport",
                style: TextStyle(
                  fontSize: 14, // Reduced font size for better balance
                  color: Colors.white,
                  fontWeight: FontWeight.w600, // Slightly lighter weight for a cleaner look
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
          items: const [
            DropdownMenuItem(value: "DHL", child: Text("DHL")),
            DropdownMenuItem(value: "Aramex", child: Text("Aramex")),
            DropdownMenuItem(value: "Local Provider", child: Text("Local Provider")),
          ],
          onChanged: (value) {},
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
      child: ListTile(
        title: Text(
          "Estimated Cost: \$2500",
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          "ETA: 2-3 days",
          style: TextStyle(color: textColor.withOpacity(0.8)),
        ),
        trailing: Text(
          "DHL",
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _confirmBooking(BuildContext context) {
    // Navigate to Payments Screen
    Navigator.pushNamed(context, '/payments', arguments: {
      'amount': 2500,
      'paymentType': "Transport Fee",
    });
  }
}