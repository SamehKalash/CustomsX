import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IMEICheckerScreen extends StatefulWidget {
  const IMEICheckerScreen({Key? key}) : super(key: key);

  @override
  _IMEICheckerScreenState createState() => _IMEICheckerScreenState();
}

class _IMEICheckerScreenState extends State<IMEICheckerScreen> {
  final TextEditingController _imeiController = TextEditingController();
  Map<String, dynamic>? _phoneInfo;
  bool _isLoading = false;
  bool _showPaymentSection = false;
  bool _isRegistered = false;
  String? _errorMessage;
  bool _isDarkMode = true;

  // Define light and dark theme colors
  late Color _primaryColor;
  late Color _secondaryColor;
  late Color _backgroundColor;
  late Color _cardColor;
  late Color _textColor;
  late Color _secondaryTextColor;

  @override
  void initState() {
    super.initState();
    _imeiController.addListener(() {
      setState(() {});
    });
    _loadThemePreference();
    _updateThemeColors();
  }

  void _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? true;
      _updateThemeColors();
    });
  }

  void _toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = !_isDarkMode;
      prefs.setBool('isDarkMode', _isDarkMode);
      _updateThemeColors();
    });
  }

  void _updateThemeColors() {
    if (_isDarkMode) {
      _primaryColor = const Color(0xFF1A120B);
      _secondaryColor = const Color(0xFF3C2A21);
      _backgroundColor = const Color(0xFF1A120B);
      _cardColor = const Color(0xFF3C2A21);
      _textColor = Colors.white;
      _secondaryTextColor = Colors.white70;
    } else {
      _primaryColor = const Color(0xFFF5EBE0);
      _secondaryColor = const Color(0xFFE3D5CA);
      _backgroundColor = Colors.white;
      _cardColor = const Color(0xFFEDE0D4);
      _textColor = const Color(0xFF1A120B);
      _secondaryTextColor = const Color(0xFF3C2A21);
    }
  }

  @override
  void dispose() {
    _imeiController.dispose();
    super.dispose();
  }

  // Validate IMEI format
  bool _isValidIMEI(String imei) {
    return imei.length == 15 && RegExp(r'^\d{15}$').hasMatch(imei);
  }

  void _checkIMEI() async {
    final imei = _imeiController.text.trim();
    if (!_isValidIMEI(imei)) {
      setState(() {
        _errorMessage = 'Please enter a valid 15-digit IMEI number.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _phoneInfo = null;
      _showPaymentSection = false;
      _isRegistered = false;
      _errorMessage = null;
    });

    try {
      // Fetch phone info from the API
      final phoneInfo = await ApiService.fetchPhoneType(imei);

      setState(() {
        _isLoading = false;
        _phoneInfo = phoneInfo;
        _showPaymentSection = true;
        _isRegistered = phoneInfo['is_registered'] ?? false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
      
      // Show a snackbar with the error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage!),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _processPayment() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      // Actually register the IMEI
      final result = await ApiService.registerIMEI(_imeiController.text.trim());
      
      // Get the updated IMEI record
      final imeiRecord = result['imeiRecord'];
      
      // Update the UI based on the result
      setState(() {
        _isLoading = false;
        _isRegistered = true;
        
        // Update the phone info with the registered status and any other updated fields
        if (_phoneInfo != null && imeiRecord != null) {
          _phoneInfo = imeiRecord;
        } else if (_phoneInfo != null) {
          _phoneInfo!['is_registered'] = true;
        }
      });
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('IMEI successfully registered!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
      
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage!),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'IMEI Checker',
          style: TextStyle(color: _textColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: _primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: _textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: _textColor,
            ),
            onPressed: _toggleTheme,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_backgroundColor, _backgroundColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter IMEI Number',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: _secondaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: TextField(
                    controller: _imeiController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      counterText: '',
                      hintText: 'Type 15-digit IMEI number',
                      hintStyle: TextStyle(color: _secondaryTextColor),
                    ),
                    style: TextStyle(color: _textColor, fontSize: 16),
                    keyboardType: TextInputType.number,
                    maxLength: 15,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(15),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      '${_imeiController.text.length}/15',
                      style: TextStyle(
                        color: _imeiController.text.length == 15 ? Colors.green : _secondaryTextColor, 
                        fontSize: 12
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _checkIMEI,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4A373),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      disabledBackgroundColor: const Color(0xFFD4A373).withOpacity(0.7),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Check IMEI',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                if (_errorMessage != null && _phoneInfo == null) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.withOpacity(0.5)),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: _textColor, fontSize: 14),
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                if (_phoneInfo != null) ...[
                  _buildPhoneInfoCard(),
                  const SizedBox(height: 16),
                  if (_showPaymentSection && !_isRegistered) ...[
                    _buildPaymentSection(),
                  ],
                  if (_isRegistered) ...[
                    _buildRegistrationConfirmation(),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Device Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _textColor,
            ),
          ),
          const SizedBox(height: 16),
          _infoRow('Brand', _phoneInfo!['brand'] ?? 'Unknown'),
          const SizedBox(height: 8),
          _infoRow('Model', _phoneInfo!['model'] ?? 'Unknown'),
          const SizedBox(height: 8),
          _infoRow('Type', _phoneInfo!['device_type'] ?? 'Unknown'),
          const SizedBox(height: 8),
          _infoRow('OS', _phoneInfo!['operating_system'] ?? 'Unknown'),
          const SizedBox(height: 12),
          Divider(color: _secondaryTextColor.withOpacity(0.3), thickness: 1),
          const SizedBox(height: 12),
          _infoRow(
            'Status',
            _phoneInfo!['is_registered'] == true ? 'Registered' : 'Not Registered',
            isHighlighted: true,
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool isHighlighted = false}) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              color: _secondaryTextColor,
              fontSize: 15,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              color: isHighlighted
                  ? (value == 'Registered' ? Colors.green : Colors.red)
                  : _textColor,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentSection() {
    final fee = _phoneInfo!['fee'] ?? 5000;

    return Container(
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Registration Fee',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _textColor,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              '$fee EGP',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'This fee is required to register your device',
              style: TextStyle(
                fontSize: 14,
                color: _secondaryTextColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _processPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Pay Now',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationConfirmation() {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 48,
          ),
          const SizedBox(height: 16),
          const Text(
            'Device Successfully Registered',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'IMEI: ${_imeiController.text}',
            style: TextStyle(
              fontSize: 15,
              color: _textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Device: ${_phoneInfo?['brand'] ?? ''} ${_phoneInfo?['model'] ?? ''}',
            style: TextStyle(
              fontSize: 15,
              color: _textColor,
            ),
          ),
        ],
      ),
    );
  }
}