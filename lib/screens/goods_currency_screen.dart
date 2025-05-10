import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

class GoodsCurrencyScreen extends StatefulWidget {
  const GoodsCurrencyScreen({super.key});

  @override
  State<GoodsCurrencyScreen> createState() => _GoodsCurrencyScreenState();
}

class _GoodsCurrencyScreenState extends State<GoodsCurrencyScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isGoodsSelected = false;
  final List<CurrencyEntry> _currencies = [];
  final TextEditingController _customCurrencyController =
      TextEditingController();

  // Predefined currencies
  final List<String> _commonCurrencies = [
    'United States Dollars (USD)',
    'Russian Ruble (RUB)',
    'Euro (EUR)',
    'Egyptian Pound (EGP)',
  ];

  final List<String> _otherCurrencies = [
    'British Pound (GBP)',
    'Japanese Yen (JPY)',
    'Saudi Riyal (SAR)',
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

  void _addCurrency(String currency) {
    setState(() {
      _currencies.add(
        CurrencyEntry(name: currency, controller: TextEditingController()),
      );
    });
  }

  void _removeCurrency(int index) {
    setState(() {
      _currencies.removeAt(index);
    });
  }

  void _showAddCurrencyDialog(BuildContext context, bool isDarkMode) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor:
                isDarkMode ? const Color(0xFF3C2A21) : Colors.white,
            title: Text(
              'Add Currency',
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _otherCurrencies.length,
                itemBuilder:
                    (context, index) => ListTile(
                      title: Text(
                        _otherCurrencies[index],
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      onTap: () {
                        _addCurrency(_otherCurrencies[index]);
                        Navigator.pop(context);
                      },
                    ),
              ),
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
          'Goods & Currency',
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
              children: [
                // Toggle Buttons
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _isGoodsSelected = false),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            color:
                                !_isGoodsSelected
                                    ? (isDarkMode
                                        ? primaryColor.withOpacity(0.2)
                                        : primaryColor.withOpacity(0.1))
                                    : Colors.transparent,
                            border: Border(
                              bottom: BorderSide(
                                color:
                                    !_isGoodsSelected
                                        ? primaryColor
                                        : Colors.transparent,
                                width: 2.w,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Currency',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color:
                                    !_isGoodsSelected
                                        ? primaryColor
                                        : (isDarkMode
                                            ? lightText.withOpacity(0.6)
                                            : darkText.withOpacity(0.6)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _isGoodsSelected = true),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            color:
                                _isGoodsSelected
                                    ? (isDarkMode
                                        ? primaryColor.withOpacity(0.2)
                                        : primaryColor.withOpacity(0.1))
                                    : Colors.transparent,
                            border: Border(
                              bottom: BorderSide(
                                color:
                                    _isGoodsSelected
                                        ? primaryColor
                                        : Colors.transparent,
                                width: 2.w,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Goods',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color:
                                    _isGoodsSelected
                                        ? primaryColor
                                        : (isDarkMode
                                            ? lightText.withOpacity(0.6)
                                            : darkText.withOpacity(0.6)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.h),

                // Content Area
                Expanded(
                  child:
                      _isGoodsSelected
                          ? Center(
                            child: Text(
                              'Goods Declaration Coming Soon',
                              style: TextStyle(
                                fontSize: 18.sp,
                                color:
                                    isDarkMode
                                        ? lightText.withOpacity(0.8)
                                        : darkText.withOpacity(0.6),
                              ),
                            ),
                          )
                          : ListView(
                            children: [
                              // Predefined Currencies
                              Column(
                                children:
                                    _commonCurrencies.map((currency) {
                                      return _buildCurrencyRow(
                                        context,
                                        currency,
                                        isDarkMode,
                                        primaryColor,
                                        darkText,
                                        lightText,
                                      );
                                    }).toList(),
                              ),

                              // Added Currencies
                              ..._currencies.map(
                                (entry) => _buildEditableCurrencyRow(
                                  context,
                                  entry,
                                  isDarkMode,
                                  primaryColor,
                                  darkText,
                                  lightText,
                                ),
                              ),

                              // Add Currency Button
                              Material(
                                color:
                                    isDarkMode
                                        ? const Color(0xFF3C2A21)
                                        : Colors.white,
                                borderRadius: BorderRadius.circular(10.r),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10.r),
                                  onTap:
                                      () => _showAddCurrencyDialog(
                                        context,
                                        isDarkMode,
                                      ),
                                  child: Container(
                                    padding: EdgeInsets.all(16.w),
                                    child: Row(
                                      children: [
                                        Icon(Icons.add, color: primaryColor),
                                        SizedBox(width: 12.w),
                                        Text(
                                          'Add Other Currency',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            color:
                                                isDarkMode
                                                    ? lightText
                                                    : darkText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                ),

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
                              // Handle submission
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 15.h),
                            child: Center(
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
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencyRow(
    BuildContext context,
    String currency,
    bool isDarkMode,
    Color primaryColor,
    Color darkText,
    Color lightText,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              currency,
              style: TextStyle(
                fontSize: 16.sp,
                color: isDarkMode ? lightText : darkText,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: TextFormField(
              style: TextStyle(
                color: isDarkMode ? lightText : darkText,
                fontSize: 16.sp,
              ),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Amount',
                hintStyle: TextStyle(
                  color:
                      isDarkMode
                          ? lightText.withOpacity(0.5)
                          : darkText.withOpacity(0.4),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableCurrencyRow(
    BuildContext context,
    CurrencyEntry entry,
    bool isDarkMode,
    Color primaryColor,
    Color darkText,
    Color lightText,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              entry.name,
              style: TextStyle(
                fontSize: 16.sp,
                color: isDarkMode ? lightText : darkText,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: entry.controller,
              style: TextStyle(
                color: isDarkMode ? lightText : darkText,
                fontSize: 16.sp,
              ),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Amount',
                hintStyle: TextStyle(
                  color:
                      isDarkMode
                          ? lightText.withOpacity(0.5)
                          : darkText.withOpacity(0.4),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.remove_circle, color: Colors.red[400]),
            onPressed: () => _removeCurrency(_currencies.indexOf(entry)),
          ),
        ],
      ),
    );
  }
}

class CurrencyEntry {
  final String name;
  final TextEditingController controller;

  CurrencyEntry({required this.name, required this.controller});
}
