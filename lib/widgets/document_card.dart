import 'package:flutter/material.dart';
import '../models/document.dart';

class DocumentCard extends StatelessWidget {
  final Document document;

  const DocumentCard({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      color:
          isDarkMode
              ? Colors.grey[850]
              : Colors.white, // Adjust card background
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          12,
        ), // Rounded corners for better UI
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.description,
                size: 48,
                color:
                    Theme.of(
                      context,
                    ).colorScheme.secondary, // Use theme's secondary color
              ),
              const SizedBox(height: 8),
              Text(
                document.name,
                style: TextStyle(
                  color:
                      isDarkMode
                          ? Colors.white
                          : Colors.black, // Adjust text color
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1, // Limit to one line
              ),
              const SizedBox(height: 4),
              Text(
                document.type,
                style: TextStyle(
                  color:
                      isDarkMode
                          ? Colors.white70
                          : Colors.grey[600], // Subtle text color
                ),
              ),
              const SizedBox(height: 4),
              Text(
                document.date,
                style: TextStyle(
                  color:
                      isDarkMode
                          ? Colors.white70
                          : Colors.grey[600], // Subtle text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
