import 'package:flutter/material.dart';
import '../models/shipment.dart';

class ShipmentTimeline extends StatelessWidget {
  final List<ShipmentStatus> statuses;

  const ShipmentTimeline({super.key, required this.statuses});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: statuses.length,
      itemBuilder:
          (context, index) => _buildTimelineItem(statuses[index], index),
    );
  }

  Widget _buildTimelineItem(ShipmentStatus status, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              status.isCurrent ? Icons.gps_fixed : Icons.check_circle,
              color: status.isCurrent ? Colors.blue : Colors.green,
            ),
            if (index != statuses.length - 1)
              Container(width: 2, height: 50, color: Colors.grey[300]),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                status.event,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('${status.date} ${status.time}'),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}
