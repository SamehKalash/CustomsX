import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'contact_us.dart';

class SupportScreen extends StatelessWidget {
  // Open FAQ URL
  void _openFAQ() async {
    const url = 'https://customs.gov.eg/faq';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Open contact form
  void _openContactUs(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContactUsScreen()),
    );
  }

  // Launch phone call
  void _callSupport() async {
    const phone = 'tel:+20212345678';
    if (await canLaunchUrlString(phone)) {
      await launchUrlString(phone);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Support')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // FAQ Card
            _buildSupportCard(
              icon: Icons.help_outline,
              title: 'FAQ',
              subtitle: 'Find answers to common questions',
              onTap: _openFAQ,
              color: Colors.blue,
            ),
            
            // Contact Us Card
            _buildSupportCard(
              icon: Icons.email,
              title: 'Contact Us',
              subtitle: 'Send us a message',
              onTap: () => _openContactUs(context),
              color: Colors.green,
            ),
            
            // Call Support Card
            _buildSupportCard(
              icon: Icons.phone,
              title: 'Call Support',
              subtitle: '24/7 helpline',
              onTap: _callSupport,
              color: Colors.orange,
            ),
          ],
        ),
      ),
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
      margin: EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}