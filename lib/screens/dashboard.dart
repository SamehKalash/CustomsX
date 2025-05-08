import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../theme/theme_provider.dart';
import '../widgets/status_card.dart';
import './profile_screen.dart';
import './exchange_rate_screen.dart';
import '../providers/user_provider.dart';
import 'customs_calculation_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  final Color _primaryColor = const Color(0xFFD4A373);
  final Color _darkBackground = const Color(0xFF1A120B);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final iconColor = isDarkMode ? const Color(0xFFF5F5DC) : _darkBackground;

    return Scaffold(
      appBar: _buildAppBar(context, isDarkMode, iconColor),
      body: Container(
        decoration: _buildBackgroundGradient(isDarkMode),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeBanner(isDarkMode),
              SizedBox(height: 20.h),
              _buildSectionTitle('Quick Actions', isDarkMode),
              SizedBox(height: 10.h),
              _buildQuickActions(context, isDarkMode),
              SizedBox(height: 20.h),
              _buildStatusSection(context, isDarkMode),
              SizedBox(height: 20.h),
              _buildComplianceUpdates(context, isDarkMode),
              SizedBox(height: 20.h),
              _buildExchangeRateSection(context, isDarkMode),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
      bottomNavigationBar: _buildBottomNavBar(isDarkMode),
    );
  }

  AppBar _buildAppBar(BuildContext context, bool isDarkMode, Color iconColor) {
    return AppBar(
      title: Text(
        'Dashboard',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 24.sp,
          color: isDarkMode ? Color(0xFFF5F5DC) : _darkBackground,
        ),
      ),
      backgroundColor: isDarkMode ? _darkBackground : Colors.white,
      elevation: 4,
      automaticallyImplyLeading: false,
      iconTheme: IconThemeData(color: iconColor),
      actions: [
        IconButton(
          icon: Icon(Icons.logout_rounded, size: 24.w, color: iconColor),
          onPressed: () => _confirmExit(context),
        ),
        SizedBox(width: 8.w),
        _buildNotificationIcon(context, isDarkMode, iconColor),
        SizedBox(width: 12.w),
      ],
    );
  }

  void _confirmExit(BuildContext context) {
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
              'Are you sure you want to return to login?',
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
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ],
          ),
    );
  }

  Widget _buildNotificationIcon(
    BuildContext context,
    bool isDarkMode,
    Color iconColor,
  ) {
    return Stack(
      children: [
        IconButton(
          icon: Icon(
            Icons.notifications_outlined,
            size: 24.w,
            color: iconColor,
          ),
          onPressed: () => _showNotifications(context, isDarkMode),
        ),
        Positioned(
          right: 8.w,
          top: 8.h,
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: _primaryColor,
              shape: BoxShape.circle,
            ),
            child: Text(
              '2',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
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

  Widget _buildWelcomeBanner(bool isDarkMode) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    final lastLogin = userProvider.lastLogin;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome Back,',
            style: TextStyle(
              fontSize: 18.sp,
              color: isDarkMode ? Color(0xFFF5F5DC) : Colors.white,
            ),
          ),
          Text(
            user != null ? '${user['firstName']} ${user['lastName']}' : 'Guest',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 24.sp,
              color: isDarkMode ? Color(0xFFF5F5DC) : Colors.white,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            _getLastLoginText(lastLogin),
            style: TextStyle(
              fontSize: 14.sp,
              color:
                  isDarkMode
                      ? Color(0xFFF5F5DC).withOpacity(0.7)
                      : Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  String _getLastLoginText(DateTime? lastLogin) {
    if (lastLogin == null) return 'First time login!';

    final now = DateTime.now();
    final difference = now.difference(lastLogin);

    if (difference.inSeconds < 60) return 'Last login: Just now';
    if (difference.inMinutes < 60) {
      return 'Last login: ${difference.inMinutes}m ago';
    }
    if (difference.inHours < 24) {
      return 'Last login: ${difference.inHours}h ago';
    }
    if (difference.inDays < 7) return 'Last login: ${difference.inDays}d ago';

    return 'Last login: ${DateFormat('MMM dd, yyyy - hh:mm a').format(lastLogin)}';
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

  Widget _buildQuickActions(BuildContext context, bool isDarkMode) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 0.9,
      mainAxisSpacing: 12.w,
      crossAxisSpacing: 12.w,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      children: [
        _buildActionButton(
          context,
          Icons.support_agent,
          'Support',
          '/support',
          isDarkMode,
        ),
        _buildActionButton(
          context,
          Icons.track_changes,
          'Tracking',
          '/tracking',
          isDarkMode,
        ),
        _buildActionButton(
          context,
          Icons.upload_file,
          'Upload',
          '/documents',
          isDarkMode,
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    String route,
    bool isDarkMode,
  ) {
    return Material(
      borderRadius: BorderRadius.circular(15.r),
      color: isDarkMode ? Color(0xFF3C2A21) : Colors.white,
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(15.r),
        onTap: () => Navigator.pushNamed(context, route),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: _primaryColor, size: 28.w),
              ),
              SizedBox(height: 10.h),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                  color: isDarkMode ? Color(0xFFF5F5DC) : _darkBackground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusSection(BuildContext context, bool isDarkMode) {
    return Column(
      children: [
        StatusCard(
          icon: Icons.pending_actions,
          title: 'Pending Shipments',
          value: '3 Items',
          subText: '2 in Customs Review',
          alertLevel: 2,
          isDarkMode: isDarkMode,
        ),
        SizedBox(height: 12.h),
        StatusCard(
          icon: Icons.description,
          title: 'Recent Documents',
          value: '5 Files',
          subText: 'Last upload: 2h ago',
          alertLevel: 0,
          isDarkMode: isDarkMode,
        ),
      ],
    );
  }

  Widget _buildComplianceUpdates(BuildContext context, bool isDarkMode) {
    return Column(
      children: [
        _buildUpdateItem(
          context,
          'Egypt Customs Regulations',
          'New tariff codes effective March 2024',
          Icons.gavel,
          isDarkMode,
        ),
        SizedBox(height: 12.h),
        _buildUpdateItem(
          context,
          'Egypt Import Restrictions',
          'Updated restricted items list',
          Icons.block,
          isDarkMode,
        ),
        SizedBox(height: 12.h),
        _buildUpdateItem(
          context,
          'Global Trade News',
          'Latest international trade agreements',
          Icons.public,
          isDarkMode,
        ),
      ],
    );
  }

  Widget _buildUpdateItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    bool isDarkMode,
  ) {
    return Material(
      color: isDarkMode ? Color(0xFF3C2A21) : Colors.white,
      borderRadius: BorderRadius.circular(12.r),
      elevation: 2,
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
            color:
                isDarkMode
                    ? Color(0xFFF5F5DC).withOpacity(0.7)
                    : _darkBackground.withOpacity(0.6),
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: _primaryColor),
        onTap: () => Navigator.pushNamed(context, '/compliance'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  Widget _buildExchangeRateSection(BuildContext context, bool isDarkMode) {
    return Material(
      color: isDarkMode ? Color(0xFF3C2A21) : Colors.white,
      borderRadius: BorderRadius.circular(12.r),
      elevation: 2,
      child: ListTile(
        contentPadding: EdgeInsets.all(12.w),
        leading: Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: _primaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            Icons.currency_exchange,
            color: _primaryColor,
            size: 24.w,
          ),
        ),
        title: Text(
          'Exchange Rates',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            color: isDarkMode ? Color(0xFFF5F5DC) : _darkBackground,
          ),
        ),
        subtitle: Text(
          'View current exchange rates',
          style: TextStyle(
            fontSize: 14.sp,
            color:
                isDarkMode
                    ? Color(0xFFF5F5DC).withOpacity(0.7)
                    : _darkBackground.withOpacity(0.6),
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: _primaryColor),
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ExchangeRateScreen(),
              ),
            ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => _showFABAction(context),
      backgroundColor: _primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Icon(Icons.add, color: Colors.white, size: 28.w),
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
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, 'Home', 0, isDarkMode),
            _buildNavItem(Icons.person, 'Profile', 1, isDarkMode),
          ],
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
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const DashboardScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(-1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOutQuart;

            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(position: offsetAnimation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const ProfileScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOutQuart;

            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(position: offsetAnimation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  void _showNotifications(BuildContext context, bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF3C2A21) : Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color:
                        isDarkMode ? const Color(0xFFF5F5DC) : _darkBackground,
                  ),
                ),
                SizedBox(height: 12.h),
                ListTile(
                  leading: Icon(Icons.gavel, color: _primaryColor),
                  title: Text(
                    'New Customs Update',
                    style: TextStyle(
                      color:
                          isDarkMode
                              ? const Color(0xFFF5F5DC)
                              : _darkBackground,
                    ),
                  ),
                  subtitle: Text(
                    'Egypt updated tariff codes.',
                    style: TextStyle(
                      color:
                          isDarkMode
                              ? const Color(0xFFF5F5DC).withOpacity(0.7)
                              : _darkBackground.withOpacity(0.6),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.block, color: _primaryColor),
                  title: Text(
                    'Restricted Items Notice',
                    style: TextStyle(
                      color:
                          isDarkMode
                              ? const Color(0xFFF5F5DC)
                              : _darkBackground,
                    ),
                  ),
                  subtitle: Text(
                    'Check latest import bans.',
                    style: TextStyle(
                      color:
                          isDarkMode
                              ? const Color(0xFFF5F5DC).withOpacity(0.7)
                              : _darkBackground.withOpacity(0.6),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Color iconColor,
    bool isDarkMode,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(icon, color: iconColor, size: 24.w),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDarkMode ? Color(0xFFF5F5DC) : _darkBackground,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color:
              isDarkMode
                  ? Color(0xFFF5F5DC).withOpacity(0.7)
                  : _darkBackground.withOpacity(0.6),
        ),
      ),
    );
  }

  void _showFABAction(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CustomsCalculatorScreen()),
    );
  }
}
