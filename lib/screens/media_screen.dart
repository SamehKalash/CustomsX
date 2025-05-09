import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/news_card.dart';
import 'news_details_screen.dart';
import 'support.dart';
import 'dashboard.dart';
import 'profile_screen.dart';

class MediaScreen extends StatelessWidget {
  const MediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final List<Map<String, dynamic>> newsData = [
      {
        'title':
            'جهود الحكومة لتهيئة مناخ الأعمال وجذب المزيد من الاستثمارات المحلية والأجنبية',
        'imageNames': ['widget1.jpg'],
        'date': '20 April',
      },
      {
        'title':
            'وزير المالية.. للعاملين بالجمارك: سنعمل بكل جهد سويًا.. لخفض زمن وتكلفة الإفراج الجمركى وتحسين وتبسيط الاجراءات',
        'imageNames': ['widget2.1.jpeg', 'widget2.2.jpeg'],
        'date': '01 April',
      },
    ];

    return Scaffold(
      body: Container(
        decoration: _buildBackgroundGradient(isDarkMode),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  top: 40.h,
                  bottom: 80.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAppBar(context, isDarkMode),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: newsData.length,
                        itemBuilder: (context, index) {
                          final newsItem = newsData[index];
                          return GestureDetector(
                            onTap:
                                () => _navigateWithTransition(
                                  context,
                                  NewsDetailsScreen(
                                    title: newsItem['title'],
                                    imageNames: List<String>.from(
                                      newsItem['imageNames'],
                                    ),
                                    date: newsItem['date'],
                                  ),
                                ),
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 16.h),
                              child: NewsCard(
                                title: newsItem['title'] ?? 'No Title',
                                imageNames: List<String>.from(
                                  newsItem['imageNames'] ?? [],
                                ),
                                date: newsItem['date'] ?? 'No Date',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(isDarkMode, context),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Text(
            'Media',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w800,
              color:
                  isDarkMode
                      ? const Color(0xFFF5F5DC)
                      : const Color(0xFF1A120B),
            ),
          ),
        ],
      ),
    );
  }

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
                  const Color(0xFFF5F5DC).withOpacity(0.6),
                  const Color(0xFFD4A373).withOpacity(0.1),
                ],
        stops: const [0.0, 0.5, 1.0],
      ),
    );
  }

  Widget _buildBottomNavBar(bool isDarkMode, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1A120B) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -2.h),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'Home', 0, isDarkMode, context),
              _buildNavItem(Icons.article, 'News', 1, isDarkMode, context),
              _buildNavItem(
                Icons.help_outline,
                'Support',
                2,
                isDarkMode,
                context,
              ),
              _buildNavItem(Icons.person, 'Profile', 3, isDarkMode, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    int index,
    bool isDarkMode,
    BuildContext context,
  ) {
    final isSelected = index == 1;
    return GestureDetector(
      onTap: () => _handleNavigation(index, context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 28.w,
            color:
                isSelected
                    ? const Color(0xFFD4A373)
                    : (isDarkMode
                        ? const Color(0xFFF5F5DC).withOpacity(0.6)
                        : const Color(0xFF1A120B).withOpacity(0.6)),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color:
                  isSelected
                      ? const Color(0xFFD4A373)
                      : (isDarkMode
                          ? const Color(0xFFF5F5DC).withOpacity(0.6)
                          : const Color(0xFF1A120B).withOpacity(0.6)),
            ),
          ),
        ],
      ),
    );
  }

  void _handleNavigation(int index, BuildContext context) {
    switch (index) {
      case 0:
        _navigateWithTransition(context, const DashboardScreen(), isBack: true);
        break;
      case 2:
        _navigateWithTransition(context, const SupportScreen());
        break;
      case 3:
        _navigateWithTransition(context, const ProfileScreen());
        break;
    }
  }

  void _navigateWithTransition(
    BuildContext context,
    Widget page, {
    bool isBack = false,
  }) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final begin = isBack ? Offset(-1.0, 0.0) : Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutQuart;

          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }
}
