import 'package:flutter/material.dart';

class LanguageSelector extends StatefulWidget {
  const LanguageSelector({super.key});

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  final List<Map<String, String>> _languages = [
    {'flag': '🇬🇧', 'name': 'English'},
    {'flag': '🇪🇬', 'name': 'Arabic'},
    {'flag': '🇩🇪', 'name': 'German'},
    {'flag': '🇮🇹', 'name': 'Italian'},
    {'flag': '🇰🇷', 'name': 'Korean'},
    {'flag': '🇳🇴', 'name': 'Norwegian'},
    {'flag': '🇵🇱', 'name': 'Polish'},
  ];

  String _selectedLanguage = 'English';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredLanguages = _languages
        .where((lang) =>
            lang['name']!.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Choose the language',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Find a language',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Language List
          Expanded(
            child: ListView.builder(
              itemCount: filteredLanguages.length,
              itemBuilder: (context, index) {
                final language = filteredLanguages[index];
                return ListTile(
                  leading: Text(
                    language['flag']!,
                    style: const TextStyle(fontSize: 24),
                  ),
                  title: Text(
                    language['name']!,
                    style: const TextStyle(fontSize: 16),
                  ),
                  trailing: _selectedLanguage == language['name']
                      ? const Icon(Icons.check_circle, color: Colors.blue)
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedLanguage = language['name']!;
                    });
                  },
                );
              },
            ),
          ),

          // Continue Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/splash');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Keep going',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}