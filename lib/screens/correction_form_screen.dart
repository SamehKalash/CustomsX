import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

class CorrectionFormScreen extends StatefulWidget {
  const CorrectionFormScreen({super.key});

  @override
  State<CorrectionFormScreen> createState() => _CorrectionFormScreenState();
}

class _CorrectionFormScreenState extends State<CorrectionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passportController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  DateTime? _selectedDate;

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
                  const Color(0xFFF8F5F0),
                  const Color(0xFFE8E0D6),
                ],
        stops: const [0.0, 0.5, 1.0],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFFD4A373),
              onPrimary: Colors.white,
              surface: isDarkMode ? const Color(0xFF3C2A21) : Colors.white,
              onSurface: isDarkMode ? Colors.white : const Color(0xFF1A120B),
            ),
            dialogBackgroundColor:
                isDarkMode ? const Color(0xFF3C2A21) : Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = const Color(0xFFD4A373);
    final darkText = const Color(0xFF1A120B);
    final lightText = const Color(0xFFF5F5DC);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? primaryColor : darkText,
            size: 24.w,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Correction Form',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: isDarkMode ? lightText : darkText,
          ),
        ),
        backgroundColor: isDarkMode ? darkText : Colors.white,
        elevation: 4,
        iconTheme: IconThemeData(color: isDarkMode ? primaryColor : darkText),
        shadowColor: Colors.black.withOpacity(0.1),
      ),
      body: Container(
        decoration: _buildBackgroundGradient(isDarkMode),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Text(
                  'Enter your details to find the declaration',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? lightText.withOpacity(0.85) : darkText,
                  ),
                ),
                SizedBox(height: 30.h),
                TextFormField(
                  controller: _passportController,
                  style: TextStyle(
                    color: isDarkMode ? lightText : darkText,
                    fontSize: 16.sp,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Passport Number/PIN',
                    labelStyle: TextStyle(
                      color:
                          isDarkMode
                              ? lightText.withOpacity(0.7)
                              : darkText.withOpacity(0.6),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(
                        color:
                            isDarkMode
                                ? lightText.withOpacity(0.3)
                                : darkText.withOpacity(0.2),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(
                        color:
                            isDarkMode
                                ? lightText.withOpacity(0.3)
                                : darkText.withOpacity(0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: primaryColor, width: 1.5.w),
                    ),
                    prefixIcon: Icon(
                      Icons.credit_card,
                      color:
                          isDarkMode
                              ? lightText.withOpacity(0.7)
                              : darkText.withOpacity(0.6),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter passport number/PIN';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Date of Birth',
                      labelStyle: TextStyle(
                        color:
                            isDarkMode
                                ? lightText.withOpacity(0.7)
                                : darkText.withOpacity(0.6),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(
                          color:
                              isDarkMode
                                  ? lightText.withOpacity(0.3)
                                  : darkText.withOpacity(0.2),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(
                          color:
                              isDarkMode
                                  ? lightText.withOpacity(0.3)
                                  : darkText.withOpacity(0.2),
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.calendar_today,
                        color:
                            isDarkMode
                                ? lightText.withOpacity(0.7)
                                : darkText.withOpacity(0.6),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedDate == null
                              ? 'Select date'
                              : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color:
                                _selectedDate == null
                                    ? (isDarkMode
                                        ? lightText.withOpacity(0.5)
                                        : darkText.withOpacity(0.4))
                                    : (isDarkMode ? lightText : darkText),
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color:
                              isDarkMode
                                  ? lightText.withOpacity(0.7)
                                  : darkText.withOpacity(0.6),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(
                    color: isDarkMode ? lightText : darkText,
                    fontSize: 16.sp,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Registered Phone Number',
                    labelStyle: TextStyle(
                      color:
                          isDarkMode
                              ? lightText.withOpacity(0.7)
                              : darkText.withOpacity(0.6),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(
                        color:
                            isDarkMode
                                ? lightText.withOpacity(0.3)
                                : darkText.withOpacity(0.2),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(
                        color:
                            isDarkMode
                                ? lightText.withOpacity(0.3)
                                : darkText.withOpacity(0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: primaryColor, width: 1.5.w),
                    ),
                    prefixIcon: Icon(
                      Icons.phone,
                      color:
                          isDarkMode
                              ? lightText.withOpacity(0.7)
                              : darkText.withOpacity(0.6),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter phone number';
                    }
                    if (value.length < 8) {
                      return 'Enter valid phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30.h),
                SizedBox(
                  width: double.infinity,
                  child: Material(
                    borderRadius: BorderRadius.circular(15.r),
                    color: isDarkMode ? primaryColor : darkText,
                    elevation: 4,
                    shadowColor: Colors.black.withOpacity(0.2),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15.r),
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.pop(context);
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        child: Center(
                          child: Text(
                            'Search Declaration',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
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
