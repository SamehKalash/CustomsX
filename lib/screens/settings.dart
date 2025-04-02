import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import './payment_method.dart'; 

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Appearance'),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (value) => themeProvider.toggleTheme(value),
            secondary: const Icon(Icons.dark_mode),
          ),
          const Divider(),

          _buildSectionHeader('Language & Region'),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('App Language'),
            subtitle: const Text('English (United States)'),
            onTap: () => _showLanguageSelector(context),
          ),
          ListTile(
            leading: const Icon(Icons.flag),
            title: const Text('Country/Region'),
            subtitle: const Text('Egypt'),
            onTap: () => _showRegionSelector(context),
          ),
          const Divider(),

          _buildSectionHeader('Account'),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Security'),
            onTap: () => _navigateToSecurity(context),
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Payment Methods'),
            onTap: () => _navigateToPayments(context),
          ),
          const Divider(),

          _buildSectionHeader('Support'),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help Center'),
            onTap: () => _openHelpCenter(context),
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Terms of Service'),
            onTap: () => _openTerms(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  void _showLanguageSelector(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Select Language'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                children: [
                  _buildLanguageOption(context, 'English', 'US'),
                  _buildLanguageOption(context, 'Español', 'ES'),
                  _buildLanguageOption(context, 'Français', 'FR'),
                  _buildLanguageOption(context, '日本語', 'JP'),
                ],
              ),
            ),
          ),
    );
  }

  ListTile _buildLanguageOption(
    BuildContext context,
    String language,
    String code,
  ) {
    return ListTile(
      leading: Text(code),
      title: Text(language),
      onTap: () {
        Navigator.pop(context);
        // language change logic
      },
    );
  }

  void _showRegionSelector(BuildContext context) {
    //  region selection
  }

  void _navigateToSecurity(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => Scaffold(
              appBar: AppBar(title: const Text('Security Settings')),
              body: const Center(child: Text('Security settings content')),
            ),
      ),
    );
  }

  void _navigateToPayments(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PaymentMethodsScreen(),
      ),
    );
  }

  void _openHelpCenter(BuildContext context) {
    //help center navigation
  }

  void _openTerms(BuildContext context) {
    //terms of service navigation
  }
}
