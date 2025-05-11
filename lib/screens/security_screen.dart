import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _reenterPasswordController =
      TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureReenter = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _reenterPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark;
    final Color primaryColor = const Color(0xFFD4A373);
    final Color darkBackground = const Color(0xFF1A120B);
    final Color cardColor = isDarkMode ? const Color(0xFF3C2A21) : Colors.white;
    final Color textColor =
        isDarkMode ? const Color(0xFFF5F5DC) : darkBackground;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Security Settings',
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
            colors:
                isDarkMode
                    ? [
                      const Color(0xFF1A120B),
                      const Color(0xFF3C2A21),
                      const Color(0xFF1A120B),
                    ]
                    : [Colors.white, const Color(0xFFF5F5DC), Colors.white],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(maxWidth: 400.w),
              padding: EdgeInsets.all(20.w),
              child: Material(
                color: cardColor,
                borderRadius: BorderRadius.circular(18.r),
                elevation: 6,
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Change Password',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                            color: textColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24.h),
                        TextFormField(
                          controller: _currentPasswordController,
                          obscureText: _obscureCurrent,
                          style: TextStyle(color: textColor),
                          decoration: InputDecoration(
                            labelText: 'Current Password',
                            labelStyle: TextStyle(
                              color: textColor.withOpacity(0.8),
                            ),
                            filled: true,
                            fillColor:
                                isDarkMode
                                    ? const Color(0xFF2D1F14)
                                    : const Color(0xFFF9F6F2),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: primaryColor.withOpacity(0.5),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: primaryColor,
                                width: 2,
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureCurrent
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: primaryColor,
                              ),
                              onPressed:
                                  () => setState(
                                    () => _obscureCurrent = !_obscureCurrent,
                                  ),
                            ),
                          ),
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Enter current password'
                                      : null,
                        ),
                        SizedBox(height: 16.h),
                        TextFormField(
                          controller: _newPasswordController,
                          obscureText: _obscureNew,
                          style: TextStyle(color: textColor),
                          decoration: InputDecoration(
                            labelText: 'New Password',
                            labelStyle: TextStyle(
                              color: textColor.withOpacity(0.8),
                            ),
                            filled: true,
                            fillColor:
                                isDarkMode
                                    ? const Color(0xFF2D1F14)
                                    : const Color(0xFFF9F6F2),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: primaryColor.withOpacity(0.5),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: primaryColor,
                                width: 2,
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureNew
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: primaryColor,
                              ),
                              onPressed:
                                  () => setState(
                                    () => _obscureNew = !_obscureNew,
                                  ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Enter new password';
                            if (value.length < 6)
                              return 'Password must be at least 6 characters';
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),
                        TextFormField(
                          controller: _reenterPasswordController,
                          obscureText: _obscureReenter,
                          style: TextStyle(color: textColor),
                          decoration: InputDecoration(
                            labelText: 'Re-enter New Password',
                            labelStyle: TextStyle(
                              color: textColor.withOpacity(0.8),
                            ),
                            filled: true,
                            fillColor:
                                isDarkMode
                                    ? const Color(0xFF2D1F14)
                                    : const Color(0xFFF9F6F2),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: primaryColor.withOpacity(0.5),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: primaryColor,
                                width: 2,
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureReenter
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: primaryColor,
                              ),
                              onPressed:
                                  () => setState(
                                    () => _obscureReenter = !_obscureReenter,
                                  ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Re-enter new password';
                            if (value != _newPasswordController.text)
                              return 'Passwords do not match';
                            return null;
                          },
                        ),
                        SizedBox(height: 28.h),
                        Material(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(15.r),
                          elevation: 4,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(15.r),
                            onTap: _submit,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              child: Center(
                                child: Text(
                                  'Change Password',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ),
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
      ),
    );
  }
}
