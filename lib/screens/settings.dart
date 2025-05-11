import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sccf/providers/locale_provider.dart';
import 'package:sccf/screens/about_us_screen.dart';
import 'package:sccf/screens/security_screen.dart';
import 'package:sccf/screens/terms_of_service_screen.dart';
import '../theme/theme_provider.dart';
import './payment_method.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.settings,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color:
                isDarkMode ? const Color(0xFFF5F5DC) : const Color(0xFF1A120B),
          ),
        ),
        backgroundColor: isDarkMode ? const Color(0xFF3C2A21) : Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, size: 24.w),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            _buildSectionHeader(
              AppLocalizations.of(context)!.appearance,
              isDarkMode,
            ),
            _buildSettingsCard(
              context,
              isDarkMode: isDarkMode,
              icon: Icons.dark_mode_rounded,
              title: AppLocalizations.of(context)!.darkMode,
              trailing: Switch(
                value: isDarkMode,
                onChanged: (value) => themeProvider.toggleTheme(value),
                activeColor: const Color(0xFFD4A373),
              ),
            ),
            _buildDivider(isDarkMode),

            _buildSectionHeader(
              AppLocalizations.of(context)!.language,
              isDarkMode,
            ),
            _buildSettingsCard(
              context,
              isDarkMode: isDarkMode,
              icon: Icons.language_rounded,
              title: AppLocalizations.of(context)!.appLanguage,
              subtitle:
                  'English (United States)', // You can localize this if you want
              onTap: () => _showLanguageSelector(context),
            ),
            _buildDivider(isDarkMode),

            _buildSectionHeader(
              AppLocalizations.of(context)!.account,
              isDarkMode,
            ),
            _buildSettingsCard(
              context,
              isDarkMode: isDarkMode,
              icon: Icons.security_rounded,
              title: AppLocalizations.of(context)!.security,
              onTap: () => _navigateToSecurity(context),
            ),
            _buildSettingsCard(
              context,
              isDarkMode: isDarkMode,
              icon: Icons.payment_rounded,
              title: AppLocalizations.of(context)!.paymentMethods,
              onTap: () => _navigateToPayments(context),
            ),
            _buildDivider(isDarkMode),

            _buildSectionHeader(
              AppLocalizations.of(context)!.support,
              isDarkMode,
            ),
            _buildSettingsCard(
              context,
              isDarkMode: isDarkMode,
              icon: Icons.info_outline_rounded,
              title: AppLocalizations.of(context)!.aboutUs,
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutUsScreen(),
                    ),
                  ),
            ),
            _buildSettingsCard(
              context,
              isDarkMode: isDarkMode,
              icon: Icons.description_rounded,
              title: AppLocalizations.of(context)!.termsOfService,
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
    required bool isDarkMode,
  }) {
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
        Provider.of<ThemeProvider>(context, listen: false).themeMode ==
        ThemeMode.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Builder(
        builder: (bottomSheetContext) => Container(
          // Use bottomSheetContext instead of context below!
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
                AppLocalizations.of(bottomSheetContext)!.selectLanguage,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: isDarkMode
                      ? const Color(0xFFF5F5DC)
                      : const Color(0xFF1A120B),
                ),
              ),
              SizedBox(height: 16.h),
              _buildLanguageOption(
                bottomSheetContext,
                'English',
                'US',
                isDarkMode,
                const Locale('en'),
              ),
              _buildLanguageOption(
                bottomSheetContext,
                'العربية',
                'AR',
                isDarkMode,
                const Locale('ar'),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String language,
    String code,
    bool isDarkMode,
    Locale locale,
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
      onTap: () {
        final localeProvider = Provider.of<LocaleProvider>(
          Navigator.of(context).context,
          listen: false,
        );
        localeProvider.setLocale(locale);
        Navigator.pop(context);
      },
    );
  }

  void _navigateToSecurity(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SecurityScreen()),
    );
  }

  void _navigateToPayments(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PaymentMethodsScreen()),
    );
  }

  void _openTerms(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TermsOfServiceScreen()),
    );
  }
}
