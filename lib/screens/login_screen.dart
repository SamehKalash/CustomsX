import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../providers/user_provider.dart';
import '../theme/theme_provider.dart';
import 'dashboard.dart';
import 'create_account_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(opacity: _opacityAnimation, child: child),
          );
        },
        child: _buildMainContent(isDarkMode),
      ),
    );
  }

  Widget _buildMainContent(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors:
              isDarkMode
                  ? [
                    const Color(0xFF1A120B),
                    const Color(0xFF3C2A21),
                    const Color(0xFFD4A373),
                  ]
                  : [
                    Colors.white,
                    const Color(0xFFF5F5DC),
                    const Color(0xFFD4A373).withOpacity(0.4),
                  ],
          stops: const [0.1, 0.5, 0.9],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 40.h,
            left: 20.w,
            child: _buildDecorativeCircle(
              size: 60.w,
              color:
                  isDarkMode
                      ? Colors.black.withOpacity(0.1)
                      : Colors.white.withOpacity(0.3),
            ),
          ),
          Positioned(
            bottom: 80.h,
            right: 30.w,
            child: _buildDecorativeCircle(
              size: 100.w,
              color:
                  isDarkMode
                      ? const Color(0xFFD4A373).withOpacity(0.2)
                      : const Color(0xFFD4A373).withOpacity(0.1),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w700,
                        color:
                            isDarkMode
                                ? const Color(0xFFF5F5DC)
                                : const Color(0xFF1A120B),
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(height: 40.h),
                    _buildInputField(
                      hintText: 'Email Address',
                      icon: Icons.email_rounded,
                      isDarkMode: isDarkMode,
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'Invalid email format';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.h),
                    _buildInputField(
                      hintText: 'Password',
                      icon: Icons.lock_rounded,
                      isPassword: true,
                      isDarkMode: isDarkMode,
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30.h),
                    ElevatedButton(
                      onPressed:
                          _isLoading ? null : () => _handleLogin(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4A373),
                        foregroundColor: Colors.black,
                        minimumSize: Size(double.infinity, 50.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        elevation: 5,
                      ),
                      child:
                          _isLoading
                              ? SizedBox(
                                height: 24.h,
                                width: 24.h,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3.w,
                                ),
                              )
                              : Text(
                                'LOGIN',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.2,
                                ),
                              ),
                    ),
                    SizedBox(height: 20.h),
                    OutlinedButton(
                      onPressed: () {
                        Provider.of<UserProvider>(
                          context,
                          listen: false,
                        ).clearUser();
                        _navigateToDashboard(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor:
                            isDarkMode
                                ? const Color(0xFFF5F5DC)
                                : const Color(0xFF1A120B),
                        side: BorderSide(
                          color: const Color(0xFFD4A373).withOpacity(0.8),
                          width: 1.w,
                        ),
                        minimumSize: Size(double.infinity, 50.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 20.w,
                            color: const Color(0xFFD4A373),
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            'CONTINUE AS GUEST',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const ForgotPasswordScreen(),
                                ),
                              ),
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color:
                                  isDarkMode
                                      ? const Color(0xFFF5F5DC).withOpacity(0.8)
                                      : const Color(
                                        0xFF1A120B,
                                      ).withOpacity(0.6),
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        SizedBox(width: 20.w),
                        TextButton(
                          onPressed:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const CreateAccountScreen(),
                                ),
                              ),
                          child: Text(
                            'Create Account',
                            style: TextStyle(
                              color: const Color(0xFFD4A373),
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogin(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final response = await ApiService.loginUser(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        if (response['user'] != null) {
          // Set user data first
          Provider.of<UserProvider>(
            context,
            listen: false,
          ).setUser(response['user']);

          // Then clear fields and navigate
          _emailController.clear();
          _passwordController.clear();
          _navigateToDashboard(context);
        } else {
          throw Exception('Invalid login response');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _navigateToDashboard(BuildContext context) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) => const DashboardScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutQuart;
          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  Widget _buildDecorativeCircle({required double size, required Color color}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  Widget _buildInputField({
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    required bool isDarkMode,
    required TextEditingController controller,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: validator,
      style: TextStyle(
        color: isDarkMode ? const Color(0xFFF5F5DC) : const Color(0xFF1A120B),
        fontSize: 16.sp,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor:
            isDarkMode
                ? Colors.black.withOpacity(0.1)
                : Colors.white.withOpacity(0.3),
        hintText: hintText,
        hintStyle: TextStyle(
          color:
              isDarkMode
                  ? const Color(0xFFF5F5DC).withOpacity(0.6)
                  : const Color(0xFF1A120B).withOpacity(0.4),
          fontSize: 16.sp,
        ),
        prefixIcon: Icon(
          icon,
          color: const Color(0xFFD4A373).withOpacity(0.8),
          size: 24.w,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(
            color: const Color(0xFFD4A373).withOpacity(0.5),
            width: 1.w,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
      ),
    );
  }
}
