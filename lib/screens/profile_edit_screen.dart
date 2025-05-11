import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../theme/theme_provider.dart';
import '../services/api_service.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _mobileController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).user;
    _firstNameController = TextEditingController(
      text: user?['firstName'] ?? '',
    );
    _lastNameController = TextEditingController(text: user?['lastName'] ?? '');
    _emailController = TextEditingController(text: user?['email'] ?? '');
    _mobileController = TextEditingController(text: user?['mobile'] ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20.sp,
            color:
                isDarkMode ? const Color(0xFFF5F5DC) : const Color(0xFF1A120B),
          ),
        ),
        backgroundColor:
            isDarkMode ? const Color(0xFF3C2A21) : const Color(0xFFD4A373),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.check_rounded, size: 24.w),
            onPressed: _isLoading ? null : _saveProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildEditField(
                context,
                label: 'First Name',
                controller: _firstNameController,
                icon: Icons.person_outline_rounded,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              _buildEditField(
                context,
                label: 'Last Name',
                controller: _lastNameController,
                icon: Icons.person_outline_rounded,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              _buildEditField(
                context,
                label: 'Email Address',
                controller: _emailController,
                icon: Icons.email_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              _buildEditField(
                context,
                label: 'Mobile Number',
                controller: _mobileController,
                icon: Icons.phone_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your mobile number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 40.h),
              _buildSaveButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditField(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    final isDarkMode =
        Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark;

    return TextFormField(
      controller: controller,
      validator: validator,
      style: TextStyle(
        fontSize: 16.sp,
        color: isDarkMode ? const Color(0xFFF5F5DC) : const Color(0xFF1A120B),
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isDarkMode ? Colors.white54 : Colors.black54,
          fontSize: 14.sp,
        ),
        prefixIcon: Icon(icon, color: const Color(0xFFD4A373)),
        filled: true,
        fillColor:
            isDarkMode
                ? Colors.black.withOpacity(0.1)
                : Colors.white.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: const Color(0xFFD4A373).withOpacity(0.3),
            width: 1.w,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: const Color(0xFFD4A373), width: 1.5.w),
        ),
        errorStyle: TextStyle(fontSize: 12.sp),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    final isDarkMode =
        Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD4A373),
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child:
            _isLoading
                ? SizedBox(
                  height: 24.h,
                  width: 24.h,
                  child: CircularProgressIndicator(
                    color: isDarkMode ? Colors.black : Colors.white,
                    strokeWidth: 2.5.w,
                  ),
                )
                : Text(
                  'SAVE CHANGES',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.black : Colors.white,
                  ),
                ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Get the current user data
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final currentUser = userProvider.user;
      
      if (currentUser == null) {
        throw Exception('User not logged in');
      }
      
      // Prepare updated user data
      final updatedData = {
        'email': _emailController.text,
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'mobile': _mobileController.text,
        // Keep other fields from the current user
        'address': currentUser['address'],
        'country': currentUser['country'],
      };
      
      // Call the API to update the profile
      final response = await ApiService.updateProfile(updatedData);
      
      // Debug logging
      print('Profile update response:');
      print(response);
      
      // Update the user provider with the returned user data if it exists
      if (response.containsKey('user')) {
        userProvider.setUser(response['user']);
      } else {
        // Fallback to the data we sent if the response doesn't contain user data
        userProvider.setUser({
          ...currentUser,
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'email': _emailController.text,
          'mobile': _mobileController.text,
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating profile: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
