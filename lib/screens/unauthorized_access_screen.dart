import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'login_screen.dart';

class UnauthorizedAccessScreen extends StatelessWidget {
  const UnauthorizedAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1A120B),
              const Color(0xFF3C2A21),
              const Color(0xFFD4A373).withOpacity(0.2),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.pan_tool_rounded,
                  size: 80.w,
                  color: const Color(0xFFD4A373),
                ),
                SizedBox(height: 24.h),
                Text(
                  'You are not authorized to access\nthe Services',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFF5F5DC),
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Please login with your CustomsX Account',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: const Color(0xFFF5F5DC).withOpacity(0.8),
                  ),
                ),
                SizedBox(height: 40.h),
                ElevatedButton(
                  onPressed:
                      () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4A373),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.w,
                      vertical: 16.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Text(
                    'Login Now',
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
      ),
    );
  }
}
