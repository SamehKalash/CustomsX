import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'contact_us.dart';

class SupportScreen extends StatefulWidget {
  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  bool _showLocalFAQ = false;

  // Open official FAQ page
  void _openFAQ() async {
    const url = 'https://customs.gov.eg/faq'; // ✅ Official FAQ link
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not open FAQ page')));
    }
  }

  // Open contact form
  void _openContactUs(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContactUsScreen()),
    );
  }

  // Local FAQ data
  final Map<String, List<Map<String, String>>> faqData = {
    "Payments": [
      {
        "question": "How do I make a payment?",
        "answer": "Go to Payments section",
      },
      {"question": "Payment failed?", "answer": "Check card details"},
    ],
    "Calculations": [
      {
        "question": "How are duties calculated?",
        "answer": "Based on item value",
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Support')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _showLocalFAQ ? _buildLocalFAQ() : _buildSupportOptions(context),
      ),
    );
  }

  Widget _buildSupportOptions(BuildContext context) {
    return Column(
      children: [
        _buildSupportCard(
          icon: Icons.help_outline,
          title: 'FAQ (Web)',
          subtitle: 'Official customs FAQ',
          onTap: _openFAQ,
          color: Colors.blue,
        ),
        _buildSupportCard(
          icon: Icons.library_books,
          title: 'FAQ (Local)',
          subtitle: 'Common questions',
          onTap: () => setState(() => _showLocalFAQ = true),
          color: Colors.teal,
        ),
        _buildSupportCard(
          icon: Icons.email,
          title: 'Contact Us',
          subtitle: 'Send us a message',
          onTap: () => _openContactUs(context),
          color: Colors.green,
        ),
      ],
    );
  }

  Widget _buildLocalFAQ() {
    return ListView(
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => setState(() => _showLocalFAQ = false),
            ),
            Text(
              "FAQs",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        ...faqData.entries.map((entry) {
          return ExpansionTile(
            title: Text(entry.key),
            children:
                entry.value.map((faq) {
                  return ListTile(
                    title: Text(faq['question']!),
                    subtitle: Text(faq['answer']!),
                  );
                }).toList(),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildSupportCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: onTap,
      ),
    );
  }
}
