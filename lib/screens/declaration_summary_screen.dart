import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../theme/theme_provider.dart';
import 'goods_currency_screen.dart';
import 'dashboard.dart'; // Fixed import path
import 'logistics_booking_screen.dart';

class DeclarationSummaryScreen extends StatefulWidget {
  final List<CurrencyEntry> currencies;
  final List<GoodsEntry> goods;

  const DeclarationSummaryScreen({
    super.key,
    required this.currencies,
    required this.goods,
  });

  @override
  State<DeclarationSummaryScreen> createState() =>
      _DeclarationSummaryScreenState();
}

class _DeclarationSummaryScreenState extends State<DeclarationSummaryScreen> {
  bool _declarationAccepted = false;
  final Color primaryColor = const Color(0xFFD4A373);
  final Color darkText = const Color(0xFF1A120B);
  final Color lightText = const Color(0xFFF5F5DC);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    // Calculate total value
    double totalUsdValue = 0.0;

    // Add goods values
    for (var good in widget.goods) {
      totalUsdValue += good.invoicePrice;
    }

    // Calculate customs fees if total exceeds 800 USD
    double customsFees = 0.0;
    double customsXFees = 0.0;
    double totalWithFees = totalUsdValue;

    if (totalUsdValue > 800) {
      customsFees = totalUsdValue * 0.12 * 10; // 2.5% customs fee
      customsXFees = totalUsdValue * 0.02 * 10; // 2% CustomsX fee
      totalWithFees = totalUsdValue + customsFees + customsXFees;
    }

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
          'Declaration Summary',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: isDarkMode ? lightText : darkText,
          ),
        ),
        backgroundColor: isDarkMode ? darkText : Colors.white,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.1),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors:
                isDarkMode
                    ? [
                      darkText,
                      const Color(0xFF3C2A21),
                      primaryColor.withOpacity(0.2),
                    ]
                    : [
                      Colors.white,
                      const Color(0xFFF8F5F0),
                      const Color(0xFFE8E0D6),
                    ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Information Card
                    Card(
                      color:
                          isDarkMode ? const Color(0xFF3C2A21) : Colors.white,
                      elevation: isDarkMode ? 2 : 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dear ${user != null ? "${user['firstName'] ?? 'Guest'} ${user['lastName'] ?? ''}" : "Guest"}',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: isDarkMode ? lightText : darkText,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              'You have imported goods worth of:',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color:
                                    isDarkMode
                                        ? lightText.withOpacity(0.8)
                                        : darkText.withOpacity(0.8),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              '\$${totalUsdValue.toStringAsFixed(2)} USD',
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w700,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Declaration Details Card
                    Card(
                      color:
                          isDarkMode ? const Color(0xFF3C2A21) : Colors.white,
                      elevation: isDarkMode ? 2 : 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Declaration Details',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: isDarkMode ? lightText : darkText,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            _buildDetailRow(
                              'Currencies Declared:',
                              '${widget.currencies.length}',
                              isDarkMode,
                            ),
                            SizedBox(height: 8.h),
                            _buildDetailRow(
                              'Items Declared:',
                              '${widget.goods.length}',
                              isDarkMode,
                            ),
                            SizedBox(height: 8.h),
                            _buildDetailRow(
                              'Declaration Type:',
                              'Personal Import',
                              isDarkMode,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Currency Breakdown if currencies exist
                    if (widget.currencies.isNotEmpty) ...[
                      Card(
                        color:
                            isDarkMode ? const Color(0xFF3C2A21) : Colors.white,
                        elevation: isDarkMode ? 2 : 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Currency Breakdown',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isDarkMode ? lightText : darkText,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              ...widget.currencies
                                  .map(
                                    (currency) => Column(
                                      children: [
                                        _buildDetailRow(
                                          currency.name,
                                          '${currency.amount.toStringAsFixed(2)}',
                                          isDarkMode,
                                        ),
                                        SizedBox(height: 8.h),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                    ],

                    // Fees Breakdown Card
                    if (totalUsdValue > 800) ...[
                      Card(
                        color:
                            isDarkMode ? const Color(0xFF3C2A21) : Colors.white,
                        elevation: isDarkMode ? 2 : 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Fees Breakdown',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isDarkMode ? lightText : darkText,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              _buildFeeRow(
                                'Customs Fees',
                                customsFees,
                                isDarkMode,
                              ),
                              SizedBox(height: 8.h),
                              _buildFeeRow(
                                'CustomsX Fee (2%)',
                                customsXFees,
                                isDarkMode,
                              ),
                              Divider(
                                color:
                                    isDarkMode
                                        ? lightText.withOpacity(0.2)
                                        : darkText.withOpacity(0.2),
                                height: 32.h,
                              ),
                              _buildFeeRow(
                                'Total with Fees',
                                totalWithFees,
                                isDarkMode,
                                isTotal: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ] else ...[
                      Card(
                        color:
                            isDarkMode ? const Color(0xFF3C2A21) : Colors.white,
                        elevation: isDarkMode ? 2 : 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Text(
                            'Customs duties for not exceeding the limit of 800 USD are not charged.',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontStyle: FontStyle.italic,
                              color: isDarkMode ? lightText : darkText,
                            ),
                          ),
                        ),
                      ),
                    ],
                    SizedBox(height: 24.h),

                    // Declaration Checkbox
                    Card(
                      color:
                          isDarkMode ? const Color(0xFF3C2A21) : Colors.white,
                      elevation: isDarkMode ? 2 : 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 24.w,
                              height: 24.h,
                              child: Checkbox(
                                value: _declarationAccepted,
                                onChanged: (value) {
                                  setState(
                                    () => _declarationAccepted = value ?? false,
                                  );
                                },
                                activeColor: primaryColor,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                "I'm aware that by specifying incorrect information in the declaration, I will be liable in accordance with the current legislation.",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: isDarkMode ? lightText : darkText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 15.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                              backgroundColor: isDarkMode ? const Color(0xFF3C2A21) : Colors.grey[200],
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
                          child: ElevatedButton(
                            onPressed: _declarationAccepted
                                ? () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Row(
                                          children: [
                                            Icon(
                                              Icons.check_circle,
                                              color: Colors.white,
                                            ),
                                            SizedBox(width: 12.w),
                                            Text(
                                              'Declaration submitted successfully',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                        backgroundColor: const Color(0xFF2E7D32),
                                        duration: const Duration(seconds: 2),
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.r),
                                        ),
                                      ),
                                    );

                                    // Navigate to dashboard after showing success message
                                    Future.delayed(
                                      const Duration(milliseconds: 1500),
                                      () {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const DashboardScreen(),
                                          ),
                                          (route) => false, // Remove all previous routes
                                        );
                                      },
                                    );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              disabledBackgroundColor: primaryColor.withOpacity(0.5),
                              padding: EdgeInsets.symmetric(vertical: 15.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                            ),
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h), // Add spacing between buttons
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LogisticsBookingScreen(
                              declarationId: "exampleDeclarationId", 
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                      ),
                      child: Text(
                        "Arrange Transport →",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeeRow(
    String label,
    double amount,
    bool isDarkMode, {
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18.sp : 16.sp,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            color: isDarkMode ? lightText : darkText,
          ),
        ),
        Text(
          '\EGP ${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isTotal ? 18.sp : 16.sp,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            color: isDarkMode ? lightText : darkText,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            color:
                isDarkMode
                    ? lightText.withOpacity(0.8)
                    : darkText.withOpacity(0.8),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: isDarkMode ? lightText : darkText,
          ),
        ),
      ],
    );
  }
}
