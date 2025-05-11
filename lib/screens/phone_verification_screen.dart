import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../services/api_service.dart';

class PhoneVerificationScreen extends StatefulWidget {
  final String userId;
  final String phone;

  const PhoneVerificationScreen({
    super.key,
    required this.userId,
    required this.phone,
  });

  @override
  State<PhoneVerificationScreen> createState() => _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  List<TextEditingController> _codeControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  bool _isSubmitting = false;
  String _errorMessage = '';

  @override
  void dispose() {
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  Future<void> _verifyPhone() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    String code = _codeControllers.map((controller) => controller.text).join();
    if (code.length != 6) {
      setState(() {
        _errorMessage = 'Please enter all 6 digits of the verification code';
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = '';
    });

    try {
      final response = await ApiService.verifyPhone(
        userId: widget.userId,
        code: code,
      );

      // Phone verified successfully, redirect to login
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Phone verified successfully.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pushReplacementNamed('/login');
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

  void _resendCode() async {
    try {
      setState(() {
        _isSubmitting = true;
        _errorMessage = '';
      });
      
      // Call the API to resend the code
      await ApiService.resendVerificationCode(
        userId: widget.userId,
        phone: widget.phone,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification code has been resent to your phone.'),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to resend code: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
          'Phone Verification',
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
                SizedBox(height: 20.h),
                Icon(
                  Icons.phone_android,
                  size: 80.r,
                  color: primaryColor,
                ),
                SizedBox(height: 24.h),
                Text(
                  'Verify Your Phone',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Color(0xFFF5F5DC) : Color(0xFF1A120B),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'We\'ve sent a verification code to ${widget.phone}. Please enter the code below.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isDarkMode ? Color(0xFFF5F5DC).withOpacity(0.8) : Color(0xFF1A120B).withOpacity(0.7),
                  ),
                ),
                SizedBox(height: 32.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    6,
                    (index) => _buildCodeInput(index, isDarkMode),
                  ),
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
                    onPressed: _isSubmitting ? null : _verifyPhone,
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
                  onPressed: _resendCode,
                  child: Text(
                    'Resend Code',
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

  Widget _buildCodeInput(int index, bool isDarkMode) {
    return SizedBox(
      width: 45.w,
      child: TextFormField(
        controller: _codeControllers[index],
        focusNode: _focusNodes[index],
        decoration: InputDecoration(
          filled: true,
          fillColor: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
          contentPadding: EdgeInsets.symmetric(vertical: 14.h),
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
        ),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            _focusNodes[index + 1].requestFocus();
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '';
          }
          return null;
        },
      ),
    );
  }
} 