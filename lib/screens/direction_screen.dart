import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import 'goods_currency_screen.dart';

class DirectionScreen extends StatefulWidget {
  const DirectionScreen({super.key});

  @override
  State<DirectionScreen> createState() => _DirectionScreenState();
}

class _DirectionScreenState extends State<DirectionScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedDepartureCountry;
  String? _selectedTransport;
  DateTime? _arrivalDate;
  final TextEditingController _flightNumberController = TextEditingController();

  // Replace with your actual country data
  final List<String> _countries = [
    'Egypt',
    'United States',
    'Germany',
    'France',
    'Italy',
    'Japan',
  ];

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

  Future<void> _selectArrivalDate(BuildContext context) async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
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

    if (picked != null) {
      setState(() => _arrivalDate = picked);
    }
  }

  Widget _buildTransportOption(String title, String value, bool isDarkMode) {
    return InkWell(
      onTap: () => setState(() => _selectedTransport = value),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF3C2A21) : Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color:
                _selectedTransport == value
                    ? const Color(0xFFD4A373)
                    : isDarkMode
                    ? Colors.white.withOpacity(0.3)
                    : Colors.black.withOpacity(0.2),
            width: 1.5.w,
          ),
        ),
        child: Row(
          children: [
            Icon(
              _selectedTransport == value
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              color: const Color(0xFFD4A373),
            ),
            SizedBox(width: 12.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
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
          'Direction Information',
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
            child: ListView(
              children: [
                SizedBox(height: 20.h),
                Text(
                  'Travel Details',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? lightText.withOpacity(0.85) : darkText,
                  ),
                ),
                SizedBox(height: 30.h),

                // Departure Country Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedDepartureCountry,
                  decoration: InputDecoration(
                    labelText: 'Country of Departure',
                    labelStyle: TextStyle(
                      color:
                          isDarkMode
                              ? lightText.withOpacity(0.7)
                              : darkText.withOpacity(0.6),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
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
                      Icons.flag,
                      color:
                          isDarkMode
                              ? lightText.withOpacity(0.7)
                              : darkText.withOpacity(0.6),
                    ),
                  ),
                  items:
                      _countries.map((String country) {
                        return DropdownMenuItem<String>(
                          value: country,
                          child: Text(
                            country,
                            style: TextStyle(
                              color: isDarkMode ? lightText : darkText,
                              fontSize: 16.sp,
                            ),
                          ),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {
                    setState(() => _selectedDepartureCountry = newValue);
                  },
                  validator:
                      (value) =>
                          value == null
                              ? 'Please select departure country'
                              : null,
                ),
                SizedBox(height: 30.h),

                // Transport Type
                Text(
                  'Transportation Method:',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color:
                        isDarkMode
                            ? lightText.withOpacity(0.8)
                            : darkText.withOpacity(0.7),
                  ),
                ),
                SizedBox(height: 15.h),
                _buildTransportOption('On Foot', 'foot', isDarkMode),
                SizedBox(height: 12.h),
                _buildTransportOption('Road', 'road', isDarkMode),
                SizedBox(height: 12.h),
                _buildTransportOption('Air', 'air', isDarkMode),
                SizedBox(height: 12.h),
                _buildTransportOption('Sea', 'sea', isDarkMode),
                SizedBox(height: 25.h),

                // Air-specific fields
                if (_selectedTransport == 'air') ...[
                  InkWell(
                    onTap: () => _selectArrivalDate(context),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Arrival Date',
                        labelStyle: TextStyle(
                          color:
                              isDarkMode
                                  ? lightText.withOpacity(0.7)
                                  : darkText.withOpacity(0.6),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
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
                            _arrivalDate == null
                                ? 'Select arrival date'
                                : '${_arrivalDate!.day}/${_arrivalDate!.month}/${_arrivalDate!.year}',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color:
                                  _arrivalDate == null
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
                    controller: _flightNumberController,
                    decoration: InputDecoration(
                      labelText: 'Flight Number',
                      labelStyle: TextStyle(
                        color:
                            isDarkMode
                                ? lightText.withOpacity(0.7)
                                : darkText.withOpacity(0.6),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
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
                        borderSide: BorderSide(
                          color: primaryColor,
                          width: 1.5.w,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.flight,
                        color:
                            isDarkMode
                                ? lightText.withOpacity(0.7)
                                : darkText.withOpacity(0.6),
                      ),
                    ),
                    validator: (value) {
                      if (_selectedTransport == 'air' &&
                          (value == null || value.isEmpty)) {
                        return 'Please enter flight number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30.h),
                ],

                // Navigation Buttons
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          backgroundColor:
                              isDarkMode
                                  ? const Color(0xFF3C2A21)
                                  : Colors.grey[200],
                        ),
                        child: Text(
                          'Back',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: isDarkMode ? lightText : darkText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Material(
                        borderRadius: BorderRadius.circular(15.r),
                        color: primaryColor,
                        elevation: 4,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15.r),
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const GoodsCurrencyScreen(),
                                ),
                              );
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 15.h),
                            child: Center(
                              child: Text(
                                'Next',
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
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
