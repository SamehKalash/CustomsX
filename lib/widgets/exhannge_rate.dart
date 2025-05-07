import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExchangeRateWidget extends StatefulWidget {
  const ExchangeRateWidget({super.key});

  @override
  _ExchangeRateWidgetState createState() => _ExchangeRateWidgetState();
}

class _ExchangeRateWidgetState extends State<ExchangeRateWidget> {
  final List<Map<String, String>> exchangeRates = [
    {
      'currency': 'USD',
      'rate': '50.65',
      'country': 'United States',
      'symbol': '\$',
      'currencyName': 'US Dollar',
    },
    {
      'currency': 'GBP',
      'rate': '65.51',
      'country': 'United Kingdom',
      'symbol': '£',
      'currencyName': 'British Pound',
    },
    {
      'currency': 'CAD',
      'rate': '35.44',
      'country': 'Canada',
      'symbol': '\$',
      'currencyName': 'Canadian Dollar',
    },
    {
      'currency': 'DKK',
      'rate': '7.32',
      'country': 'Denmark',
      'symbol': 'kr',
      'currencyName': 'Danish Krone',
    },
    {
      'currency': 'NOK',
      'rate': '4.81',
      'country': 'Norway',
      'symbol': 'kr',
      'currencyName': 'Norwegian Krone',
    },
    {
      'currency': 'SEK',
      'rate': '5.05',
      'country': 'Sweden',
      'symbol': 'kr',
      'currencyName': 'Swedish Krona',
    },
    {
      'currency': 'CHF',
      'rate': '57.28',
      'country': 'Switzerland',
      'symbol': 'CHF',
      'currencyName': 'Swiss Franc',
    },
    {
      'currency': 'JPY',
      'rate': '0.34',
      'country': 'Japan',
      'symbol': '¥',
      'currencyName': 'Japanese Yen',
    },
    {
      'currency': 'EUR',
      'rate': '54.62',
      'country': 'European Union',
      'symbol': '€',
      'currencyName': 'Euro',
    },
    {
      'currency': 'EGP',
      'rate': '1.00',
      'country': 'Egypt',
      'symbol': 'E£',
      'currencyName': 'Egyptian Pound',
    },
    {
      'currency': 'AUD',
      'rate': '33.12',
      'country': 'Australia',
      'symbol': '\$',
      'currencyName': 'Australian Dollar',
    },
    {
      'currency': 'INR',
      'rate': '0.61',
      'country': 'India',
      'symbol': '₹',
      'currencyName': 'Indian Rupee',
    },
    {
      'currency': 'CNY',
      'rate': '7.25',
      'country': 'China',
      'symbol': '¥',
      'currencyName': 'Chinese Yuan',
    },
    {
      'currency': 'ZAR',
      'rate': '3.25',
      'country': 'South Africa',
      'symbol': 'R',
      'currencyName': 'South African Rand',
    },
  ];

  String searchQuery = '';
  String defaultCurrency = 'EGP';

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color primaryColor = const Color(0xFFD4A373);
    final Color darkBackground = const Color(0xFF1A120B);
    final Color textColor =
        isDarkMode ? const Color(0xFFF5F5DC) : darkBackground;
    final Color subTextColor =
        isDarkMode ? Colors.white54 : darkBackground.withOpacity(0.6);

    final filteredRates =
        exchangeRates.where((rate) {
          final query = searchQuery.toLowerCase();
          return rate['country']!.toLowerCase().contains(query) ||
              rate['currency']!.toLowerCase().contains(query);
        }).toList();

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF3C2A21) : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.w,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            _buildSearchField(context, primaryColor, isDarkMode),
            SizedBox(height: 20.h),
            Expanded(
              child:
                  filteredRates.isEmpty
                      ? _buildEmptyState(primaryColor, subTextColor)
                      : _buildRatesList(
                        filteredRates,
                        textColor,
                        subTextColor,
                        primaryColor,
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField(
    BuildContext context,
    Color primaryColor,
    bool isDarkMode,
  ) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search currencies...',
        hintStyle: TextStyle(
          fontSize: 14.sp,
          color:
              isDarkMode
                  ? Colors.white54
                  : const Color(0xFF1A120B).withOpacity(0.6),
        ),
        prefixIcon: Icon(Icons.search_rounded, color: primaryColor, size: 24.w),
        filled: true,
        fillColor: isDarkMode ? const Color(0xFF1A120B) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: primaryColor, width: 1.w),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
      ),
      style: TextStyle(
        fontSize: 14.sp,
        color: isDarkMode ? const Color(0xFFF5F5DC) : const Color(0xFF1A120B),
      ),
      onChanged: (value) => setState(() => searchQuery = value),
    );
  }

  Widget _buildRatesList(
    List<Map<String, String>> rates,
    Color textColor,
    Color subTextColor,
    Color primaryColor,
  ) {
    return ListView.separated(
      itemCount: rates.length,
      separatorBuilder:
          (context, index) =>
              Divider(color: primaryColor.withOpacity(0.1), height: 1.h),
      itemBuilder: (context, index) {
        final rate = rates[index];
        final isDefault = rate['currency'] == defaultCurrency;

        return ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 8.h),
          leading: Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            alignment: Alignment.center,
            child: Text(
              rate['symbol']!,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
          ),
          title: Text(
            rate['country']!,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          subtitle: Text(
            '1 EGP = ${rate['rate']!} ${rate['currency']!}',
            style: TextStyle(fontSize: 12.sp, color: subTextColor),
          ),
          trailing: isDefault ? _buildSelectedBadge(primaryColor) : null,
          onTap: () => setState(() => defaultCurrency = rate['currency']!),
        );
      },
    );
  }

  Widget _buildSelectedBadge(Color primaryColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        'Selected',
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: primaryColor,
        ),
      ),
    );
  }

  Widget _buildEmptyState(Color primaryColor, Color textColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.search_off_rounded,
          size: 40.w,
          color: primaryColor.withOpacity(0.3),
        ),
        SizedBox(height: 16.h),
        Text(
          'No matching currencies found',
          style: TextStyle(fontSize: 14.sp, color: textColor),
        ),
        SizedBox(height: 8.h),
        Text(
          'Try different search terms',
          style: TextStyle(fontSize: 12.sp, color: textColor.withOpacity(0.8)),
        ),
      ],
    );
  }
}
