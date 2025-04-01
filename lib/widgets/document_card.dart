import 'package:flutter/material.dart';
import '../models/document.dart';

class DocumentCard extends StatelessWidget {
  final Document document;

  const DocumentCard({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.description,
            size: 48,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(height: 8),
          Text(
            document.name,
            style: Theme.of(context).textTheme.titleMedium,
            overflow: TextOverflow.ellipsis,
          ),
          Text(document.type, style: Theme.of(context).textTheme.bodySmall),
          Text(document.date, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
