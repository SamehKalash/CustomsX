import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

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
          'About Us',
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
              constraints: BoxConstraints(maxWidth: 500.w),
              padding: EdgeInsets.all(20.w),
              child: Material(
                color: cardColor,
                borderRadius: BorderRadius.circular(18.r),
                elevation: 6,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.info_outline_rounded, color: accentColor, size: 48.w),
                      SizedBox(height: 18.h),
                      Text(
                        'Welcome to CustomsX',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.sp,
                          color: textColor,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Egyptian Customs Authority',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17.sp,
                          color: accentColor,
                          letterSpacing: 0.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 18.h),
                      Divider(color: accentColor.withOpacity(0.3), thickness: 1.2),
                      SizedBox(height: 18.h),
                      Text(
                        'This application has been developed to provide access to e-Customs services rendered by the Egyptian Customs Authority from mobile devices. Both Egyptian companies and foreign nationals can use this application. The application allows users to submit tariff documentation, manage customs declarations, appeal decisions, calculate duties, and access premium services like Priority Clearance Pro and Compliance Audit Service.\n\n'
                        'The Egyptian Customs Authority, in collaboration with CustomsX, is planning to add more services and data tools to this application in the near future.\n\n'
                        'Please do not hesitate to contact us with your comments and suggestions at support@customsx.com.',
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: textColor.withOpacity(0.87),
                          height: 1.6,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 32.h),
                      Divider(color: accentColor.withOpacity(0.3), thickness: 1.2),
                      SizedBox(height: 12.h),
                      Text(
                        '© 2025 CustomsX. All rights reserved.',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: textColor.withOpacity(0.6),
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Version 1.0',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: textColor.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
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
}