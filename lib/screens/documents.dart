import 'package:flutter/material.dart';
import '../models/document.dart';

class DocumentManagementScreen extends StatelessWidget {
  const DocumentManagementScreen({super.key});

  final List<Document> _documents = const [
    Document(name: 'Invoice_123.pdf', type: 'Invoice', date: '2024-02-15'),
    Document(name: 'COO_456.pdf', type: 'Certificate', date: '2024-02-14'),
  ];

  // Define the yellowish color to match the dashboard theme
  static const Color yellowishColor = Color(0xFFE3B505);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Management'),
        backgroundColor: isDarkMode ? Colors.grey[900] : yellowishColor,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.black, // Adjust icon color
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _uploadDocument(context),
        backgroundColor: isDarkMode ? Colors.grey[800] : yellowishColor, // Adjust FAB color
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
        itemBuilder: (context, index) => DocumentCard(
          document: _documents[index],
          isDarkMode: isDarkMode, // Pass dark mode flag to the widget
        ),
      ),
    );
  }

  void _uploadDocument(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        title: Text(
          'Upload Document',
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        ),
        content: Text(
          'File picker functionality to be implemented',
          style: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.grey,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: TextStyle(
                color: isDarkMode ? yellowishColor.withOpacity(0.8) : yellowishColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DocumentCard extends StatelessWidget {
  final Document document;
  final bool isDarkMode;

  const DocumentCard({
    super.key,
    required this.document,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              document.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              document.type,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.white70 : Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              document.date,
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? Colors.white70 : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}