import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../theme/theme_provider.dart';
import './dashboard.dart';
import './settings.dart';
import './login_screen.dart';
import './profile_edit_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final user = userProvider.user;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor:
            isDarkMode ? const Color(0xFF3C2A21) : const Color(0xFFD4A373),
        title: Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20.sp,
            color:
                isDarkMode ? const Color(0xFFF5F5DC) : const Color(0xFF1A120B),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 40.h),
                decoration: BoxDecoration(
                  color:
                      isDarkMode
                          ? const Color(0xFF3C2A21)
                          : const Color(0xFFD4A373),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.r),
                    bottomRight: Radius.circular(30.r),
                  ),
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
                    CircleAvatar(
                      radius: 50.r,
                      backgroundColor: Colors.white.withOpacity(0.1),
                      child: Icon(
                        Icons.person_outline_rounded,
                        size: 40.w,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      user != null
                          ? '${user['firstName']} ${user['lastName']}'
                          : 'Guest User',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        color:
                            isDarkMode ? const Color(0xFFF5F5DC) : Colors.white,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      user?['mobile']?.toString() ?? '+20 123 456 7890',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: (isDarkMode
                                ? const Color(0xFFF5F5DC)
                                : Colors.white)
                            .withOpacity(0.9),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      user?['email'] ?? 'user@example.com',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: (isDarkMode
                                ? const Color(0xFFF5F5DC)
                                : Colors.white)
                            .withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Account Options
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    _buildSectionTitle('Account Management', isDarkMode),
                    SizedBox(height: 12.h),
                    _buildOptionTile(
                      context,
                      icon: Icons.person_2_outlined,
                      title: 'Profile Details',
                      subtitle: 'View personal information',
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileEditScreen(),
                            ),
                          ),
                      isDarkMode: isDarkMode,
                    ),
                    _buildOptionTile(
                      context,
                      icon: Icons.settings_outlined,
                      title: 'App Settings',
                      subtitle: 'Customize app preferences',
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsScreen(),
                            ),
                          ),
                      isDarkMode: isDarkMode,
                    ),
                    _buildOptionTile(
                      context,
                      icon: Icons.logout_rounded,
                      title: 'Sign Out',
                      subtitle: 'Secure account logout',
                      onTap: () => _confirmLogout(context),
                      isDarkMode: isDarkMode,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(isDarkMode),
    );
  }

  Widget _buildSectionTitle(String text, bool isDarkMode) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color:
                isDarkMode ? const Color(0xFFF5F5DC) : const Color(0xFF1A120B),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      color: isDarkMode ? const Color(0xFF3C2A21) : Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.w),
        leading: Icon(icon, size: 28.w, color: const Color(0xFFD4A373)),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color:
                isDarkMode ? const Color(0xFFF5F5DC) : const Color(0xFF1A120B),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14.sp,
            color: (isDarkMode
                    ? const Color(0xFFF5F5DC)
                    : const Color(0xFF1A120B))
                .withOpacity(0.6),
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: (isDarkMode
                  ? const Color(0xFFF5F5DC)
                  : const Color(0xFF1A120B))
              .withOpacity(0.4),
        ),
        onTap: onTap,
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Confirm Logout',
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
            ),
            content: Text(
              'Are you sure you want to sign out?',
              style: TextStyle(fontSize: 16.sp),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: TextStyle(fontSize: 16.sp)),
              ),
              TextButton(
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
                child: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildBottomNavBar(bool isDarkMode) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() => _currentIndex = index);
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const DashboardScreen(),
              transitionsBuilder:
                  (_, animation, __, child) =>
                      FadeTransition(opacity: animation, child: child),
            ),
          );
        }
      },
      backgroundColor: isDarkMode ? const Color(0xFF3C2A21) : Colors.white,
      selectedItemColor: const Color(0xFFD4A373),
      unselectedItemColor: isDarkMode ? Colors.white54 : Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded, size: 28.w),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_rounded, size: 28.w),
          label: '',
        ),
      ],
    );
  }
}
