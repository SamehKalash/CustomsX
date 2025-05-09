import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'receipt_screen.dart';
import 'confirm_payment_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // Dashboard-style colors
    final Color background =
        isDarkMode ? const Color(0xFF1A120B) : const Color(0xFFF5F5DC);
    final Color cardColor = isDarkMode ? const Color(0xFF3C2A21) : Colors.white;
    final Color textColor =
        isDarkMode ? const Color(0xFFF5F5DC) : const Color(0xFF1A120B);
    final Color labelColor = isDarkMode ? Colors.white70 : Colors.black54;
    final Color borderColor = isDarkMode ? Colors.white10 : Colors.grey[300]!;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: isDarkMode ? const Color(0xFF3C2A21) : Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Electronic customs payments',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w700,
            fontSize: 17.sp,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Tooltip(
              message:
                  'In the Debts section, only payments related to your Tax Identification Number (TIN) or Customs Registration Number are displayed. You can use the Direct Payments section to make any other customs payments',
              child: CircleAvatar(
                backgroundColor: const Color(0xFFD4A373).withOpacity(0.2),
                child: Icon(Icons.info_outline, color: Color(0xFFD4A373)),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 32.h, horizontal: 16.w),
            padding: EdgeInsets.symmetric(vertical: 28.h, horizontal: 20.w),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(18.r),
              boxShadow: [
                BoxShadow(
                  color:
                      isDarkMode
                          ? Colors.black.withOpacity(0.18)
                          : Colors.grey.withOpacity(0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(color: borderColor, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Direct payments',
                  style: TextStyle(
                    color: labelColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 20.h),
                Container(
                  decoration: BoxDecoration(
                    color:
                        isDarkMode ? const Color(0xFF1A120B) : Colors.grey[50],
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: borderColor, width: 1),
                  ),
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: _selectedType,
                        decoration: InputDecoration(
                          labelText: 'Type of payment',
                          labelStyle: TextStyle(
                            color: labelColor,
                            fontWeight: FontWeight.w600,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                        ),
                        dropdownColor: cardColor,
                        icon: Icon(Icons.arrow_drop_down, color: labelColor),
                        items:
                            _paymentTypes
                                .map(
                                  (type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(
                                      type,
                                      style: TextStyle(
                                        color: textColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value;
                          });
                        },
                      ),
                      Divider(height: 1, color: borderColor),
                      TextField(
                        controller: _docController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Document number',
                          labelStyle: TextStyle(
                            color: labelColor,
                            fontWeight: FontWeight.w600,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4A373),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      elevation: 2,
                    ),
                    onPressed: () {
                      if (_selectedType != null &&
                          _docController.text.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ConfirmPaymentScreen(
                                  paymentType: _selectedType!,
                                  documentNumber: _docController.text,
                                ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Please select a payment type and enter document number',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red[700],
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Search',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 36.h),
                Text(
                  'Debts',
                  style: TextStyle(
                    color: labelColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 32.h),
                  decoration: BoxDecoration(
                    color:
                        isDarkMode ? const Color(0xFF3C2A21) : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: Text(
                      'No information found',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                        fontWeight: FontWeight.w700,
                        fontSize: 20.sp,
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
