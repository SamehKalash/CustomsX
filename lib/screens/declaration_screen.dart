import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../providers/user_provider.dart';
import 'correction_form_screen.dart';
import 'declaration_form_screen.dart';
import 'unauthorized_access_screen.dart';

class DeclarationScreen extends StatefulWidget {
  const DeclarationScreen({super.key});

  @override
  State<DeclarationScreen> createState() => _DeclarationScreenState();
}

class _DeclarationScreenState extends State<DeclarationScreen> {
  bool _isCorrectionMode = false;

  BoxDecoration _buildBackgroundGradient(bool isDarkMode) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors:
            isDarkMode
                ? [
                  const Color(0xFF1A120B),
                  const Color(0xFF3C2A21),
                  const Color(0xFFD4A373).withOpacity(0.2),
                ]
                : [
                  Colors.white,
                  const Color(0xFFF8F5F0),
                  const Color(0xFFE8E0D6),
                ],
        stops: const [0.0, 0.5, 1.0],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final Color primaryColor = const Color(0xFFD4A373);
    final Color darkText = const Color(0xFF1A120B);
    final Color lightText = const Color(0xFFF5F5DC);
    final Color correctionColor = const Color(0xFF2E7D32);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? primaryColor : darkText,
            size: 24.w,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Simplified Declaration',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: isDarkMode ? lightText : darkText,
          ),
        ),
        backgroundColor: isDarkMode ? darkText : Colors.white,
        elevation: 4,
        iconTheme: IconThemeData(color: isDarkMode ? primaryColor : darkText),
        shadowColor: Colors.black.withOpacity(0.1),
      ),
      body: Container(
        decoration: _buildBackgroundGradient(isDarkMode),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Material(
                      borderRadius: BorderRadius.circular(15.r),
                      color: Colors.transparent,
                      elevation: 0,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15.r),
                        onTap: () => setState(() => _isCorrectionMode = false),
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                !_isCorrectionMode && !isDarkMode
                                    ? primaryColor.withOpacity(0.08)
                                    : isDarkMode
                                    ? const Color(0xFF3C2A21)
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(15.r),
                            border: Border.all(
                              color:
                                  isDarkMode
                                      ? lightText.withOpacity(0.3)
                                      : darkText.withOpacity(
                                        !_isCorrectionMode ? 0.3 : 0.15,
                                      ),
                            ),
                            boxShadow: [
                              if (!isDarkMode)
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 8,
                                  offset: Offset(0, 3.h),
                                ),
                            ],
                          ),
                          padding: EdgeInsets.symmetric(vertical: 15.h),
                          child: Center(
                            child: Text(
                              'New declaration',
                              style: TextStyle(
                                color:
                                    isDarkMode
                                        ? lightText
                                        : !_isCorrectionMode
                                        ? primaryColor
                                        : darkText.withOpacity(0.4),
                                fontSize: 16.sp,
                                fontWeight:
                                    !_isCorrectionMode
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Material(
                      borderRadius: BorderRadius.circular(15.r),
                      color: Colors.transparent,
                      elevation: 0,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15.r),
                        onTap: () => setState(() => _isCorrectionMode = true),
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                isDarkMode && _isCorrectionMode
                                    ? correctionColor.withOpacity(0.1)
                                    : null,
                            borderRadius: BorderRadius.circular(15.r),
                            border: Border.all(
                              color:
                                  isDarkMode
                                      ? _isCorrectionMode
                                          ? correctionColor.withOpacity(0.4)
                                          : lightText.withOpacity(0.3)
                                      : darkText.withOpacity(
                                        _isCorrectionMode ? 0.3 : 0.15,
                                      ),
                            ),
                            boxShadow: [
                              if (!isDarkMode)
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 8,
                                  offset: Offset(0, 3.h),
                                ),
                            ],
                          ),
                          padding: EdgeInsets.symmetric(vertical: 15.h),
                          child: Center(
                            child: Text(
                              'Correction',
                              style: TextStyle(
                                color:
                                    isDarkMode
                                        ? _isCorrectionMode
                                            ? correctionColor
                                            : lightText.withOpacity(0.7)
                                        : _isCorrectionMode
                                        ? correctionColor
                                        : darkText.withOpacity(0.6),
                                fontSize: 16.sp,
                                fontWeight:
                                    _isCorrectionMode
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              if (!_isCorrectionMode)
                _buildAddSection(isDarkMode, primaryColor, darkText, lightText),
              if (_isCorrectionMode)
                _buildCorrectionSection(
                  isDarkMode,
                  correctionColor,
                  darkText,
                  lightText,
                ),
              const Spacer(),
              _buildActionButton(
                isDarkMode,
                _isCorrectionMode,
                correctionColor,
                primaryColor,
                darkText,
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddSection(
    bool isDarkMode,
    Color primaryColor,
    Color darkText,
    Color lightText,
  ) {
    return Column(
      children: [
        Material(
          color: primaryColor.withOpacity(isDarkMode ? 0.1 : 0.12),
          shape: const CircleBorder(),
          elevation: isDarkMode ? 2 : 4,
          shadowColor: primaryColor.withOpacity(0.25),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.all(25.w),
              child: Icon(
                Icons.add,
                color:
                    isDarkMode ? primaryColor : primaryColor.withOpacity(0.9),
                size: 60.w,
              ),
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          'Create a new passenger declaration',
          style: TextStyle(
            color:
                isDarkMode
                    ? lightText.withOpacity(0.85)
                    : darkText.withOpacity(0.8),
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildCorrectionSection(
    bool isDarkMode,
    Color correctionColor,
    Color darkText,
    Color lightText,
  ) {
    return Column(
      children: [
        Material(
          color: correctionColor.withOpacity(isDarkMode ? 0.1 : 0.12),
          shape: const CircleBorder(),
          elevation: isDarkMode ? 2 : 4,
          shadowColor: correctionColor.withOpacity(0.25),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.all(25.w),
              child: Icon(
                Icons.edit,
                color:
                    isDarkMode
                        ? correctionColor
                        : correctionColor.withOpacity(0.9),
                size: 60.w,
              ),
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              Text(
                'Important Note:',
                style: TextStyle(
                  color:
                      isDarkMode
                          ? lightText.withOpacity(0.85)
                          : correctionColor,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'To edit an existing declaration, enter the foreign passport number (or PIN), '
                'date of birth, and registered phone number associated with the declaration.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:
                      isDarkMode
                          ? lightText.withOpacity(0.75)
                          : darkText.withOpacity(0.65),
                  fontSize: 14.5.sp,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    bool isDarkMode,
    bool isCorrection,
    Color correctionColor,
    Color primaryColor,
    Color darkText,
  ) {
    final buttonColor =
        isCorrection
            ? correctionColor
            : isDarkMode
            ? primaryColor
            : darkText;

    return SizedBox(
      width: double.infinity,
      child: Material(
        borderRadius: BorderRadius.circular(15.r),
        color: buttonColor,
        elevation: 4,
        shadowColor: buttonColor.withOpacity(0.35),
        child: InkWell(
          borderRadius: BorderRadius.circular(15.r),
          onTap: () {
            // Check if user is logged in
            final userProvider = Provider.of<UserProvider>(
              context,
              listen: false,
            );
            if (userProvider.user == null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UnauthorizedAccessScreen(),
                ),
              );
              return;
            }

            // Proceed with navigation if user is logged in
            if (isCorrection) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CorrectionFormScreen(),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DeclarationFormScreen(),
                ),
              );
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Center(
              child: Text(
                isCorrection ? 'Start Correction' : 'New Declaration',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: isCorrection || !isDarkMode ? Colors.white : darkText,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
