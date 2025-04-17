// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  String? _emailError;
  final Color _primaryColor = const Color(0xFFD4A373);
  final Color _darkBackground = const Color(0xFF1A120B);

  void _resetPassword() {
    final email = _emailController.text.trim();
    setState(() {
      _emailError =
          email.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email)
              ? 'Enter a valid email address'
              : null;
    });

    if (_emailError == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Password reset link sent!',
            style: TextStyle(fontSize: 14.sp),
          ),
          backgroundColor: _primaryColor,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Forgot Password',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: isDarkMode ? Color(0xFFF5F5DC) : _darkBackground,
          ),
        ),
        backgroundColor: isDarkMode ? _darkBackground : Colors.white,
        elevation: 4,
        iconTheme: IconThemeData(
          color: isDarkMode ? Color(0xFFF5F5DC) : _darkBackground,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors:
                isDarkMode
                    ? [
                      _darkBackground,
                      Color(0xFF3C2A21),
                      Color(0xFFD4A373).withOpacity(0.2),
                    ]
                    : [
                      Colors.white,
                      Color(0xFFF5F5DC).withOpacity(0.6),
                      Color(0xFFD4A373).withOpacity(0.1),
                    ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter your email to reset password',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: isDarkMode ? Color(0xFFF5F5DC) : _darkBackground,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 30.h),
              TextFormField(
                controller: _emailController,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDarkMode ? Color(0xFFF5F5DC) : _darkBackground,
                ),
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  labelStyle: TextStyle(
                    fontSize: 14.sp,
                    color:
                        isDarkMode
                            ? Color(0xFFF5F5DC).withOpacity(0.7)
                            : _darkBackground.withOpacity(0.6),
                  ),
                  prefixIcon: Icon(
                    Icons.email_rounded,
                    color: _primaryColor,
                    size: 24.w,
                  ),
                  filled: true,
                  fillColor: isDarkMode ? Color(0xFF3C2A21) : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: _primaryColor, width: 1.w),
                  ),
                  errorText: _emailError,
                  errorStyle: TextStyle(fontSize: 12.sp),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 40.h),
              ElevatedButton(
                onPressed: _resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 4,
                ),
                child: Text(
                  'Send Link',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
