import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/exhannge_rate.dart';

class ExchangeRateScreen extends StatelessWidget {
  const ExchangeRateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color _darkBackground = const Color(0xFF1A120B);
    final Color _primaryColor = const Color(0xFFD4A373);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Currency Exchange',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: isDarkMode ? const Color(0xFFF5F5DC) : _darkBackground,
          ),
        ),
        backgroundColor: isDarkMode ? _darkBackground : Colors.white,
        elevation: 4,
        iconTheme: IconThemeData(
          color: isDarkMode ? const Color(0xFFF5F5DC) : _darkBackground,
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
                      const Color(0xFF3C2A21),
                      const Color(0xFFD4A373).withOpacity(0.2),
                    ]
                    : [
                      Colors.white,
                      const Color(0xFFF5F5DC).withOpacity(0.6),
                      const Color(0xFFD4A373).withOpacity(0.1),
                    ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              SizedBox(height: 20.h),
              const Expanded(child: ExchangeRateWidget()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color _darkBackground = const Color(0xFF1A120B);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Official Rates',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: isDarkMode ? const Color(0xFFF5F5DC) : _darkBackground,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Updated daily from Central Bank',
          style: TextStyle(
            fontSize: 12.sp,
            color:
                isDarkMode ? Colors.white54 : _darkBackground.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}
