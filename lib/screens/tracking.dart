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
    return Scaffold(
      appBar: AppBar(title: const Text('Shipment Tracking')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Enter tracking number',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  onPressed: () => _scanBarcode(context),
                ),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(child: ShipmentTimeline(statuses: _statuses)),
        ],
      ),
    );
  }

  void _scanBarcode(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Barcode Scanning'),
            content: const Text('Scanner functionality to be implemented'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }
}
