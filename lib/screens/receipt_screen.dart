import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReceiptScreen extends StatefulWidget {
  final String paymentType;
  final String documentNumber;

  const ReceiptScreen({
    Key? key,
    required this.paymentType,
    required this.documentNumber,
  }) : super(key: key);

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Payment Confirmed!'),
          backgroundColor: const Color(0xFFD4A373),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color background =
        isDarkMode ? const Color(0xFF1A120B) : const Color(0xFFF5F5DC);
    final Color cardColor = isDarkMode ? const Color(0xFF3C2A21) : Colors.white;
    final Color textColor =
        isDarkMode ? const Color(0xFFF5F5DC) : const Color(0xFF1A120B);
    final Color labelColor = isDarkMode ? Colors.white70 : Colors.black54;
    final Color borderColor = isDarkMode ? Colors.white10 : Colors.grey[300]!;

    // Mock data in EGP
    final String issuerRIN = "EG-1234567890";
    final String dateTime = DateTime.now().toString();
    final String customsDeclarationNumber = "ACI-2024-00012345";
    final String importerName = "Tech Importers Ltd.";
    final String importerTaxId = "TIN-987654321";
    final String goodsDescription = "Temporary storage fees for electronics";
    final String receiptNumber = "RCPT-20240509-001";
    final String paymentMethod = "Electronic Transfer";
    final double amountPaidEGP = 1500.00;
    final double customsDutyEGP = 1000.00;
    final double vatEGP = 400.00;
    final double serviceFeeEGP = 100.00;

    // Format all values in EGP
    String format(double egp) => "E£ ${egp.toStringAsFixed(2)}";
    String taxBreakdown =
        "Customs Duty: ${format(customsDutyEGP)}\n"
        "VAT: ${format(vatEGP)}\n"
        "Service Fee: ${format(serviceFeeEGP)}";

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Receipt',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w700,
            fontSize: 20.sp,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color:
                      isDarkMode
                          ? Colors.black.withOpacity(0.12)
                          : Colors.grey.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: borderColor, width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Icon(
                    Icons.receipt_long,
                    size: 48.w,
                    color: const Color(0xFFD4A373),
                    semanticLabel: 'Receipt Icon',
                  ),
                ),
                SizedBox(height: 16.h),
                Center(
                  child: Text(
                    'Payment Receipt',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22.sp,
                      color: textColor,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                _receiptRow(
                  'Receipt Number:',
                  receiptNumber,
                  textColor,
                  labelColor,
                ),
                SizedBox(height: 8.h),
                _receiptRow(
                  'Customs Declaration No:',
                  customsDeclarationNumber,
                  textColor,
                  labelColor,
                ),
                SizedBox(height: 8.h),
                _receiptRow(
                  'Importer Name:',
                  importerName,
                  textColor,
                  labelColor,
                ),
                SizedBox(height: 8.h),
                _receiptRow(
                  'Importer Tax ID:',
                  importerTaxId,
                  textColor,
                  labelColor,
                ),
                SizedBox(height: 8.h),
                _receiptRow(
                  'Description of Goods/Services:',
                  goodsDescription,
                  textColor,
                  labelColor,
                ),
                SizedBox(height: 8.h),
                _receiptRow(
                  'Payment Method:',
                  paymentMethod,
                  textColor,
                  labelColor,
                ),
                SizedBox(height: 8.h),
                _receiptRow(
                  'Tax Breakdown:',
                  taxBreakdown,
                  textColor,
                  labelColor,
                ),
                SizedBox(height: 8.h),
                _receiptRow(
                  'Total Amount Paid:',
                  format(amountPaidEGP),
                  textColor,
                  labelColor,
                ),
                SizedBox(height: 8.h),
                _receiptRow(
                  'Issuer\'s Registration No:',
                  issuerRIN,
                  textColor,
                  labelColor,
                ),
                SizedBox(height: 8.h),
                _receiptRow('Date & Time:', dateTime, textColor, labelColor),
                SizedBox(height: 8.h),
                _receiptRow(
                  'Exchange Rate:',
                  '1 USD = 51.7143 EGP',
                  textColor,
                  labelColor,
                ),
                SizedBox(height: 24.h),
                Divider(color: borderColor),
                SizedBox(height: 16.h),
                Center(
                  child: Text(
                    'WHAT ARE YOU WAITING FOR!',
                    style: TextStyle(
                      color: const Color(0xFFD4A373),
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.payment),
                    label: const Text('Pay through CustomsX'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4A373),
                      foregroundColor:
                          isDarkMode ? const Color(0xFF1A120B) : Colors.white,
                      textStyle: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      elevation: 2,
                    ),
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).pushNamedAndRemoveUntil('/dashboard', (route) => false);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _receiptRow(
    String label,
    String value,
    Color textColor,
    Color labelColor,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: TextStyle(
                color: labelColor,
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
