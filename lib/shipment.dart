import 'package:flutter/material.dart';

class ShipmentsPage extends StatelessWidget {
  const ShipmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shipments'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildShipmentsList(),
            const SizedBox(height: 24),
            _buildFileSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildShipmentsList() {
    final shipments = [
      {
        'acid': '2024-0123',
        'description': 'Electronics from Shanghai',
        'date': '2024-02-15',
      },
      {
        'acid': '2024-0124',
        'description': 'Textiles from Mumbai',
        'date': '2024-02-14',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Active Shipments',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: shipments.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final shipment = shipments[index];
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.local_shipping, color: Colors.blue),
              title: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'ACID: ${shipment['acid']}\n',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TextSpan(
                      text: shipment['description'],
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),
              trailing: Text(
                shipment['date']!,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFileSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Files',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          icon: const Icon(Icons.upload),
          label: const Text('Upload Documents'),
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
      ],
    );
  }
}
