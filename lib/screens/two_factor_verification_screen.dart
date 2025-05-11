import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../services/api_service.dart';
import '../providers/user_provider.dart';

class TwoFactorVerificationScreen extends StatefulWidget {
  final String userId;

  const TwoFactorVerificationScreen({
    super.key,
    required this.userId,
  });

  @override
  State<TwoFactorVerificationScreen> createState() => _TwoFactorVerificationScreenState();
}

class _TwoFactorVerificationScreenState extends State<TwoFactorVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tokenController = TextEditingController();
  bool _isSubmitting = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  Future<void> _verify2FA() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = '';
    });

    try {
      final response = await ApiService.verify2FALogin(
        userId: widget.userId,
        token: _tokenController.text.trim(),
      );

      if (mounted) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(response['user']);
        
        Navigator.of(context).pushReplacementNamed('/dashboard');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = const Color(0xFFD4A373);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Two-Factor Verification',
          style: TextStyle(
            fontSize: 20.sp,
            color: isDarkMode ? Color(0xFFF5F5DC) : Color(0xFF1A120B),
          ),
        ),
        backgroundColor: isDarkMode ? Color(0xFF3C2A21) : Colors.white,
        iconTheme: IconThemeData(
          color: isDarkMode ? Color(0xFFF5F5DC) : Color(0xFF1A120B),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode
                ? [
                    Color(0xFF3C2A21),
                    Color(0xFF1A120B),
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
          padding: EdgeInsets.all(24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40.h),
                Icon(
                  Icons.security,
                  size: 80.r,
                  color: primaryColor,
                ),
                SizedBox(height: 24.h),
                Text(
                  'Two-Factor Authentication',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Color(0xFFF5F5DC) : Color(0xFF1A120B),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Enter the 6-digit verification code from your authenticator app',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isDarkMode ? Color(0xFFF5F5DC).withOpacity(0.8) : Color(0xFF1A120B).withOpacity(0.7),
                  ),
                ),
                SizedBox(height: 40.h),
                TextFormField(
                  controller: _tokenController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: isDarkMode
                        ? Colors.white.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    hintText: '000000',
                    hintStyle: TextStyle(
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.3)
                          : Colors.black.withOpacity(0.3),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                        color: const Color(0xFFD4A373),
                        width: 1.w,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: isDarkMode ? Colors.white : Colors.black,
                    letterSpacing: 8,
                    fontWeight: FontWeight.w500,
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the verification code';
                    }
                    if (value.length != 6) {
                      return 'Code must be 6 digits';
                    }
                    return null;
                  },
                ),
                if (_errorMessage.isNotEmpty) ...[
                  SizedBox(height: 16.h),
                  Text(
                    _errorMessage,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                SizedBox(height: 32.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _verify2FA,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      elevation: 0,
                    ),
                    child: _isSubmitting
                        ? SizedBox(
                            height: 20.r,
                            width: 20.r,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.w,
                            ),
                          )
                        : Text(
                            'Verify',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 16.h),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Back to Login',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 