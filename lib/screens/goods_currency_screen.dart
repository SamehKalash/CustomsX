import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import 'declaration_summary_screen.dart';

class FoodCategory {
  static const List<String> subcategories = ['Food', 'Fruit Juices'];
}

class UnitType {
  static const List<String> units = ['unit', 'kg', 'g', 'carat', 'm2', 'm'];
}

class MediaEquipmentCategory {
  static const List<String> subcategories = [
    'Audio Description Service (ADS)',
    'Mass Cast',
    'FM Radio',
    'Camera sets for cars',
    'Digital Cameras',
    'DVR',
    'Interpretation Service Equipment',
    'Memory Cards and flash cards for cameras',
    'Objective Lenses',
    'Other',
    'Photographer wireless remote',
    'Wireless video cameras',
    'Wireless Microphone',
  ];
}

class GoodsCurrencyScreen extends StatefulWidget {
  const GoodsCurrencyScreen({super.key});

  @override
  State<GoodsCurrencyScreen> createState() => _GoodsCurrencyScreenState();
}

class _GoodsCurrencyScreenState extends State<GoodsCurrencyScreen> {
  bool _showGoodsSection = false;
  final List<CurrencyEntry> _currencies = [];
  final List<GoodsEntry> _goods = [];

  // Predefined currencies
  final List<String> _commonCurrencies = [
    'United States Dollars (USD)',
    'Russian Ruble (RUB)',
    'Euro (EUR)',
    'Egyptian Pound (EGP)',
  ];

  final List<String> _goodsCategories = [
    'Food',
    'Media Equipment',
    'Fur Clothing Items',
    'Other',
  ];

