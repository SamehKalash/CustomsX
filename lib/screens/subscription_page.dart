import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final iconColor =
        isDarkMode ? const Color(0xFFF5F5DC) : const Color(0xFF1A120B);
    final primaryColor = const Color(0xFFD4A373);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Subscription Plans',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24.sp,
            color:
                isDarkMode ? const Color(0xFFF5F5DC) : const Color(0xFF1A120B),
          ),
        ),
        backgroundColor: isDarkMode ? const Color(0xFF1A120B) : Colors.white,
        elevation: 4,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: iconColor),
          onPressed: () => Navigator.pushNamed(context, '/dashboard'),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: iconColor),
      ),
      body: Container(
        decoration: BoxDecoration(
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
                      const Color(0xFFF5F5DC).withOpacity(0.6),
                      const Color(0xFFD4A373).withOpacity(0.1),
                    ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              Text(
                'Choose Your Plan',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color:
                      isDarkMode
                          ? const Color(0xFFF5F5DC)
                          : const Color(0xFF1A120B),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Select the perfect plan for your business needs',
                style: TextStyle(
                  fontSize: 16.sp,
                  color:
                      isDarkMode
                          ? const Color(0xFFF5F5DC).withOpacity(0.7)
                          : const Color(0xFF1A120B).withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32.h),
              _buildPlanCards(context, isDarkMode, primaryColor),
              SizedBox(height: 32.h),
              _buildCustomSolutionCard(context, isDarkMode, primaryColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCards(
    BuildContext context,
    bool isDarkMode,
    Color primaryColor,
  ) {
    final plans = [
      {
        'name': 'Premium',
        'price': '\EGP 7500',
        'period': 'per month',
        'features': [
          'Generate Import Documents',
          'Higher Piriority Client',
          'Monthly Reports of Shipments',
          'Lower Processing Fees',
        ],
        'badge': '',
      },
      {
        'name': 'Premium Plus',
        'price': '\EGP 12000',
        'period': 'per month',
        'features': [
          'All Premium Features',
          'Priority Support',
          'Bulk Import/Export',
          'Custom Reports',
        ],
        'badge': 'Most Popular',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 1,
        childAspectRatio: MediaQuery.of(context).size.width > 600 ? 0.7 : 0.85,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
      ),
      itemCount: plans.length,
      itemBuilder: (context, index) {
        final plan = plans[index];
        return _buildPlanCard(context, plan, isDarkMode, primaryColor);
      },
    );
  }

  Widget _buildPlanCard(
    BuildContext context,
    Map<String, dynamic> plan,
    bool isDarkMode,
    Color primaryColor,
  ) {
    final isProfessional = plan['name'] == 'Professional';
    final isEnterprise = plan['name'] == 'Enterprise';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      color: isDarkMode ? const Color(0xFF3C2A21) : Colors.white,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (plan['badge'] != '')
            Positioned(
              top: 8.h,
              right: 20.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isEnterprise ? Colors.red : primaryColor,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  plan['badge'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plan['name'],
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color:
                        isDarkMode
                            ? const Color(0xFFF5F5DC)
                            : const Color(0xFF1A120B),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  plan['price'],
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                Text(
                  plan['period'],
                  style: TextStyle(
                    fontSize: 14.sp,
                    color:
                        isDarkMode
                            ? const Color(0xFFF5F5DC).withOpacity(0.7)
                            : const Color(0xFF1A120B).withOpacity(0.6),
                  ),
                ),
                SizedBox(height: 16.h),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children:
                          plan['features']
                              .map<Widget>(
                                (feature) => Padding(
                                  padding: EdgeInsets.only(bottom: 8.h),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: primaryColor,
                                        size: 18.w,
                                      ),
                                      SizedBox(width: 8.w),
                                      Expanded(
                                        child: Text(
                                          feature,
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            color:
                                                isDarkMode
                                                    ? const Color(0xFFF5F5DC)
                                                    : const Color(0xFF1A120B),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (isEnterprise) {
                        // Handle contact sales
                      } else {
                        // Handle subscription
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isProfessional
                              ? primaryColor
                              : (isDarkMode
                                  ? const Color(0xFF3C2A21)
                                  : Colors.white),
                      foregroundColor:
                          isProfessional ? Colors.white : primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        side: BorderSide(color: primaryColor),
                      ),
                    ),
                    child: Text(
                      isEnterprise ? 'Contact Sales' : 'Get Started',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomSolutionCard(
    BuildContext context,
    bool isDarkMode,
    Color primaryColor,
  ) {
    return Card(
      elevation: 0,
      color: primaryColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            Text(
              'Need a Custom Solution?',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color:
                    isDarkMode
                        ? const Color(0xFFF5F5DC)
                        : const Color(0xFF1A120B),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Contact our sales team for a tailored package that meets your specific requirements.',
              style: TextStyle(
                fontSize: 16.sp,
                color:
                    isDarkMode
                        ? const Color(0xFFF5F5DC).withOpacity(0.7)
                        : const Color(0xFF1A120B).withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () {
                // Handle contact sales
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'Contact Sales',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
