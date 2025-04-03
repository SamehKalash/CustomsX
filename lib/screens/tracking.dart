import 'package:flutter/material.dart';
import '../widgets/shipment_timeline.dart';
import '../models/shipment.dart';

class ShipmentTrackingScreen extends StatelessWidget {
  const ShipmentTrackingScreen({super.key});

  final List<ShipmentStatus> _statuses = const [
    ShipmentStatus(
      event: 'Departed HK',
      date: '2024-02-15',
      time: '14:30',
      isCompleted: true,
    ),
    ShipmentStatus(
      event: 'Customs Hold',
      date: '2024-02-16',
      time: '09:15',
      isCompleted: false,
      isCurrent: true,
    ),
    ShipmentStatus(
      event: 'Out for Delivery',
      date: 'Pending',
      time: '',
      isCompleted: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shipment Tracking'),
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.blue,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.black, // Adjust icon color
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Enter tracking number',
                hintStyle: TextStyle(
                  color:
                      isDarkMode
                          ? Colors.white70
                          : Colors.grey, // Adjust hint text color
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.qr_code_scanner,
                    color:
                        isDarkMode
                            ? Colors.white
                            : Colors.black, // Adjust icon color
                  ),
                  onPressed: () => _scanBarcode(context),
                ),
                border: const OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color:
                        isDarkMode
                            ? Colors.white70
                            : Colors.grey, // Adjust border color
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color:
                        isDarkMode
                            ? Colors.white
                            : Colors.blue, // Adjust focused border color
                  ),
                ),
              ),
              style: TextStyle(
                color:
                    isDarkMode
                        ? Colors.white
                        : Colors.black, // Adjust input text color
              ),
            ),
          ),
          Expanded(
            child: ShipmentTimeline(
              statuses: _statuses,
            ),
          ),
        ],
      ),
    );
  }

  void _scanBarcode(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor:
                isDarkMode
                    ? Colors.grey[900]
                    : Colors.white, // Adjust dialog background
            title: Text(
              'Barcode Scanning',
              style: TextStyle(
                color:
                    isDarkMode
                        ? Colors.white
                        : Colors.black, // Adjust title color
              ),
            ),
            content: Text(
              'Scanner functionality to be implemented',
              style: TextStyle(
                color:
                    isDarkMode
                        ? Colors.white70
                        : Colors.grey, // Adjust content color
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'OK',
                  style: TextStyle(
                    color:
                        isDarkMode
                            ? Colors.blue[300]
                            : Colors.blue, // Adjust button color
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
