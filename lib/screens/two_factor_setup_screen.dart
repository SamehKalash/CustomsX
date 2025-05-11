import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../services/api_service.dart';

class TwoFactorSetupScreen extends StatefulWidget {
  final String userId;
  final String email;
  final String qrCodeUrl;
  final String tempSecret;

  const TwoFactorSetupScreen({
    super.key,
    required this.userId,
    required this.email,
    required this.qrCodeUrl,
    required this.tempSecret,
  });

  @override
  State<TwoFactorSetupScreen> createState() => _TwoFactorSetupScreenState();
}

class _TwoFactorSetupScreenState extends State<TwoFactorSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tokenController = TextEditingController();
  bool _isSubmitting = false;
  String _errorMessage = '';
  int _currentStep = 0;

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  Future<void> _verifyAndEnable2FA() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = '';
    });

    try {
      final response = await ApiService.verify2FASetup(
        userId: widget.userId,
        token: _tokenController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Two-factor authentication enabled successfully!'),
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

  void _skipSetup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Skip Two-Factor Authentication?'),
        content: const Text(
          'Two-factor authentication provides an extra layer of security for your account. Are you sure you want to skip this step?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/login');
            },
            child: const Text('Skip'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = const Color(0xFFD4A373);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Two-Factor Authentication',
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
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < 2) {
              setState(() {
                _currentStep++;
              });
            } else {
              _verifyAndEnable2FA();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() {
                _currentStep--;
              });
            } else {
              _skipSetup();
            }
          },
          controlsBuilder: (context, details) {
            return Padding(
              padding: EdgeInsets.only(top: 16.h),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : details.onStepContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      elevation: 0,
                    ),
                    child: _isSubmitting && _currentStep == 2
                        ? SizedBox(
                            height: 20.r,
                            width: 20.r,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.w,
                            ),
                          )
                        : Text(
                            _currentStep == 2 ? 'Verify' : 'Continue',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                            ),
                          ),
                  ),
                  SizedBox(width: 12.w),
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: Text(
                      _currentStep == 0 ? 'Skip' : 'Back',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          steps: [
            Step(
              title: Text(
                'Download Authenticator App',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Install an authenticator app on your mobile device:',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  _buildAuthAppOption(
                    'Google Authenticator',
                    'https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2',
                    'https://apps.apple.com/us/app/google-authenticator/id388497605',
                    Icons.android,
                    Icons.apple,
                    isDarkMode,
                  ),
                  SizedBox(height: 12.h),
                  _buildAuthAppOption(
                    'Microsoft Authenticator',
                    'https://play.google.com/store/apps/details?id=com.azure.authenticator',
                    'https://apps.apple.com/us/app/microsoft-authenticator/id983156458',
                    Icons.android,
                    Icons.apple,
                    isDarkMode,
                  ),
                  SizedBox(height: 12.h),
                  _buildAuthAppOption(
                    'Authy',
                    'https://play.google.com/store/apps/details?id=com.authy.authy',
                    'https://apps.apple.com/us/app/authy/id494168017',
                    Icons.android,
                    Icons.apple,
                    isDarkMode,
                  ),
                ],
              ),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: Text(
                'Scan QR Code',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Open your authenticator app and scan this QR code:',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Center(
                    child: Container(
                      height: 200.r,
                      width: 200.r,
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Image.network(widget.qrCodeUrl),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Or enter this code manually:',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: widget.tempSecret));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Secret key copied to clipboard'),
                          backgroundColor: Colors.blue,
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.white.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: isDarkMode
                              ? Colors.white.withOpacity(0.2)
                              : Colors.grey.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.tempSecret,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontFamily: 'monospace',
                                color: isDarkMode ? Colors.white : Colors.black,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.copy,
                            size: 20.r,
                            color: isDarkMode
                                ? Colors.white.withOpacity(0.7)
                                : Colors.black.withOpacity(0.7),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: Text(
                'Verify Code',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              content: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter the 6-digit verification code from your authenticator app:',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    SizedBox(height: 16.h),
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
                          vertical: 12.h,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: isDarkMode ? Colors.white : Colors.black,
                        letterSpacing: 4,
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 6,
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
                      SizedBox(height: 12.h),
                      Text(
                        _errorMessage,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              isActive: _currentStep >= 2,
              state: StepState.indexed,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthAppOption(
    String appName,
    String androidUrl,
    String iosUrl,
    IconData androidIcon,
    IconData appleIcon,
    bool isDarkMode,
  ) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.white.withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.security,
            size: 24.r,
            color: const Color(0xFFD4A373),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              appName,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  // In a real app, launch the URL
                },
                icon: Icon(
                  androidIcon,
                  size: 22.r,
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.8)
                      : Colors.black.withOpacity(0.7),
                ),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(
                  minWidth: 40.r,
                  minHeight: 40.r,
                ),
              ),
              IconButton(
                onPressed: () {
                  // In a real app, launch the URL
                },
                icon: Icon(
                  appleIcon,
                  size: 22.r,
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.8)
                      : Colors.black.withOpacity(0.7),
                ),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(
                  minWidth: 40.r,
                  minHeight: 40.r,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 