import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import './payment_method.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color:
                isDarkMode ? const Color(0xFFF5F5DC) : const Color(0xFF1A120B),
          ),
        ),
        backgroundColor:
            isDarkMode ? const Color(0xFF3C2A21) : const Color(0xFFD4A373),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, size: 24.w),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            _buildSectionHeader('Appearance', isDarkMode),
            _buildSettingsCard(
              context,
              icon: Icons.dark_mode_rounded,
              title: 'Dark Mode',
              trailing: Switch(
                value: isDarkMode,
                onChanged: (value) => themeProvider.toggleTheme(value),
                activeColor: const Color(0xFFD4A373),
              ),
            ),
            _buildDivider(isDarkMode),

            _buildSectionHeader('Language & Region', isDarkMode),
            _buildSettingsCard(
              context,
              icon: Icons.language_rounded,
              title: 'App Language',
              subtitle: 'English (United States)',
              onTap: () => _showLanguageSelector(context),
            ),
            _buildSettingsCard(
              context,
              icon: Icons.flag_rounded,
              title: 'Country/Region',
              subtitle: 'Egypt',
              onTap: () => _showRegionSelector(context),
            ),
            _buildDivider(isDarkMode),

            _buildSectionHeader('Account', isDarkMode),
            _buildSettingsCard(
              context,
              icon: Icons.security_rounded,
              title: 'Security',
              onTap: () => _navigateToSecurity(context),
            ),
            _buildSettingsCard(
              context,
              icon: Icons.payment_rounded,
              title: 'Payment Methods',
              onTap: () => _navigateToPayments(context),
            ),
            _buildDivider(isDarkMode),

            _buildSectionHeader('Support', isDarkMode),
            _buildSettingsCard(
              context,
              icon: Icons.help_rounded,
              title: 'Help Center',
              onTap: () => _openHelpCenter(context),
            ),
            _buildSettingsCard(
              context,
              icon: Icons.description_rounded,
              title: 'Terms of Service',
              onTap: () => _openTerms(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDarkMode) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color:
                isDarkMode ? const Color(0xFFF5F5DC) : const Color(0xFF1A120B),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final isDarkMode =
        Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark;

    return Card(
      margin: EdgeInsets.only(bottom: 8.h),
      color: isDarkMode ? const Color(0xFF3C2A21) : Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.w),
        leading: Icon(icon, size: 24.w, color: const Color(0xFFD4A373)),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color:
                isDarkMode ? const Color(0xFFF5F5DC) : const Color(0xFF1A120B),
          ),
        ),
        subtitle:
            subtitle != null
                ? Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color:
                        isDarkMode
                            ? const Color(0xFFF5F5DC).withOpacity(0.6)
                            : const Color(0xFF1A120B).withOpacity(0.6),
                  ),
                )
                : null,
        trailing:
            trailing ??
            Icon(
              Icons.chevron_right_rounded,
              color:
                  isDarkMode
                      ? const Color(0xFFF5F5DC).withOpacity(0.4)
                      : const Color(0xFF1A120B).withOpacity(0.4),
            ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildDivider(bool isDarkMode) {
    return Divider(
      height: 32.h,
      color: isDarkMode ? Colors.white12 : Colors.grey.withOpacity(0.1),
      thickness: 1,
    );
  }

  void _showLanguageSelector(BuildContext context) {
    final isDarkMode =
        Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF3C2A21) : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.r),
                topRight: Radius.circular(24.r),
              ),
            ),
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 48.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  'Select Language',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color:
                        isDarkMode
                            ? const Color(0xFFF5F5DC)
                            : const Color(0xFF1A120B),
                  ),
                ),
                SizedBox(height: 16.h),
                _buildLanguageOption(context, 'English', 'US', isDarkMode),
                _buildLanguageOption(context, 'العربية', 'AR', isDarkMode),
                _buildLanguageOption(context, 'Français', 'FR', isDarkMode),
                _buildLanguageOption(context, 'Español', 'ES', isDarkMode),
                SizedBox(height: 24.h),
              ],
            ),
          ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String language,
    String code,
    bool isDarkMode,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: const Color(0xFFD4A373).withOpacity(0.2),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: Text(
            code,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFD4A373),
            ),
          ),
        ),
      ),
      title: Text(
        language,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: isDarkMode ? const Color(0xFFF5F5DC) : const Color(0xFF1A120B),
        ),
      ),
      onTap: () => Navigator.pop(context),
    );
  }

  void _showRegionSelector(BuildContext context) {
    // Implement region selector
  }

  void _navigateToSecurity(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => Scaffold(
              appBar: AppBar(
                title: const Text('Security Settings'),
                backgroundColor:
                    Provider.of<ThemeProvider>(context).themeMode ==
                            ThemeMode.dark
                        ? const Color(0xFF3C2A21)
                        : const Color(0xFFD4A373),
              ),
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
    // Implement help center
  }

  void _openTerms(BuildContext context) {
    // Implement terms of service
  }
}
