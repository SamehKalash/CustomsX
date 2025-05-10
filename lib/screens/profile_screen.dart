import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../theme/theme_provider.dart';
import './dashboard.dart';
import './settings.dart';
import './login_screen.dart';
import './profile_edit_screen.dart';
import './support.dart';

import './switch_to_company_screen.dart';
import './media_screen.dart';
import './subscription_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 3; // Profile is index 3 in 4-tab system
  final Color _primaryColor = const Color(0xFFD4A373);
  final Color _darkBackground = const Color(0xFF1A120B);
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuad),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final user = userProvider.user;

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
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w800,
                          color:
                              isDarkMode ? Color(0xFFF5F5DC) : _darkBackground,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: _buildProfileHeader(isDarkMode, user),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('Account Management', isDarkMode),
                          SizedBox(height: 12.h),
                          _buildAnimatedOption(
                            context,
                            Icons.person_2_outlined,
                            'Profile Details',
                            'View personal information',
                            () => _navigateWithSlide(
                              context,
                              const ProfileEditScreen(),
                            ),
                            isDarkMode,
                          ),
                          _buildAnimatedOption(
                            context,
                            Icons.settings_outlined,
                            'App Settings',
                            'Customize app preferences',
                            () => _navigateWithSlide(
                              context,
                              const SettingsScreen(),
                            ),
                            isDarkMode,
                          ),
                          _buildAnimatedOption(
                            context,
                            Icons.logout_rounded,
                            'Sign Out',
                            'Secure account logout',
                            () => _confirmLogout(context),
                            isDarkMode,
                          ),
                          SizedBox(height: 20.h),
                          _buildSwitchToCompanyButton(isDarkMode),
                          _buildPremiumButton(context, isDarkMode),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(isDarkMode),
    );
  }

  Widget _buildSwitchToCompanyButton(bool isDarkMode) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    // Only show button if user is logged in and has a Personal account type
    if (user == null || user['accounttype'] != 'Personal') {
      return const SizedBox.shrink();
    }

    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SwitchToCompanyScreen(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isDarkMode ? const Color(0xFFD4A373) : _darkBackground,
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 24.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 5,
        ),
        child: Text(
          'Switch to Company Account',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? _darkBackground : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumButton(BuildContext context, bool isDarkMode) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    // Only show for Company accounts
    if (user == null || user['accounttype'] != 'Company') {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: ElevatedButton(
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SubscriptionPage()),
            ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD4A373),
          padding: EdgeInsets.symmetric(vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star, color: Colors.white),
            SizedBox(width: 8.w),
            Text(
              'Get Premium',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateWithSlide(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder:
            (_, animation, __, child) => SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
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
    );
  }

  Widget _buildProfileHeader(bool isDarkMode, dynamic user) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF3C2A21) : _primaryColor,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutBack,
            child: CircleAvatar(
              radius: 50.r,
              backgroundColor: Colors.white.withOpacity(0.1),
              child: Icon(
                Icons.person_outline_rounded,
                size: 40.w,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            user != null ? '${user['firstName']} ${user['lastName']}' : 'Guest',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: isDarkMode ? Color(0xFFF5F5DC) : Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            user?['mobile']?.toString() ?? '+00 123 456 7890',
            style: TextStyle(
              fontSize: 16.sp,
              color: (isDarkMode ? Color(0xFFF5F5DC) : Colors.white)
                  .withOpacity(0.9),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            user?['email'] ?? 'user@example.com',
            style: TextStyle(
              fontSize: 16.sp,
              color: (isDarkMode ? Color(0xFFF5F5DC) : Colors.white)
                  .withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 20.sp,
          color: isDarkMode ? Color(0xFFF5F5DC) : _darkBackground,
        ),
      ),
    );
  }

  Widget _buildAnimatedOption(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
    bool isDarkMode,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Material(
          key: ValueKey<String>(title),
          color: isDarkMode ? Color(0xFF3C2A21) : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          elevation: 2,
          child: InkWell(
            borderRadius: BorderRadius.circular(12.r),
            onTap: onTap,
            hoverColor: _primaryColor.withOpacity(0.1),
            splashColor: _primaryColor.withOpacity(0.2),
            child: ListTile(
              contentPadding: EdgeInsets.all(12.w),
              leading: Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, color: _primaryColor, size: 24.w),
              ),
              title: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                  color: isDarkMode ? Color(0xFFF5F5DC) : _darkBackground,
                ),
              ),
              subtitle: Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: (isDarkMode ? Color(0xFFF5F5DC) : _darkBackground)
                      .withOpacity(0.6),
                ),
              ),
              trailing: Icon(Icons.chevron_right, color: _primaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
            title: Text(
              'Log Out',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: _primaryColor,
              ),
            ),
            content: Text(
              'Are you sure you want to sign out?',
              style: TextStyle(fontSize: 16.sp),
            ),
            actions: [
              TextButton(
                child: Text('Cancel', style: TextStyle(color: Colors.grey)),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text('Log Out', style: TextStyle(color: _primaryColor)),
                onPressed: () {
                  Provider.of<UserProvider>(context, listen: false).clearUser();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
    );
  }

  Widget _buildBottomNavBar(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? _darkBackground : Colors.white,
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
              _buildNavItem(Icons.home, 'Home', 0, isDarkMode),
              _buildNavItem(Icons.article, 'News', 1, isDarkMode),
              _buildNavItem(Icons.help_outline, 'Support', 2, isDarkMode),
              _buildNavItem(Icons.person, 'Profile', 3, isDarkMode),
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
  ) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => _updateIndex(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 28.w,
            color:
                isSelected
                    ? _primaryColor
                    : (isDarkMode
                        ? Color(0xFFF5F5DC).withOpacity(0.6)
                        : _darkBackground.withOpacity(0.6)),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color:
                  isSelected
                      ? _primaryColor
                      : (isDarkMode
                          ? Color(0xFFF5F5DC).withOpacity(0.6)
                          : _darkBackground.withOpacity(0.6)),
            ),
          ),
        ],
      ),
    );
  }

  void _updateIndex(int index) {
    setState(() => _currentIndex = index);
    switch (index) {
      case 0:
        _navigateWithTransition(const DashboardScreen(), isBack: true);
        break;
      case 1:
        _navigateWithTransition(const MediaScreen());
        break;
      case 2:
        _navigateWithTransition(const SupportScreen());
        break;
    }
  }

  void _navigateWithTransition(Widget page, {bool isBack = false}) {
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
