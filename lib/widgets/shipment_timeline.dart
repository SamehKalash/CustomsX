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
          (context, index) =>
              _buildTimelineItem(context, statuses[index], index),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context,
    ShipmentStatus status,
    int index,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Icon(
                status.isCurrent ? Icons.gps_fixed : Icons.check_circle,
                color:
                    status.isCurrent
                        ? (isDarkMode ? Colors.blue[300] : Colors.blue)
                        : (isDarkMode ? Colors.green[300] : Colors.green),
                size: 24,
              ),
              if (index != statuses.length - 1)
                Container(
                  width: 2,
                  height: 50,
                  color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Card(
              color: isDarkMode ? Colors.grey[850] : Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      status.event,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${status.date} ${status.time}',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.grey[600],
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
