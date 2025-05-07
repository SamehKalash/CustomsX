import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../services/api_service.dart';

class CustomsCalculatorScreen extends StatefulWidget {
  const CustomsCalculatorScreen({super.key});

  @override
  State<CustomsCalculatorScreen> createState() =>
      _CustomsCalculatorScreenState();
}

class _CustomsCalculatorScreenState extends State<CustomsCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _hsCodeController = TextEditingController();
  final _invoiceController = TextEditingController();
  final _transportController = TextEditingController();
  final _otherExpensesController = TextEditingController();

  int _declarationMode = 1;
  Map<String, dynamic>? _calculationResult;
  bool _isLoading = false;
  final Color _primaryColor = const Color(0xFFD4A373);
  final Color _darkBackground = const Color(0xFF1A120B);

  Future<void> _calculateDuty() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Validate HS Code first
      await ApiService.validateHscode(
        declarationMode: _declarationMode,
        code: _hsCodeController.text,
      );

      // Proceed with calculation
      final result = await ApiService.calculateDuty(
        declarationMode: _declarationMode,
        hsCode: _hsCodeController.text,
        invoice: double.parse(_invoiceController.text),
        transportExpenses: double.parse(_transportController.text),
        otherExpenses: double.parse(_otherExpensesController.text),
      );

      setState(() => _calculationResult = result);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: _primaryColor,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Customs Calculator',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: isDarkMode ? const Color(0xFFF5F5DC) : _darkBackground,
          ),
        ),
        backgroundColor: isDarkMode ? _darkBackground : Colors.white,
        elevation: 4,
        iconTheme: IconThemeData(
          color: isDarkMode ? const Color(0xFFF5F5DC) : _darkBackground,
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
                      _darkBackground,
                      const Color(0xFF3C2A21),
                      const Color(0xFFD4A373).withOpacity(0.2),
                    ]
                    : [
                      Colors.white,
                      const Color(0xFFF5F5DC).withOpacity(0.6),
                      const Color(0xFFD4A373).withOpacity(0.1),
                    ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDeclarationModeDropdown(isDarkMode),
                  SizedBox(height: 20.h),
                  _buildHsCodeField(isDarkMode),
                  SizedBox(height: 20.h),
                  _buildInvoiceField(isDarkMode),
                  SizedBox(height: 20.h),
                  _buildTransportField(isDarkMode),
                  SizedBox(height: 20.h),
                  _buildOtherExpensesField(isDarkMode),
                  SizedBox(height: 30.h),
                  _buildCalculateButton(),
                  if (_calculationResult != null)
                    _buildResultsSection(isDarkMode),
                  SizedBox(height: 40.h), // Extra space for scrolling
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeclarationModeDropdown(bool isDarkMode) {
    return DropdownButtonFormField<int>(
      value: _declarationMode,
      dropdownColor: isDarkMode ? const Color(0xFF3C2A21) : Colors.white,
      style: TextStyle(
        fontSize: 14.sp,
        color: isDarkMode ? const Color(0xFFF5F5DC) : _darkBackground,
      ),
      items: [
        DropdownMenuItem(
          value: 1,
          child: Text('Import', style: TextStyle(fontSize: 14.sp)),
        ),
        DropdownMenuItem(
          value: 2,
          child: Text('Export', style: TextStyle(fontSize: 14.sp)),
        ),
      ],
      onChanged: (value) => setState(() => _declarationMode = value!),
      decoration: InputDecoration(
        labelText: 'Declaration Mode',
        labelStyle: TextStyle(
          fontSize: 14.sp,
          color:
              isDarkMode
                  ? const Color(0xFFF5F5DC).withOpacity(0.7)
                  : _darkBackground.withOpacity(0.6),
        ),
        filled: true,
        fillColor: isDarkMode ? const Color(0xFF3C2A21) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: _primaryColor, width: 1.w),
        ),
      ),
    );
  }

  Widget _buildHsCodeField(bool isDarkMode) {
    return TextFormField(
      controller: _hsCodeController,
      style: TextStyle(
        fontSize: 14.sp,
        color: isDarkMode ? const Color(0xFFF5F5DC) : _darkBackground,
      ),
      decoration: InputDecoration(
        labelText: 'HS Code',
        labelStyle: TextStyle(
          fontSize: 14.sp,
          color:
              isDarkMode
                  ? const Color(0xFFF5F5DC).withOpacity(0.7)
                  : _darkBackground.withOpacity(0.6),
        ),
        prefixIcon: Icon(Icons.code_rounded, color: _primaryColor, size: 24.w),
        filled: true,
        fillColor: isDarkMode ? const Color(0xFF3C2A21) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: _primaryColor, width: 1.w),
        ),
        errorStyle: TextStyle(fontSize: 12.sp),
      ),
      validator: (v) => v!.length == 10 ? null : 'Must be 10 digits',
    );
  }

  Widget _buildInvoiceField(bool isDarkMode) {
    return TextFormField(
      controller: _invoiceController,
      keyboardType: TextInputType.number,
      style: TextStyle(
        fontSize: 14.sp,
        color: isDarkMode ? const Color(0xFFF5F5DC) : _darkBackground,
      ),
      decoration: InputDecoration(
        labelText: 'Invoice Value (USD)',
        labelStyle: TextStyle(
          fontSize: 14.sp,
          color:
              isDarkMode
                  ? const Color(0xFFF5F5DC).withOpacity(0.7)
                  : _darkBackground.withOpacity(0.6),
        ),
        prefixIcon: Icon(
          Icons.attach_money_rounded,
          color: _primaryColor,
          size: 24.w,
        ),
        filled: true,
        fillColor: isDarkMode ? const Color(0xFF3C2A21) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: _primaryColor, width: 1.w),
        ),
        errorStyle: TextStyle(fontSize: 12.sp),
      ),
      validator: (v) => v!.isEmpty ? 'Required field' : null,
    );
  }

  Widget _buildTransportField(bool isDarkMode) {
    return TextFormField(
      controller: _transportController,
      keyboardType: TextInputType.number,
      style: TextStyle(
        fontSize: 14.sp,
        color: isDarkMode ? const Color(0xFFF5F5DC) : _darkBackground,
      ),
      decoration: InputDecoration(
        labelText: 'Transport Expenses',
        labelStyle: TextStyle(
          fontSize: 14.sp,
          color:
              isDarkMode
                  ? const Color(0xFFF5F5DC).withOpacity(0.7)
                  : _darkBackground.withOpacity(0.6),
        ),
        prefixIcon: Icon(
          Icons.local_shipping_rounded,
          color: _primaryColor,
          size: 24.w,
        ),
        filled: true,
        fillColor: isDarkMode ? const Color(0xFF3C2A21) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: _primaryColor, width: 1.w),
        ),
      ),
    );
  }

  Widget _buildOtherExpensesField(bool isDarkMode) {
    return TextFormField(
      controller: _otherExpensesController,
      keyboardType: TextInputType.number,
      style: TextStyle(
        fontSize: 14.sp,
        color: isDarkMode ? const Color(0xFFF5F5DC) : _darkBackground,
      ),
      decoration: InputDecoration(
        labelText: 'Other Expenses',
        labelStyle: TextStyle(
          fontSize: 14.sp,
          color:
              isDarkMode
                  ? const Color(0xFFF5F5DC).withOpacity(0.7)
                  : _darkBackground.withOpacity(0.6),
        ),
        prefixIcon: Icon(
          Icons.receipt_long_rounded,
          color: _primaryColor,
          size: 24.w,
        ),
        filled: true,
        fillColor: isDarkMode ? const Color(0xFF3C2A21) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: _primaryColor, width: 1.w),
        ),
      ),
    );
  }

  Widget _buildCalculateButton() {
    return _isLoading
        ? Center(child: CircularProgressIndicator(color: _primaryColor))
        : ElevatedButton(
          onPressed: _calculateDuty,
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryColor,
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 50.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            elevation: 4,
          ),
          child: Text(
            'Calculate Duties',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
        );
  }

  Widget _buildResultsSection(bool isDarkMode) {
    if (_calculationResult == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 30.h),
        Text(
          'Calculation Results:',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: isDarkMode ? const Color(0xFFF5F5DC) : _darkBackground,
          ),
        ),
        SizedBox(height: 20.h),
        ...(_calculationResult?['duties'] as List?)?.map(
              (duty) => ListTile(
                title: Text(
                  duty['name'],
                  style: TextStyle(
                    fontSize: 14.sp,
                    color:
                        isDarkMode ? const Color(0xFFF5F5DC) : _darkBackground,
                  ),
                ),
                trailing: Text(
                  '${duty['value']?.toStringAsFixed(2) ?? '0.00'} EGP',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: _primaryColor,
                  ),
                ),
              ),
            ) ??
            [],
        Divider(color: _primaryColor.withOpacity(0.3)),
        ListTile(
          title: Text(
            'Total Customs Duties',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: isDarkMode ? const Color(0xFFF5F5DC) : _darkBackground,
            ),
          ),
          trailing: Text(
            '${_calculationResult?['total']?['value']?.toStringAsFixed(2) ?? '0.00'} EGP',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: _primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
