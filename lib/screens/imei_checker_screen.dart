import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../services/api_service.dart';

class IMEICheckerScreen extends StatefulWidget {
  const IMEICheckerScreen({super.key});

  @override
  State<IMEICheckerScreen> createState() => _IMEICheckerScreenState();
}

class _IMEICheckerScreenState extends State<IMEICheckerScreen> {
  final TextEditingController _imeiController = TextEditingController();
  Map<String, dynamic>? _deviceInfo;
  bool _isLoading = false;
  bool _showPaymentSection = false;
  bool _isRegistered = false;
  String? _errorMessage;
  final Color _primaryColor = const Color(0xFFD4A373);
  final Color _darkBackground = const Color(0xFF1A120B);

  @override
  void initState() {
    super.initState();
    _imeiController.addListener(() => setState(() {}));
  }

  bool _isValidIMEI(String imei) =>
      imei.length == 15 && RegExp(r'^\d{15}$').hasMatch(imei);

  void _checkIMEI() async {
    final imei = _imeiController.text.trim();
    if (!_isValidIMEI(imei)) {
      setState(
        () => _errorMessage = 'Please enter a valid 15-digit IMEI number',
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _deviceInfo = null;
      _showPaymentSection = false;
      _isRegistered = false;
      _errorMessage = null;
    });

    try {
      final response = await ApiService.fetchPhoneType(imei);

      if (!response['valid_tac']) {
        throw Exception('Invalid TAC - Device not recognized');
      }

      setState(() {
        _isLoading = false;
        _deviceInfo = response;
        _showPaymentSection = !(response['is_registered'] ?? false);
        _isRegistered = response['is_registered'] ?? false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
      _showErrorSnackbar(_errorMessage!);
    }
  }

  void _processPayment() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await ApiService.registerIMEI(_imeiController.text.trim());
      final updatedRecord = result['imeiRecord'];

      setState(() {
        _isLoading = false;
        _isRegistered = true;
        _deviceInfo =
            updatedRecord ?? _deviceInfo
              ?..['is_registered'] = true;
      });

      _showSuccessSnackbar('IMEI successfully registered!');
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
      _showErrorSnackbar(_errorMessage!);
    }
  }

  void _showErrorSnackbar(String message) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );

  void _showSuccessSnackbar(String message) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );

  Widget _buildInfoRow(
    String label,
    String value,
    bool isDarkMode, {
    bool isHighlighted = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              color:
                  isDarkMode
                      ? const Color(0xFFF5F5DC).withOpacity(0.8)
                      : _darkBackground.withOpacity(0.8),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
              color:
                  isHighlighted
                      ? (value == 'Registered' ? Colors.green : Colors.red)
                      : (isDarkMode
                          ? const Color(0xFFF5F5DC)
                          : _darkBackground),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'IMEI Customs Checker',
          style: TextStyle(
            fontSize: 24.sp,
            color: isDarkMode ? const Color(0xFFF5F5DC) : _darkBackground,
          ),
        ),
        backgroundColor: isDarkMode ? _darkBackground : Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? const Color(0xFFF5F5DC) : _darkBackground,
          ),
          onPressed: () => Navigator.pop(context),
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
                      _primaryColor.withOpacity(0.2),
                    ]
                    : [
                      Colors.white,
                      const Color(0xFFF5F5DC).withOpacity(0.6),
                      _primaryColor.withOpacity(0.1),
                    ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                SizedBox(height: 20.h),
                TextField(
                  controller: _imeiController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor:
                        isDarkMode ? const Color(0xFF3C2A21) : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Enter 15-digit IMEI number',
                    hintStyle: TextStyle(
                      color:
                          isDarkMode
                              ? const Color(0xFFF5F5DC).withOpacity(0.6)
                              : _darkBackground.withOpacity(0.6),
                    ),
                    counterText: '',
                    contentPadding: EdgeInsets.all(16.w),
                  ),
                  style: TextStyle(
                    fontSize: 16.sp,
                    color:
                        isDarkMode ? const Color(0xFFF5F5DC) : _darkBackground,
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 15,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Text(
                      '${_imeiController.text.length}/15',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color:
                            _imeiController.text.length == 15
                                ? _primaryColor
                                : (isDarkMode
                                    ? const Color(0xFFF5F5DC).withOpacity(0.6)
                                    : _darkBackground.withOpacity(0.6)),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _checkIMEI,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child:
                        _isLoading
                            ? SizedBox(
                              width: 20.w,
                              height: 20.w,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : Text(
                              'Check IMEI',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                  ),
                ),
                if (_errorMessage != null && _deviceInfo == null)
                  Padding(
                    padding: EdgeInsets.only(top: 16.h),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color:
                              isDarkMode
                                  ? const Color(0xFFF5F5DC)
                                  : _darkBackground,
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: 20.h),
                if (_deviceInfo != null) ...[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color:
                          isDarkMode ? const Color(0xFF3C2A21) : Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 5.h),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          'Brand',
                          _deviceInfo!['brand'] ?? 'Unknown',
                          isDarkMode,
                        ),
                        _buildInfoRow(
                          'Model',
                          _deviceInfo!['model'] ?? 'Unknown',
                          isDarkMode,
                        ),
                        _buildInfoRow(
                          'Type',
                          _deviceInfo!['device_type'] ?? 'Unknown',
                          isDarkMode,
                        ),
                        SizedBox(height: 12.h),
                        _buildInfoRow(
                          'Status',
                          _deviceInfo!['is_registered']
                              ? 'Registered'
                              : 'Not Registered',
                          isDarkMode,
                          isHighlighted: true,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
                if (_showPaymentSection) ...[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color:
                          isDarkMode ? const Color(0xFF3C2A21) : Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 5.h),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Registration Fee',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color:
                                isDarkMode
                                    ? const Color(0xFFF5F5DC)
                                    : _darkBackground,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          '${_deviceInfo?['fee']} EGP',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: _primaryColor,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _processPayment,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryColor,
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child:
                                _isLoading
                                    ? SizedBox(
                                      width: 20.w,
                                      height: 20.w,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : Text(
                                      'Pay Now through CustomsX',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
                if (_isRegistered)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color:
                          isDarkMode ? const Color(0xFF3C2A21) : Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 5.h),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 40.w,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'Registration Successful',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'IMEI: ${_imeiController.text}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color:
                                isDarkMode
                                    ? const Color(0xFFF5F5DC)
                                    : _darkBackground,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _imeiController.dispose();
    super.dispose();
  }
}
