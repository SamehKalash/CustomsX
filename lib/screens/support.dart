import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import './dashboard.dart';
import './profile_screen.dart';
import 'media_screen.dart';
import './news_details_screen.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  int _currentIndex = 2;
  final Color _primaryColor = const Color(0xFFD4A373);
  final Color _darkBackground = const Color(0xFF1A120B);
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  int _selectedTab = 0;

  final List<Map<String, dynamic>> _faqs = [
    {
      'question': 'How do I track my shipment?',
      'answer':
          'You can track your shipment by going to the Tracking section and entering your tracking number. The system will show you real-time updates on your shipment status.',
    },
    {
      'question': 'What documents are required for customs clearance?',
      'answer':
          'Typically, you need a commercial invoice, packing list, bill of lading or airway bill, and a certificate of origin. Additional documents may be required depending on the type of goods and destination country.',
    },
    {
      'question': 'How long does customs clearance take?',
      'answer':
          'Standard customs clearance typically takes 1-3 business days. However, this can vary depending on the complexity of the shipment, documentation completeness, and any inspections required.',
    },
    {
      'question': 'What are the payment methods available?',
      'answer':
          'We accept credit/debit cards, bank transfers, and digital wallets. You can manage all your payments through our secure payment gateway in the Payment section.',
    },
    {
      'question': 'How can I calculate import duties and taxes?',
      'answer':
          'Use our Calculator tool in the Quick Actions section. Enter your product details, value, and destination to get an estimate of duties and taxes applicable to your shipment.',
    },
  ];

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: Container(
        decoration: _buildBackgroundGradient(isDarkMode),
        child: Column(
          children: [
            _buildTabBar(isDarkMode),
            Expanded(child: _buildTabContent(context, isDarkMode)),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(isDarkMode),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return AppBar(
      backgroundColor: isDarkMode ? _darkBackground : Colors.white,
      title: Text(
        'Support Section',
        style: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.w800,
          color: isDarkMode ? const Color(0xFFF5F5DC) : const Color(0xFF1A120B),
        ),
      ),
      elevation: 0,
      automaticallyImplyLeading: false,
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
                  _darkBackground,
                  Color(0xFF3C2A21),
                  Color(0xFFD4A373).withOpacity(0.2),
                ]
                : [
                  Colors.white,
                  Color(0xFFF5F5DC).withOpacity(0.6),
                  Color(0xFFD4A373).withOpacity(0.1),
                ],
        stops: const [0.0, 0.5, 1.0],
      ),
    );
  }

  Widget _buildBottomNavBar(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? _darkBackground : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -2.h),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'Home', 0, isDarkMode),
              _buildNavItem(Icons.article, 'News', 1, isDarkMode),
              _buildNavItem(Icons.help_outline, 'Support', 2, isDarkMode),
              _buildNavItem(Icons.person, 'Profile', 3, isDarkMode),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    int index,
    bool isDarkMode,
  ) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => _updateIndex(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 28.w,
            color:
                isSelected
                    ? _primaryColor
                    : (isDarkMode
                        ? Color(0xFFF5F5DC).withOpacity(0.6)
                        : _darkBackground.withOpacity(0.6)),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color:
                  isSelected
                      ? _primaryColor
                      : (isDarkMode
                          ? Color(0xFFF5F5DC).withOpacity(0.6)
                          : _darkBackground.withOpacity(0.6)),
            ),
          ),
        ],
      ),
    );
  }

  void _updateIndex(int index) {
    setState(() => _currentIndex = index);
    switch (index) {
      case 0:
        _navigateWithTransition(const DashboardScreen(), isBack: true);
        break;
      case 1:
        _navigateWithTransition(const MediaScreen());
        break;
      case 3:
        _navigateWithTransition(const ProfileScreen());
        break;
    }
  }

  void _navigateWithTransition(Widget page, {bool isBack = false}) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final begin = isBack ? Offset(-1.0, 0.0) : Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutQuart;

          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  Widget _buildTabBar(bool isDarkMode) {
    return Container(
      margin: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF3C2A21) : Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildTabButton('FAQs', 0, isDarkMode),
          _buildTabButton('Contact Us', 1, isDarkMode),
          _buildTabButton('Submit Ticket', 2, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, int index, bool isDarkMode) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            color: isSelected ? _primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color:
                    isSelected
                        ? Colors.white
                        : isDarkMode
                        ? Color(0xFFF5F5DC)
                        : _darkBackground,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 16.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(BuildContext context, bool isDarkMode) {
    switch (_selectedTab) {
      case 0:
        return _buildFaqTab(isDarkMode);
      case 1:
        return _buildContactTab(isDarkMode);
      case 2:
        return _buildTicketTab(context, isDarkMode);
      default:
        return _buildFaqTab(isDarkMode);
    }
  }

  Widget _buildFaqTab(bool isDarkMode) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Frequently Asked Questions',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20.sp,
              color: isDarkMode ? Color(0xFFF5F5DC) : _darkBackground,
            ),
          ),
          SizedBox(height: 16.h),
          ..._faqs.map((faq) => _buildFaqItem(faq, isDarkMode)).toList(),
        ],
      ),
    );
  }

  Widget _buildFaqItem(Map<String, dynamic> faq, bool isDarkMode) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF3C2A21) : Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(
          faq['question'],
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            color: isDarkMode ? Color(0xFFF5F5DC) : _darkBackground,
          ),
        ),
        iconColor: _primaryColor,
        collapsedIconColor: isDarkMode ? Color(0xFFF5F5DC) : _darkBackground,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              faq['answer'],
              style: TextStyle(
                fontSize: 15.sp,
                color:
                    isDarkMode
                        ? Color(0xFFF5F5DC).withOpacity(0.9)
                        : _darkBackground.withOpacity(0.8),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactTab(bool isDarkMode) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Information',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20.sp,
              color: isDarkMode ? Color(0xFFF5F5DC) : _darkBackground,
            ),
          ),
          SizedBox(height: 20.h),
          _buildContactItem(
            Icons.phone,
            'Phone Support',
            '+1 (800) 123-4567',
            'Available 24/7',
            isDarkMode,
          ),
          SizedBox(height: 16.h),
          _buildContactItem(
            Icons.email,
            'Email Support',
            'support@customsx.com',
            'Response within 24 hours',
            isDarkMode,
          ),
          SizedBox(height: 16.h),
          _buildContactItem(
            Icons.chat_bubble,
            'Live Chat',
            'Available on our website',
            'Business hours: 9 AM - 6 PM',
            isDarkMode,
          ),
          SizedBox(height: 16.h),
          _buildContactItem(
            Icons.location_on,
            'Headquarters',
            '123 Customs Plaza, Suite 500',
            'New York, NY 10001, USA',
            isDarkMode,
          ),
          SizedBox(height: 30.h),
          _buildSocialMediaSection(isDarkMode),
        ],
      ),
    );
  }

  Widget _buildContactItem(
    IconData icon,
    String title,
    String detail,
    String subtitle,
    bool isDarkMode,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF3C2A21) : Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: _primaryColor, size: 28.w),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    color: isDarkMode ? Color(0xFFF5F5DC) : _darkBackground,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  detail,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: _primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color:
                        isDarkMode
                            ? Color(0xFFF5F5DC).withOpacity(0.7)
                            : _darkBackground.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMediaSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Follow Us',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20.sp,
            color: isDarkMode ? Color(0xFFF5F5DC) : _darkBackground,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSocialButton(Icons.facebook, 'Facebook', isDarkMode),
            _buildSocialButton(Icons.camera_alt, 'Instagram', isDarkMode),
            _buildSocialButton(Icons.messenger_outline, 'Twitter', isDarkMode),
            _buildSocialButton(Icons.video_library, 'YouTube', isDarkMode),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton(IconData icon, String label, bool isDarkMode) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: isDarkMode ? Color(0xFF3C2A21) : Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 3.h),
              ),
            ],
          ),
          child: Icon(icon, color: _primaryColor, size: 24.w),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: isDarkMode ? Color(0xFFF5F5DC) : _darkBackground,
          ),
        ),
      ],
    );
  }

  Widget _buildTicketTab(BuildContext context, bool isDarkMode) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Submit Support Ticket',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20.sp,
              color: isDarkMode ? Color(0xFFF5F5DC) : _darkBackground,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Fill out the form below and our support team will get back to you within 24 hours.',
            style: TextStyle(
              fontSize: 14.sp,
              color:
                  isDarkMode
                      ? Color(0xFFF5F5DC).withOpacity(0.7)
                      : _darkBackground.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 20.h),
          _buildTicketForm(context, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildTicketForm(BuildContext context, bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF3C2A21) : Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormField('Issue Type', isDarkMode, isDropdown: true),
          SizedBox(height: 16.h),
          _buildFormField(
            'Subject',
            isDarkMode,
            controller: _subjectController,
          ),
          SizedBox(height: 16.h),
          _buildFormField(
            'Message',
            isDarkMode,
            controller: _messageController,
            isMultiline: true,
          ),
          SizedBox(height: 16.h),
          _buildFormField('Attachments', isDarkMode, isAttachment: true),
          SizedBox(height: 24.h),
          Center(
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Support ticket submitted successfully!'),
                    backgroundColor: _primaryColor,
                  ),
                );
                _subjectController.clear();
                _messageController.clear();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                elevation: 4,
              ),
              child: Text(
                'Submit Ticket',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField(
    String label,
    bool isDarkMode, {
    TextEditingController? controller,
    bool isMultiline = false,
    bool isDropdown = false,
    bool isAttachment = false,
  }) {
    final labelText = Text(
      label,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16.sp,
        color: isDarkMode ? Color(0xFFF5F5DC) : _darkBackground,
      ),
    );

    final fieldDecoration = InputDecoration(
      filled: true,
      fillColor:
          isDarkMode
              ? Color(0xFF1A120B).withOpacity(0.5)
              : Color(0xFFF5F5DC).withOpacity(0.3),
      hintText:
          isMultiline ? 'Describe your issue in detail...' : 'Enter $label',
      hintStyle: TextStyle(
        color:
            isDarkMode
                ? Color(0xFFF5F5DC).withOpacity(0.5)
                : _darkBackground.withOpacity(0.4),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide(color: _primaryColor.withOpacity(0.5)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide(color: _primaryColor.withOpacity(0.5)),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    );

    if (isDropdown) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          labelText,
          SizedBox(height: 8.h),
          DropdownButtonFormField<String>(
            decoration: fieldDecoration,
            hint: Text(
              'Select Issue Type',
              style: TextStyle(
                color:
                    isDarkMode
                        ? Color(0xFFF5F5DC).withOpacity(0.7)
                        : _darkBackground.withOpacity(0.6),
              ),
            ),
            dropdownColor: isDarkMode ? Color(0xFF3C2A21) : Colors.white,
            icon: Icon(Icons.arrow_drop_down, color: _primaryColor),
            items:
                [
                  'Technical Issue',
                  'Billing Question',
                  'Shipment Problem',
                  'Documentation Help',
                  'Feature Request',
                  'Other',
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
            onChanged: (String? newValue) {},
            style: TextStyle(
              color: isDarkMode ? Color(0xFFF5F5DC) : _darkBackground,
              fontSize: 16.sp,
            ),
          ),
        ],
      );
    }

    if (isMultiline) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          labelText,
          SizedBox(height: 8.h),
          TextFormField(
            controller: controller,
            decoration: fieldDecoration,
            maxLines: 5,
            style: TextStyle(
              color: isDarkMode ? Color(0xFFF5F5DC) : _darkBackground,
              fontSize: 16.sp,
            ),
          ),
        ],
      );
    }

    if (isAttachment) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          labelText,
          SizedBox(height: 8.h),
          InkWell(
            onTap: () {
              /* Add attachment logic */
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
              decoration: BoxDecoration(
                color:
                    isDarkMode
                        ? Color(0xFF1A120B).withOpacity(0.5)
                        : Color(0xFFF5F5DC).withOpacity(0.3),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: _primaryColor.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  Icon(Icons.attach_file, color: _primaryColor),
                  SizedBox(width: 8.w),
                  Text(
                    'Click to attach files',
                    style: TextStyle(
                      color:
                          isDarkMode
                              ? Color(0xFFF5F5DC).withOpacity(0.7)
                              : _darkBackground.withOpacity(0.6),
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labelText,
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          decoration: fieldDecoration,
          style: TextStyle(
            color: isDarkMode ? Color(0xFFF5F5DC) : _darkBackground,
            fontSize: 16.sp,
          ),
        ),
      ],
    );
  }
}
