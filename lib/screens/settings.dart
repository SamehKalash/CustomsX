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
          _buildSectionHeader(context, 'Appearance'),
          SwitchListTile(
            title: Text(
              'Dark Mode',
              style: TextStyle(
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black, // Adjust color based on theme
              ),
            ),
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (value) => themeProvider.toggleTheme(value),
            secondary: Icon(
              Icons.dark_mode,
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black, // Adjust icon color
            ),
          ),
          const Divider(
            color: Colors.grey, // Use a lighter color for better visibility
            thickness: 1,
          ),

          _buildSectionHeader(context, 'Language & Region'),
          ListTile(
            leading: Icon(
              Icons.language,
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black, // Adjust color based on theme
            ),
            title: Text(
              'App Language',
              style: TextStyle(
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black, // Adjust color based on theme
              ),
            ),
            subtitle: Text(
              'English (United States)',
              style: TextStyle(
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.grey, // Adjust color based on theme
              ),
            ),
            onTap: () => _showLanguageSelector(context),
          ),
          ListTile(
            leading: Icon(
              Icons.flag,
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black, // Adjust color based on theme
            ),
            title: Text(
              'Country/Region',
              style: TextStyle(
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black, // Adjust color based on theme
              ),
            ),
            subtitle: Text(
              'Egypt',
              style: TextStyle(
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.grey, // Adjust color based on theme
              ),
            ),
            onTap: () => _showRegionSelector(context),
          ),
          const Divider(
            color: Colors.grey, // Use a lighter color for better visibility
            thickness: 1,
          ),

          _buildSectionHeader(context, 'Account'),
          ListTile(
            leading: Icon(
              Icons.security,
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black, // Adjust color
            ),
            title: Text(
              'Security',
              style: TextStyle(
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black, // Adjust color
              ),
            ),
            onTap: () => _navigateToSecurity(context),
          ),
          ListTile(
            leading: Icon(
              Icons.payment,
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black, // Adjust color
            ),
            title: Text(
              'Payment Methods',
              style: TextStyle(
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black, // Adjust color
              ),
            ),
            onTap: () => _navigateToPayments(context),
          ),
          const Divider(
            color: Colors.grey, // Use a lighter color for better visibility
            thickness: 1,
          ),

          _buildSectionHeader(context, 'Support'),
          ListTile(
            leading: Icon(
              Icons.help,
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black, // Adjust color
            ),
            title: Text(
              'Help Center',
              style: TextStyle(
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black, // Adjust color
              ),
            ),
            onTap: () => _openHelpCenter(context),
          ),
          ListTile(
            leading: Icon(
              Icons.description,
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black, // Adjust color
            ),
            title: Text(
              'Terms of Service',
              style: TextStyle(
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black, // Adjust color
              ),
            ),
            onTap: () => _openTerms(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white : Colors.grey, // Adjust color
        ),
      ),
    );
  }

  void _showLanguageSelector(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
            title: Text(
              'Select Language',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black, // Adjust color
              ),
            ),
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      leading: Text(
        code,
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black, // Adjust color
        ),
      ),
      title: Text(
        language,
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black, // Adjust color
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        // Add language change logic here
      },
    );
  }

  void _showRegionSelector(BuildContext context) {
    // Add region selection logic here
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
      MaterialPageRoute(builder: (context) => const PaymentMethodsScreen()),
    );
  }

  void _openHelpCenter(BuildContext context) {
    // Add help center navigation logic here
  }

  void _openTerms(BuildContext context) {
    // Add terms of service navigation logic here
  }
}
