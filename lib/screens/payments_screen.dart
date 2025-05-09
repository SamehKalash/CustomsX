import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import 'confirm_payment_screen.dart';
import 'dashboard.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  String? _selectedType;
  final TextEditingController _docController = TextEditingController();
  final List<String> _paymentTypes = [
    'Simplified customs declaration',
    'Customs declaration',
    'Temporary storage',
    'Transport barcode',
    'Fine',
    'Advance payments',
  ];

  final Color _primaryColor = const Color(0xFFD4A373);
  final Color _darkBackground = const Color(0xFF1A120B);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      body: Container(
        decoration: _buildBackgroundGradient(isDarkMode),
        child: Column(
          children: [
            SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap:
                        () => Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (_, __, ___) => const DashboardScreen(),
                            transitionsBuilder:
                                (_, animation, __, child) => SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(-1, 0),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                          ),
                        ),
                    child: Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.white10 : Colors.black12,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: _primaryColor,
                        size: 24.w,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  top: 20.h,
                  bottom: 40.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        'Customs Payments',
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w800,
                          color:
                              isDarkMode ? Color(0xFFF5F5DC) : _darkBackground,
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                    _buildPaymentSection(isDarkMode),
                    SizedBox(height: 40.h),
                    _buildDebtsSection(isDarkMode),
                  ],
                ),
              ),
            ),
          ],
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

  Widget _buildPaymentSection(bool isDarkMode) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF3C2A21) : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Direct Payments',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: _primaryColor,
              ),
            ),
            SizedBox(height: 24.h),
            _buildDropdownField(isDarkMode),
            SizedBox(height: 16.h),
            _buildDocumentInput(isDarkMode),
            SizedBox(height: 24.h),
            _buildSearchButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? _darkBackground : Color(0xFFF5F5DC),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedType,
        decoration: InputDecoration(
          labelText: 'Payment Type',
          labelStyle: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.black54,
            fontSize: 14.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),
        ),
        dropdownColor: isDarkMode ? Color(0xFF3C2A21) : Colors.white,
        style: TextStyle(
          color: isDarkMode ? Color(0xFFF5F5DC) : _darkBackground,
          fontSize: 14.sp,
        ),
        items:
            _paymentTypes
                .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                .toList(),
        onChanged: (value) => setState(() => _selectedType = value),
        icon: Icon(Icons.arrow_drop_down, color: _primaryColor),
      ),
    );
  }

  Widget _buildDocumentInput(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? _darkBackground : Color(0xFFF5F5DC),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextField(
        controller: _docController,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: TextStyle(
          color: isDarkMode ? Color(0xFFF5F5DC) : _darkBackground,
          fontSize: 14.sp,
        ),
        decoration: InputDecoration(
          labelText: 'Document Number',
          labelStyle: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.black54,
            fontSize: 14.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        onPressed: _handleSearch,
        child: Text(
          'Search Payments',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildDebtsSection(bool isDarkMode) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF3C2A21) : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Outstanding Debts',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: _primaryColor,
              ),
            ),
            SizedBox(height: 24.h),
            Container(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              decoration: BoxDecoration(
                color: isDarkMode ? _darkBackground : Color(0xFFF5F5DC),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Text(
                  'No current debts found',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSearch() {
    if (_selectedType != null && _docController.text.isNotEmpty) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder:
              (_, __, ___) => ConfirmPaymentScreen(
                paymentType: _selectedType!,
                documentNumber: _docController.text,
              ),
          transitionsBuilder:
              (_, animation, __, child) => SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: FadeTransition(opacity: animation, child: child),
              ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select payment type and enter document number',
            style: TextStyle(fontSize: 14.sp),
          ),
          backgroundColor: Colors.red[700],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      );
    }
  }
}
