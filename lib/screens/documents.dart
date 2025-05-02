import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../models/document.dart';

class DocumentManagementScreen extends StatefulWidget {
  const DocumentManagementScreen({super.key});

  @override
  _DocumentManagementScreenState createState() =>
      _DocumentManagementScreenState();
}

class _DocumentManagementScreenState extends State<DocumentManagementScreen> {
  final List<Document> _documents = [
    Document(name: 'Invoice_123.pdf', type: 'Invoice', date: '2024-02-15'),
    Document(name: 'COO_456.pdf', type: 'Certificate', date: '2024-02-14'),
  ];

  // Define the yellowish color to match the dashboard theme
  static const Color yellowishColor = Color(0xFFE3B505);

  void _uploadDocument(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'jpg'],
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.single;
      final now = DateTime.now();

      setState(() {
        _documents.add(
          Document(
            name: file.name,
            type: 'Uploaded Document',
            date: '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
          ),
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File "${file.name}" uploaded successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No file selected.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Management'),
        backgroundColor: isDarkMode ? Colors.grey[900] : yellowishColor,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _uploadDocument(context),
        backgroundColor: isDarkMode ? Colors.grey[800] : yellowishColor,
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
          isDarkMode: isDarkMode,
        ),
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