  void _showAmountInputDialog(
    BuildContext context,
    String currency,
    bool isDarkMode,
  ) {
    final amountController = TextEditingController();
    final primaryColor = const Color(0xFFD4A373);
    final darkText = const Color(0xFF1A120B);
    final lightText = const Color(0xFFF5F5DC);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: isDarkMode ? darkText : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
            title: Text(
              'Add $currency',
              style: TextStyle(
                color: isDarkMode ? lightText : darkText,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    color: isDarkMode ? lightText : darkText,
                    fontSize: 16.sp,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    labelStyle: TextStyle(
                      color:
                          isDarkMode
                              ? lightText.withOpacity(0.7)
                              : darkText.withOpacity(0.6),
                    ),
                    hintText: 'Enter amount',
                    hintStyle: TextStyle(
                      color:
                          isDarkMode
                              ? lightText.withOpacity(0.3)
                              : darkText.withOpacity(0.3),
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
                      Icons.attach_money,
                      color:
                          isDarkMode
                              ? lightText.withOpacity(0.7)
                              : darkText.withOpacity(0.6),
                      size: 20.w,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color:
                        isDarkMode
                            ? lightText.withOpacity(0.7)
                            : darkText.withOpacity(0.6),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (amountController.text.isNotEmpty) {
                    final amount =
                        double.tryParse(amountController.text) ?? 0.0;
                    setState(() {
                      _currencies.add(
                        CurrencyEntry(
                          name: currency,
                          amount: amount,
                          controller: TextEditingController(
                            text: amount.toString(),
                          ),
                        ),
                      );
                    });
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                ),
                child: Text(
                  'Add',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
            ],
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

  void _removeCurrency(int index) {
    setState(() => _currencies.removeAt(index));
  }

  void _updateCurrencyAmount(int index, String newAmount) {
    setState(() {
      final amount = double.tryParse(newAmount) ?? _currencies[index].amount;
      _currencies[index] = CurrencyEntry(
        name: _currencies[index].name,
        amount: amount,
        controller: _currencies[index].controller,
      );
    });
  }

  void _addGood(GoodsEntry good) {
    setState(() => _goods.add(good));
  }

  void _removeGood(int index) {
    setState(() => _goods.removeAt(index));
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
          'Declaration Items',
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
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildToggleButton(
                    'Currency',
                    !_showGoodsSection,
                    () => setState(() => _showGoodsSection = false),
                    isDarkMode,
                    primaryColor,
                    darkText,
                    lightText,
                  ),
                  SizedBox(width: 16.w),
                  _buildToggleButton(
                    'Goods',
                    _showGoodsSection,
                    () => setState(() => _showGoodsSection = true),
                    isDarkMode,
                    primaryColor,
                    darkText,
                    lightText,
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              Expanded(
                child:
                    _showGoodsSection
                        ? _buildGoodsSection(
                          isDarkMode,
                          primaryColor,
                          darkText,
                          lightText,
                        )
                        : _buildCurrencySection(
                          isDarkMode,
                          primaryColor,
                          darkText,
                          lightText,
                        ),
              ),
              SizedBox(height: 20.h),
              _buildActionButtons(
                isDarkMode,
                primaryColor,
                darkText,
                lightText,
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton(
    String text,
    bool isActive,
    VoidCallback onTap,
    bool isDarkMode,
    Color primaryColor,
    Color darkText,
    Color lightText,
  ) {
    return Expanded(
      child: Material(
        borderRadius: BorderRadius.circular(15.r),
        color: Colors.transparent,
        elevation: 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(15.r),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color:
                  isActive
                      ? (isDarkMode ? const Color(0xFF3C2A21) : Colors.white)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(
                color:
                    isDarkMode
                        ? lightText.withOpacity(isActive ? 0.3 : 0.15)
                        : darkText.withOpacity(isActive ? 0.3 : 0.15),
              ),
              boxShadow: [
                if (!isDarkMode && isActive)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: Offset(0, 3.h),
                  ),
              ],
            ),
            padding: EdgeInsets.symmetric(vertical: 15.h),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color:
                      isActive
                          ? (isDarkMode ? lightText : primaryColor)
                          : (isDarkMode
                              ? lightText.withOpacity(0.6)
                              : darkText.withOpacity(0.6)),
                  fontSize: 16.sp,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencyItem(
    String currency,
    bool isDarkMode,
    Color darkText,
    Color lightText,
  ) {
    final isAdded = _currencies.any((entry) => entry.name == currency);
    final entry = _currencies.firstWhere(
      (entry) => entry.name == currency,
      orElse:
          () => CurrencyEntry(
            name: currency,
            controller: TextEditingController(),
          ),
    );

    return Card(
      color: isDarkMode ? const Color(0xFF3C2A21) : Colors.white,
      elevation: isDarkMode ? 2 : 4,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              currency,
              style: TextStyle(
                color: isDarkMode ? lightText : darkText,
                fontSize: 16.sp,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                isAdded ? Icons.arrow_drop_down : Icons.add,
                color:
                    isDarkMode
                        ? lightText.withOpacity(0.7)
                        : darkText.withOpacity(0.6),
              ),
              onPressed: () {
                if (!isAdded) {
                  _showAmountInputDialog(context, currency, isDarkMode);
                } else {
                  _removeCurrency(
                    _currencies.indexWhere((e) => e.name == currency),
                  );
                }
              },
            ),
          ),
          if (isAdded) ...[
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
              child: TextField(
                controller: entry.controller,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  color: isDarkMode ? lightText : darkText,
                  fontSize: 16.sp,
                ),
                onChanged:
                    (value) => _updateCurrencyAmount(
                      _currencies.indexWhere((e) => e.name == currency),
                      value,
                    ),
                decoration: InputDecoration(
                  labelText: 'Amount',
                  labelStyle: TextStyle(
                    color:
                        isDarkMode
                            ? lightText.withOpacity(0.7)
                            : darkText.withOpacity(0.6),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(
                      color:
                          isDarkMode
                              ? lightText.withOpacity(0.3)
                              : darkText.withOpacity(0.2),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(
                      color: const Color(0xFFD4A373),
                      width: 1.5.w,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  prefixIcon: Icon(
                    Icons.attach_money,
                    color:
                        isDarkMode
                            ? lightText.withOpacity(0.7)
                            : darkText.withOpacity(0.6),
                    size: 20.w,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCurrencySection(
    bool isDarkMode,
    Color primaryColor,
    Color darkText,
    Color lightText,
  ) {
    return Column(
      children: [
        Material(
          color: primaryColor.withOpacity(isDarkMode ? 0.1 : 0.15),
          shape: const CircleBorder(),
          elevation: isDarkMode ? 2 : 4,
          shadowColor: primaryColor.withOpacity(0.25),
          child: Padding(
            padding: EdgeInsets.all(25.w),
            child: Icon(
              Icons.currency_exchange,
              color: isDarkMode ? primaryColor : primaryColor.withOpacity(0.9),
              size: 60.w,
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          'Select currencies for your declaration',
          style: TextStyle(
            color:
                isDarkMode
                    ? lightText.withOpacity(0.85)
                    : darkText.withOpacity(0.8),
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
        ),
        SizedBox(height: 30.h),
        Expanded(
          child: ListView(
            children:
                _commonCurrencies
                    .map(
                      (currency) => _buildCurrencyItem(
                        currency,
                        isDarkMode,
                        darkText,
                        lightText,
                      ),
                    )
                    .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildGoodsSection(
    bool isDarkMode,
    Color primaryColor,
    Color darkText,
    Color lightText,
  ) {
    return Column(
      children: [
        Material(
          color: primaryColor.withOpacity(isDarkMode ? 0.1 : 0.15),
          shape: const CircleBorder(),
          elevation: isDarkMode ? 2 : 4,
          shadowColor: primaryColor.withOpacity(0.25),
          child: Padding(
            padding: EdgeInsets.all(25.w),
            child: Icon(
              Icons.inventory,
              color: isDarkMode ? primaryColor : primaryColor.withOpacity(0.9),
              size: 60.w,
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          'Select category to add goods',
          style: TextStyle(
            color:
                isDarkMode
                    ? lightText.withOpacity(0.85)
                    : darkText.withOpacity(0.8),
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
        ),
        SizedBox(height: 20.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          alignment: WrapAlignment.center,
          children:
              _goodsCategories
                  .map(
                    (category) => _buildCategoryButton(
                      category,
                      isDarkMode,
                      primaryColor,
                      darkText,
                      lightText,
                    ),
                  )
                  .toList(),
        ),
        SizedBox(height: 20.h),
        Expanded(
          child: ListView.builder(
            itemCount: _goods.length,
            itemBuilder:
                (context, index) => _buildGoodsItem(
                  index,
                  _goods[index],
                  isDarkMode,
                  darkText,
                  lightText,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryButton(
    String category,
    bool isDarkMode,
    Color primaryColor,
    Color darkText,
    Color lightText,
  ) {
    return Material(
      color: isDarkMode ? const Color(0xFF3C2A21) : Colors.white,
      elevation: isDarkMode ? 2 : 4,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap:
            () => _showAddGoodDialog(
              context,
              category,
              isDarkMode,
              darkText,
              lightText,
            ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add,
                size: 20.w,
                color:
                    isDarkMode
                        ? lightText.withOpacity(0.7)
                        : darkText.withOpacity(0.6),
              ),
              SizedBox(width: 8.w),
              Text(
                category,
                style: TextStyle(
                  color: isDarkMode ? lightText : darkText,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoodsItem(
    int index,
    GoodsEntry entry,
    bool isDarkMode,
    Color darkText,
    Color lightText,
  ) {
    return Card(
      color: isDarkMode ? const Color(0xFF3C2A21) : Colors.white,
      elevation: isDarkMode ? 2 : 4,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: ExpansionTile(
        title: Text(
          entry.name,
          style: TextStyle(
            color: isDarkMode ? lightText : darkText,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          '${entry.quantity} ${entry.unit}',
          style: TextStyle(
            color:
                isDarkMode
                    ? lightText.withOpacity(0.7)
                    : darkText.withOpacity(0.6),
            fontSize: 14.sp,
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (entry.description.isNotEmpty) ...[
                  Text(
                    'Description:',
                    style: TextStyle(
                      color:
                          isDarkMode
                              ? lightText.withOpacity(0.7)
                              : darkText.withOpacity(0.6),
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    entry.description,
                    style: TextStyle(
                      color: isDarkMode ? lightText : darkText,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Invoice Price: \$${entry.invoicePrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: isDarkMode ? lightText : darkText,
                        fontSize: 14.sp,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color:
                            isDarkMode
                                ? lightText.withOpacity(0.7)
                                : darkText.withOpacity(0.6),
                      ),
                      onPressed: () => _removeGood(index),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    bool isDarkMode,
    Color primaryColor,
    Color darkText,
    Color lightText,
  ) {
    return Row(
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
                  isDarkMode ? const Color(0xFF3C2A21) : Colors.grey[200],
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
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => DeclarationSummaryScreen(
                          currencies: _currencies,
                          goods: _goods,
                        ),
                  ),
                );

                if (result == true) {
                  Navigator.pop(context, {
                    'currencies': _currencies,
                    'goods': _goods,
                  });
                }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.h),
                child: Center(
                  child: Text(
                    'Review & Submit',
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
    );
  }

  void _showAddGoodDialog(
    BuildContext context,
    String category,
    bool isDarkMode,
    Color darkText,
    Color lightText,
  ) {
    if (category == 'Food') {
      _showFoodItemDialog(context, isDarkMode, darkText, lightText);
      return;
    } else if (category == 'Media Equipment') {
      _showMediaEquipmentDialog(context, isDarkMode, darkText, lightText);
      return;
    }

    // Original dialog for other categories
    final nameController = TextEditingController();
    final quantityController = TextEditingController();
    final valueController = TextEditingController();
    final primaryColor = const Color(0xFFD4A373);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: isDarkMode ? darkText : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
            title: Text(
              'Add ${category != 'Other' ? category : 'Item'}',
              style: TextStyle(
                color: isDarkMode ? lightText : darkText,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  style: TextStyle(
                    color: isDarkMode ? lightText : darkText,
                    fontSize: 16.sp,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Item Name',
                    labelStyle: TextStyle(
                      color:
                          isDarkMode
                              ? lightText.withOpacity(0.7)
                              : darkText.withOpacity(0.6),
                    ),
                    hintText: 'Enter item name',
                    hintStyle: TextStyle(
                      color:
                          isDarkMode
                              ? lightText.withOpacity(0.3)
                              : darkText.withOpacity(0.3),
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
                  ),
                ),
                SizedBox(height: 16.h),
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    color: isDarkMode ? lightText : darkText,
                    fontSize: 16.sp,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    labelStyle: TextStyle(
                      color:
                          isDarkMode
                              ? lightText.withOpacity(0.7)
                              : darkText.withOpacity(0.6),
                    ),
                    hintText: 'Enter quantity',
                    hintStyle: TextStyle(
                      color:
                          isDarkMode
                              ? lightText.withOpacity(0.3)
                              : darkText.withOpacity(0.3),
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
                  ),
                ),
                SizedBox(height: 16.h),
                TextField(
                  controller: valueController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    color: isDarkMode ? lightText : darkText,
                    fontSize: 16.sp,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Value',
                    labelStyle: TextStyle(
                      color:
                          isDarkMode
                              ? lightText.withOpacity(0.7)
                              : darkText.withOpacity(0.6),
                    ),
                    hintText: 'Enter value',
                    hintStyle: TextStyle(
                      color:
                          isDarkMode
                              ? lightText.withOpacity(0.3)
                              : darkText.withOpacity(0.3),
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
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color:
                        isDarkMode
                            ? lightText.withOpacity(0.7)
                            : darkText.withOpacity(0.6),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty &&
                      quantityController.text.isNotEmpty &&
                      valueController.text.isNotEmpty) {
                    _addGood(
                      GoodsEntry(
                        name:
                            '${category != 'Other' ? '$category - ' : ''}${nameController.text}',
                        category: category,
                        subcategory: '',
                        description: '',
                        invoicePrice: 0.0,
                        quantity: int.tryParse(quantityController.text) ?? 0,
                        unit: '',
                        value: double.tryParse(valueController.text) ?? 0.0,
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                ),
                child: Text(
                  'Add',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
            ],
          ),
    );
  }

  void _showFoodItemDialog(
    BuildContext context,
    bool isDarkMode,
    Color darkText,
    Color lightText,
  ) {
    final descriptionController = TextEditingController();
    final invoicePriceController = TextEditingController();
    final quantityController = TextEditingController();
    final primaryColor = const Color(0xFFD4A373);
    String selectedSubcategory = FoodCategory.subcategories[0];
    String selectedUnit = UnitType.units[0];

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  backgroundColor: isDarkMode ? darkText : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  title: Text(
                    'Add Food Item',
                    style: TextStyle(
                      color: isDarkMode ? lightText : darkText,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Subcategory Dropdown
                        DropdownButtonFormField<String>(
                          value: selectedSubcategory,
                          decoration: InputDecoration(
                            labelText: 'Type',
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
                          ),
                          items:
                              FoodCategory.subcategories.map((String type) {
                                return DropdownMenuItem<String>(
                                  value: type,
                                  child: Text(
                                    type,
                                    style: TextStyle(
                                      color: isDarkMode ? lightText : darkText,
                                    ),
                                  ),
                                );
                              }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                selectedSubcategory = newValue;
                              });
                            }
                          },
                        ),
                        SizedBox(height: 16.h),
                        // Description TextField
                        TextField(
                          controller: descriptionController,
                          maxLines: 3,
                          style: TextStyle(
                            color: isDarkMode ? lightText : darkText,
                            fontSize: 16.sp,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Description',
                            alignLabelWithHint: true,
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
                          ),
                        ),
                        SizedBox(height: 16.h),
                        // Invoice Price TextField
                        TextField(
                          controller: invoicePriceController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            color: isDarkMode ? lightText : darkText,
                            fontSize: 16.sp,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Invoice Price',
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
                          ),
                        ),
                        SizedBox(height: 16.h),
                        // Amount TextField
                        TextField(
                          controller: quantityController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            color: isDarkMode ? lightText : darkText,
                            fontSize: 16.sp,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Amount',
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
                          ),
                        ),
                        SizedBox(height: 16.h),
                        // Unit Dropdown
                        DropdownButtonFormField<String>(
                          value: selectedUnit,
                          decoration: InputDecoration(
                            labelText: 'Unit',
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
                          ),
                          items:
                              UnitType.units.map((String unit) {
                                return DropdownMenuItem<String>(
                                  value: unit,
                                  child: Text(
                                    unit,
                                    style: TextStyle(
                                      color: isDarkMode ? lightText : darkText,
                                    ),
                                  ),
                                );
                              }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                selectedUnit = newValue;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color:
                              isDarkMode
                                  ? lightText.withOpacity(0.7)
                                  : darkText.withOpacity(0.6),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (descriptionController.text.isNotEmpty &&
                            invoicePriceController.text.isNotEmpty &&
                            quantityController.text.isNotEmpty) {
                          final invoicePrice =
                              double.tryParse(invoicePriceController.text) ??
                              0.0;
                          final quantity =
                              int.tryParse(quantityController.text) ?? 0;

                          _addGood(
                            GoodsEntry(
                              name: selectedSubcategory,
                              category: 'Food',
                              subcategory: selectedSubcategory,
                              description: descriptionController.text,
                              invoicePrice: invoicePrice,
                              quantity: quantity,
                              unit: selectedUnit,
                              value: invoicePrice * quantity,
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        'Add',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
          ),
    );
  }

  void _showMediaEquipmentDialog(
    BuildContext context,
    bool isDarkMode,
    Color darkText,
    Color lightText,
  ) {
    final descriptionController = TextEditingController();
    final invoicePriceController = TextEditingController();
    final quantityController = TextEditingController();
    final primaryColor = const Color(0xFFD4A373);
    String selectedSubcategory = MediaEquipmentCategory.subcategories[0];
    String selectedUnit = UnitType.units[0];

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  backgroundColor: isDarkMode ? darkText : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  contentPadding: EdgeInsets.all(20.w),
                  title: Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: Text(
                      'Add Media Equipment',
                      style: TextStyle(
                        color: isDarkMode ? lightText : darkText,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Type Dropdown
                        DropdownButtonFormField<String>(
                          value: selectedSubcategory,
                          isExpanded: true,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 12.h,
                            ),
                            labelText: 'Type',
                            labelStyle: TextStyle(
                              fontSize: 14.sp,
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
                          ),
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isDarkMode ? lightText : darkText,
                          ),
                          dropdownColor: isDarkMode ? darkText : Colors.white,
                          items:
                              MediaEquipmentCategory.subcategories.map((
                                String type,
                              ) {
                                return DropdownMenuItem<String>(
                                  value: type,
                                  child: Text(
                                    type,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: isDarkMode ? lightText : darkText,
                                    ),
                                  ),
                                );
                              }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                selectedSubcategory = newValue;
                              });
                            }
                          },
                        ),
                        SizedBox(height: 16.h),
                        // Description TextField
                        TextField(
                          controller: descriptionController,
                          maxLines: 3,
                          style: TextStyle(
                            color: isDarkMode ? lightText : darkText,
                            fontSize: 14.sp,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 12.h,
                            ),
                            labelText: 'Description',
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(
                              fontSize: 14.sp,
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
                          ),
                        ),
                        SizedBox(height: 16.h),
                        // Invoice Price TextField with USD Label
                        TextField(
                          controller: invoicePriceController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            color: isDarkMode ? lightText : darkText,
                            fontSize: 14.sp,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 12.h,
                            ),
                            labelText: 'Invoice Price (USD)',
                            labelStyle: TextStyle(
                              fontSize: 14.sp,
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
                            prefixIcon: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Icon(
                                Icons.attach_money,
                                size: 20.w,
                                color:
                                    isDarkMode
                                        ? lightText.withOpacity(0.7)
                                        : darkText.withOpacity(0.6),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        // Amount TextField
                        TextField(
                          controller: quantityController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            color: isDarkMode ? lightText : darkText,
                            fontSize: 14.sp,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 12.h,
                            ),
                            labelText: 'Amount',
                            labelStyle: TextStyle(
                              fontSize: 14.sp,
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
                          ),
                        ),
                        SizedBox(height: 16.h),
                        // Unit Dropdown
                        DropdownButtonFormField<String>(
                          value: selectedUnit,
                          isExpanded: true,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 12.h,
                            ),
                            labelText: 'Unit',
                            labelStyle: TextStyle(
                              fontSize: 14.sp,
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
                          ),
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isDarkMode ? lightText : darkText,
                          ),
                          dropdownColor: isDarkMode ? darkText : Colors.white,
                          items:
                              UnitType.units.map((String unit) {
                                return DropdownMenuItem<String>(
                                  value: unit,
                                  child: Text(
                                    unit,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: isDarkMode ? lightText : darkText,
                                    ),
                                  ),
                                );
                              }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                selectedUnit = newValue;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color:
                                    isDarkMode
                                        ? lightText.withOpacity(0.7)
                                        : darkText.withOpacity(0.6),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          ElevatedButton(
                            onPressed: () {
                              if (descriptionController.text.isNotEmpty &&
                                  invoicePriceController.text.isNotEmpty &&
                                  quantityController.text.isNotEmpty) {
                                final invoicePrice =
                                    double.tryParse(
                                      invoicePriceController.text,
                                    ) ??
                                    0.0;
                                final quantity =
                                    int.tryParse(quantityController.text) ?? 0;

                                _addGood(
                                  GoodsEntry(
                                    name: selectedSubcategory,
                                    category: 'Media Equipment',
                                    subcategory: selectedSubcategory,
                                    description: descriptionController.text,
                                    invoicePrice: invoicePrice,
                                    quantity: quantity,
                                    unit: selectedUnit,
                                    value: invoicePrice * quantity,
                                  ),
                                );
                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 12.h,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            child: Text(
                              'Add',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
          ),
    );
  }
}

class CurrencyEntry {
  final String name;
  final double amount;
  final TextEditingController controller;

  CurrencyEntry({
    required this.name,
    required this.controller,
    this.amount = 0.0,
  });
}

class GoodsEntry {
  final String name;
  final String category;
  final String subcategory;
  final String description;
  final double invoicePrice;
  final int quantity;
  final String unit;
  final double value;

  GoodsEntry({
    required this.name,
    required this.category,
    required this.subcategory,
    required this.description,
    required this.invoicePrice,
    required this.quantity,
    required this.unit,
    required this.value,
  });
}
