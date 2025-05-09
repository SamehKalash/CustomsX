import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../screens/news_details_screen.dart';

class NewsCard extends StatelessWidget {
  final String title;
  final List<String> imageNames;
  final String date;

  const NewsCard({
    super.key,
    required this.title,
    required this.imageNames,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color _primaryColor = const Color(0xFFD4A373);
    final Color _darkBackground = const Color(0xFF1A120B);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => NewsDetailsScreen(
                  title: title,
                  imageNames: imageNames,
                  date: date,
                ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 16.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        elevation: 4,
        color: isDarkMode ? const Color(0xFF3C2A21) : Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200.h,
              child: PageView.builder(
                itemCount: imageNames.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.r),
                      topRight: Radius.circular(12.r),
                    ),
                    child: Image.asset(
                      'assets/images/${imageNames[index]}',
                      height: 200.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color:
                          isDarkMode
                              ? const Color(0xFFF5F5DC)
                              : _darkBackground,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color:
                          isDarkMode
                              ? const Color(0xFFF5F5DC).withOpacity(0.7)
                              : _darkBackground.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
