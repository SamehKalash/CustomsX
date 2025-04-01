import 'package:flutter/material.dart';
import '../widgets/document_card.dart';
import '../models/document.dart';

class DocumentManagementScreen extends StatelessWidget {
  const DocumentManagementScreen({super.key});

  final List<Document> _documents = const [
    Document(name: 'Invoice_123.pdf', type: 'Invoice', date: '2024-02-15'),
    Document(name: 'COO_456.pdf', type: 'Certificate', date: '2024-02-14'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Document Management')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _uploadDocument(context),
        child: const Icon(Icons.upload),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _documents.length,
        itemBuilder:
            (context, index) => DocumentCard(document: _documents[index]),
      ),
    );
  }

  void _uploadDocument(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Upload Document'),
            content: const Text('File picker functionality to be implemented'),
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
