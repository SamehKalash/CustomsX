import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark;
    final Color darkBackground = const Color(0xFF1A120B);
    final Color cardColor = isDarkMode ? const Color(0xFF3C2A21) : Colors.white;
    final Color textColor = isDarkMode ? const Color(0xFFF5F5DC) : darkBackground;
    final Color accentColor = const Color(0xFFD4A373);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Terms of Service',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20.sp,
            color: textColor,
          ),
        ),
        backgroundColor: isDarkMode ? darkBackground : Colors.white,
        iconTheme: IconThemeData(color: textColor),
        elevation: 2,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode
                ? [const Color(0xFF1A120B), const Color(0xFF3C2A21), const Color(0xFF1A120B)]
                : [Colors.white, const Color(0xFFF5F5DC), Colors.white],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(maxWidth: 650.w),
              padding: EdgeInsets.all(20.w),
              child: Material(
                color: cardColor,
                borderRadius: BorderRadius.circular(18.r),
                elevation: 6,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 28.h, horizontal: 22.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Icon(Icons.policy_rounded, color: accentColor, size: 48.w),
                      ),
                      SizedBox(height: 16.h),
                      Center(
                        child: Text(
                          'Welcome to CustomsX Terms of Service',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp,
                            color: textColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 18.h),
                      Divider(color: accentColor.withOpacity(0.3), thickness: 1.2),
                      SizedBox(height: 18.h),
                      Text(
                        'Please read these terms and conditions carefully before using our application. By using CustomsX, you agree to be bound by these Terms of Service ("Terms") and our Privacy Policy. These Terms apply to all users, including companies and their representatives.',
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: textColor.withOpacity(0.85),
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 28.h),

                      // Section builder for consistency
                      _section('1. Acceptance of Terms',
                          'By accessing or using CustomsX, you agree to be bound by these Terms. If you disagree with any part of the Terms, you may not access the service.',
                          textColor, accentColor),
                      _section('2. Description of Service',
                          'CustomsX is a platform designed to assist companies in submitting documentation to the Egyptian Customs Authority, managing customs declarations, appeals, and payments. Features include document storage, Priority Clearance Pro, and Compliance Audit Service, subject to availability and applicable fees.',
                          textColor, accentColor),
                      _section('3. Eligibility',
                          'Users must be at least 18 years old and have the legal authority to represent their company. Companies must provide a valid Tax Identification Number (TIN) and comply with Egyptian customs regulations. We may refuse service at our discretion.',
                          textColor, accentColor),
                      _section('4. Account Registration and Company Details',
                          'You must register and provide accurate company details (e.g., name, TIN, address). You are responsible for maintaining account confidentiality. Report unauthorized use to support@customsx.com immediately.',
                          textColor, accentColor),
                      _section('5. Payment Terms',
                          'Premium features (e.g., Priority Clearance Pro, Compliance Audit Service) require payment in Egyptian Pounds (EGP), non-refundable unless stated. Subscriptions auto-renew unless canceled. Late payments may suspend services.',
                          textColor, accentColor),
                      _section('6. User Responsibilities',
                          'You agree to submit accurate documentation, comply with Egyptian customs laws, and not use the app for illegal activities. You are liable for non-compliant submissions.',
                          textColor, accentColor),
                      _section('7. Intellectual Property',
                          'All content and software in CustomsX are owned by [Your Company Name]. Reproduction or modification without permission is prohibited, except for app use.',
                          textColor, accentColor),
                      _section('8. Third-Party Services',
                          'The app may use third-party services (e.g., Nafeza, Fawry). We are not liable for their performance. Their terms apply to your interactions.',
                          textColor, accentColor),
                      _section('9. Limitation of Liability',
                          'We are not liable for indirect damages from app use, including customs delays. Our liability is limited to amounts paid in the last 12 months.',
                          textColor, accentColor),
                      _section('10. Termination',
                          'We may terminate your account for violations. Upon termination, you lose access to data. Cancel by contacting support@customsx.com, subject to fees.',
                          textColor, accentColor),
                      _section('11. Data Protection and Privacy',
                          'We process data per our Privacy Policy and Egypt’s Law No. 151 of 2020. Data may be shared with the Egyptian Customs Authority. You consent by using the app.',
                          textColor, accentColor),
                      _section('12. Changes to Terms',
                          'We may update these Terms. Changes will be posted with an effective date. Continued use constitutes acceptance.',
                          textColor, accentColor),
                      _section('13. Governing Law',
                          'These Terms are governed by Egyptian law. Disputes are resolved in Cairo courts.',
                          textColor, accentColor),
                      _section('14. Contact Us',
                          'For questions, contact: Email: support@customsx.com | Phone: +20 2 1234 5678 | Address: [Your Address], Cairo, Egypt',
                          textColor, accentColor),

                      SizedBox(height: 32.h),
                      Divider(color: accentColor.withOpacity(0.3), thickness: 1.2),
                      SizedBox(height: 10.h),
                      Center(
                        child: Text(
                          '© 2025 CustomsX. All rights reserved.',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: textColor.withOpacity(0.6),
                          ),
                        ),
                      
                        ),
                      
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _section(String title, String content, Color textColor, Color accentColor) {
    return Padding(
      padding: EdgeInsets.only(bottom: 22.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
              color: accentColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            content,
            style: TextStyle(
              fontSize: 14.sp,
              color: textColor.withOpacity(0.85),
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}