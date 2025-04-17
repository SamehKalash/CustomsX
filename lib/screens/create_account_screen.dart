import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../theme/theme_provider.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _addressController = TextEditingController();
  final _landlineController = TextEditingController();
  final _mobileController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _confirmEmailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _gender;
  String? _country;
  String? _countryCode;
  bool _termsAccepted = false;
  final Color _primaryColor = const Color(0xFFD4A373);

  List<dynamic> _countries = [];
  List<Map<String, String>> _countryCodes = [];

  @override
  void initState() {
    super.initState();
    _loadCountryData();
  }

  Future<void> _loadCountryData() async {
    try {
      final data = await rootBundle.loadString('/assets/countries.json');
      final jsonList = json.decode(data) as List<dynamic>;
      setState(() {
        _countries = jsonList;
        _countryCodes = _processCountryCodes(jsonList);
        if (_countryCodes.isNotEmpty) {
          _countryCode = _countryCodes.first['code'];
        }
      });
    } catch (e) {
      print('Error loading country data: $e');
    }
  }

  List<Map<String, String>> _processCountryCodes(List<dynamic> countries) {
    final codes = <Map<String, String>>[];
    for (final country in countries) {
      final dialCodes = country['dialCodes'] as List<dynamic>;
      for (final code in dialCodes) {
        codes.add({
          'code': code.toString(),
          'name': country['name'],
          'flag': country['emoji'],
          'image': country['image'],
        });
      }
    }
    codes.sort((a, b) => a['name']!.compareTo(b['name']!));
    return codes;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account', style: TextStyle(fontSize: 20.sp)),
        backgroundColor: isDarkMode ? Color(0xFF1A120B) : Colors.white,
        iconTheme: IconThemeData(
          color: isDarkMode ? Color(0xFFF5F5DC) : Color(0xFF1A120B),
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
                      Color(0xFF1A120B),
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
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Personal Information Section
                  _buildSectionTitle('Personal Information', isDarkMode),
                  _buildNameFields(isDarkMode),
                  SizedBox(height: 16.h),
                  _buildDobField(context, isDarkMode),
                  SizedBox(height: 16.h),
                  _buildGenderDropdown(isDarkMode),

                  SizedBox(height: 24.h),

                  // Contact Information Section
                  _buildSectionTitle('Contact Information', isDarkMode),
                  _buildAddressField(isDarkMode),
                  SizedBox(height: 16.h),
                  _buildCountryDropdown(isDarkMode),
                  SizedBox(height: 16.h),
                  _buildLandlineField(isDarkMode),
                  SizedBox(height: 16.h),
                  _buildMobileNumberField(isDarkMode),

                  SizedBox(height: 24.h),

                  // Account Information Section
                  _buildSectionTitle('Account Information', isDarkMode),
                  _buildUsernameField(isDarkMode),
                  SizedBox(height: 16.h),
                  _buildEmailFields(isDarkMode),
                  SizedBox(height: 16.h),
                  _buildPasswordFields(isDarkMode),

                  SizedBox(height: 24.h),
                  _buildTermsCheckbox(isDarkMode),
                  SizedBox(height: 24.h),
                  _buildSubmitButton(isDarkMode),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: isDarkMode ? Color(0xFFF5F5DC) : Color(0xFF1A120B),
        ),
      ),
    );
  }

  Widget _buildNameFields(bool isDarkMode) {
    return Row(
      children: [
        Expanded(
          child: _buildTextField(
            controller: _firstNameController,
            label: 'First Name',
            hint: 'Enter your first name',
            icon: Icons.person_outline,
            isDarkMode: isDarkMode,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Required field';
              if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value))
                return 'Invalid characters';
              return null;
            },
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _buildTextField(
            controller: _lastNameController,
            label: 'Last Name',
            hint: 'Enter your last name',
            icon: Icons.person_outline,
            isDarkMode: isDarkMode,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Required field';
              if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value))
                return 'Invalid characters';
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDobField(BuildContext context, bool isDarkMode) {
    return _buildTextField(
      controller: _dobController,
      label: 'Date of Birth',
      hint: 'DD/MM/YYYY',
      icon: Icons.calendar_today,
      isDarkMode: isDarkMode,
      readOnly: true,
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (date != null) {
          _dobController.text =
              "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) return 'Required field';
        return null;
      },
    );
  }

  Widget _buildGenderDropdown(bool isDarkMode) {
    return DropdownButtonFormField<String>(
      value: _gender,
      decoration: _inputDecoration(
        label: 'Gender',
        icon: Icons.transgender,
        isDarkMode: isDarkMode,
      ),
      items:
          ['Male', 'Female', 'Other']
              .map(
                (gender) => DropdownMenuItem(
                  value: gender,
                  child: Text(gender, style: TextStyle(fontSize: 14.sp)),
                ),
              )
              .toList(),
      onChanged: (value) => setState(() => _gender = value),
      validator: (value) => value == null ? 'Please select gender' : null,
    );
  }

  Widget _buildAddressField(bool isDarkMode) {
    return _buildTextField(
      controller: _addressController,
      label: 'Address',
      hint: 'Enter your full address',
      icon: Icons.location_on,
      isDarkMode: isDarkMode,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Required field';
        return null;
      },
    );
  }

  Widget _buildCountryDropdown(bool isDarkMode) {
    return DropdownButtonFormField<String>(
      value: _country,
      decoration: _inputDecoration(
        label: 'Country',
        icon: Icons.flag,
        isDarkMode: isDarkMode,
      ),
      items:
          _countries.map<DropdownMenuItem<String>>((country) {
            return DropdownMenuItem(
              value: country['name'],
              child: Row(
                children: [
                  Text(country['emoji'], style: TextStyle(fontSize: 20.sp)),
                  SizedBox(width: 12.w),
                  Text(
                    country['name'],
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDarkMode ? Color(0xFFF5F5DC) : Color(0xFF1A120B),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
      onChanged: (value) => setState(() => _country = value),
      validator: (value) => value == null ? 'Please select country' : null,
    );
  }

  Widget _buildLandlineField(bool isDarkMode) {
    return _buildTextField(
      controller: _landlineController,
      label: 'Landline Number',
      hint: 'Enter landline number',
      icon: Icons.phone,
      isDarkMode: isDarkMode,
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        if (value == null || value.isEmpty) return 'Required field';
        return null;
      },
    );
  }

  Widget _buildMobileNumberField(bool isDarkMode) {
    return Row(
      children: [
        Container(
          width: 140.w,
          child: DropdownButtonFormField<String>(
            value: _countryCode,
            decoration: _inputDecoration(
              label: 'Code',
              isDarkMode: isDarkMode,
            ).copyWith(contentPadding: EdgeInsets.symmetric(horizontal: 8.w)),
            items:
                _countryCodes
                    .map(
                      (code) => DropdownMenuItem(
                        value: code['code'],
                        child: Row(
                          children: [
                            Text(
                              code['flag'] ?? '🏳',
                              style: TextStyle(fontSize: 18.sp),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              code['code']!,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color:
                                    isDarkMode
                                        ? Color(0xFFF5F5DC)
                                        : Color(0xFF1A120B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
            onChanged: (value) => setState(() => _countryCode = value),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _buildTextField(
            controller: _mobileController,
            label: 'Mobile Number',
            hint: 'Enter mobile number',
            icon: Icons.phone,
            isDarkMode: isDarkMode,
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value == null || value.isEmpty) return 'Required field';
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUsernameField(bool isDarkMode) {
    return _buildTextField(
      controller: _usernameController,
      label: 'Username',
      hint: 'Choose a username',
      icon: Icons.person,
      isDarkMode: isDarkMode,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Required field';
        if (value.length < 4) return 'At least 4 characters';
        return null;
      },
    );
  }

  Widget _buildEmailFields(bool isDarkMode) {
    return Column(
      children: [
        _buildTextField(
          controller: _emailController,
          label: 'Email',
          hint: 'Enter your email',
          icon: Icons.email,
          isDarkMode: isDarkMode,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Required field';
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Invalid email format';
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        _buildTextField(
          controller: _confirmEmailController,
          label: 'Confirm Email',
          hint: 'Re-enter your email',
          icon: Icons.email,
          isDarkMode: isDarkMode,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value != _emailController.text) return 'Emails do not match';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordFields(bool isDarkMode) {
    return Column(
      children: [
        _buildPasswordField(
          controller: _passwordController,
          label: 'Password',
          isDarkMode: isDarkMode,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Required field';
            if (value.length < 8) return 'At least 8 characters';
            return null;
          },
        ),
        SizedBox(height: 16.h),
        _buildPasswordField(
          controller: _confirmPasswordController,
          label: 'Confirm Password',
          isDarkMode: isDarkMode,
          validator: (value) {
            if (value != _passwordController.text)
              return 'Passwords do not match';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox(bool isDarkMode) {
    return Row(
      children: [
        Checkbox(
          value: _termsAccepted,
          activeColor: _primaryColor,
          onChanged: (value) => setState(() => _termsAccepted = value ?? false),
        ),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'I agree to the ',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isDarkMode ? Color(0xFFF5F5DC) : Color(0xFF1A120B),
                  ),
                ),
                TextSpan(
                  text: 'Terms & Conditions',
                  style: TextStyle(
                    color: _primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(bool isDarkMode) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate() && _termsAccepted) {
            // Handle form submission
            Navigator.pushReplacementNamed(context, '/login');
          } else if (!_termsAccepted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please accept the terms & conditions'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Text(
          'Create Account',
          style: TextStyle(fontSize: 16.sp, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isDarkMode,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    bool readOnly = false,
    VoidCallback? onTap,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(
        label: label,
        hint: hint,
        icon: icon,
        isDarkMode: isDarkMode,
      ),
      style: TextStyle(
        fontSize: 14.sp,
        color: isDarkMode ? Color(0xFFF5F5DC) : Color(0xFF1A120B),
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      readOnly: readOnly,
      onTap: onTap,
      validator: validator,
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isDarkMode,
    String? Function(String?)? validator,
  }) {
    bool obscureText = true;
    return StatefulBuilder(
      builder: (context, setState) {
        return TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: _inputDecoration(
            label: label,
            hint: 'Enter your password',
            icon: Icons.lock,
            isDarkMode: isDarkMode,
          ).copyWith(
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: _primaryColor,
              ),
              onPressed: () => setState(() => obscureText = !obscureText),
            ),
          ),
          style: TextStyle(
            fontSize: 14.sp,
            color: isDarkMode ? Color(0xFFF5F5DC) : Color(0xFF1A120B),
          ),
          validator: validator,
        );
      },
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    String? hint,
    IconData? icon,
    required bool isDarkMode,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon, color: _primaryColor) : null,
      filled: true,
      fillColor: isDarkMode ? Color(0xFF3C2A21) : Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: _primaryColor, width: 1.w),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
    );
  }
}
