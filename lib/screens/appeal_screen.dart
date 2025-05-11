import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppealScreen extends StatefulWidget {
  const AppealScreen({Key? key}) : super(key: key);

  @override
  State<AppealScreen> createState() => _AppealScreenState();
}

class _AppealScreenState extends State<AppealScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _docNoController = TextEditingController();
  final TextEditingController _appealNameController = TextEditingController();
  final TextEditingController _issueController = TextEditingController();

  String? _selectedCategory;
  final List<String> _categories = [
    'Customs Fee',
    'Document Issue',
    'Delay',
    'Other',
  ];

  @override
  void dispose() {
    _docNoController.dispose();
    _appealNameController.dispose();
    _issueController.dispose();
    super.dispose();
  }

  void _submitAppeal() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Appeal Submitted!')));
      _formKey.currentState?.reset();
      setState(() {
        _selectedCategory = null;
      });
      _docNoController.clear();
      _appealNameController.clear();
      _issueController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color primaryColor = const Color(0xFFD4A373);
    final Color darkBackground = const Color(0xFF1A120B);
    final Color cardColor = isDarkMode ? const Color(0xFF3C2A21) : Colors.white;
    final Color textColor =
        isDarkMode ? const Color(0xFFF5F5DC) : darkBackground;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Appeal',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 22.sp,
            color: textColor,
          ),
        ),
        backgroundColor: isDarkMode ? darkBackground : Colors.white,
        iconTheme: IconThemeData(color: textColor),
        elevation: 4,
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
                      const Color(0xFF1A120B),
                    ]
                    : [Colors.white, const Color(0xFFF5F5DC), Colors.white],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(maxWidth: 500.w),
              padding: EdgeInsets.all(20.w),
              child: Material(
                color: cardColor,
                borderRadius: BorderRadius.circular(18.r),
                elevation: 6,
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Submit a New Appeal',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp,
                            color: textColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24.h),
                        TextFormField(
                          controller: _docNoController,
                          style: TextStyle(color: textColor),
                          decoration: InputDecoration(
                            labelText: 'Document No',
                            labelStyle: TextStyle(
                              color: textColor.withOpacity(0.8),
                            ),
                            filled: true,
                            fillColor:
                                isDarkMode
                                    ? const Color(0xFF2D1F14)
                                    : const Color(0xFFF9F6F2),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: primaryColor.withOpacity(0.5),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: primaryColor,
                                width: 2,
                              ),
                            ),
                          ),
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Enter document number'
                                      : null,
                        ),
                        SizedBox(height: 16.h),
                        TextFormField(
                          controller: _appealNameController,
                          style: TextStyle(color: textColor),
                          decoration: InputDecoration(
                            labelText: 'Appeal Name',
                            labelStyle: TextStyle(
                              color: textColor.withOpacity(0.8),
                            ),
                            filled: true,
                            fillColor:
                                isDarkMode
                                    ? const Color(0xFF2D1F14)
                                    : const Color(0xFFF9F6F2),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: primaryColor.withOpacity(0.5),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: primaryColor,
                                width: 2,
                              ),
                            ),
                          ),
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Enter appeal name'
                                      : null,
                        ),
                        SizedBox(height: 16.h),
                        DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          dropdownColor: cardColor,
                          items:
                              _categories
                                  .map(
                                    (cat) => DropdownMenuItem(
                                      value: cat,
                                      child: Text(
                                        cat,
                                        style: TextStyle(color: textColor),
                                      ),
                                    ),
                                  )
                                  .toList(),
                          decoration: InputDecoration(
                            labelText: 'Category',
                            labelStyle: TextStyle(
                              color: textColor.withOpacity(0.8),
                            ),
                            filled: true,
                            fillColor:
                                isDarkMode
                                    ? const Color(0xFF2D1F14)
                                    : const Color(0xFFF9F6F2),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: primaryColor.withOpacity(0.5),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: primaryColor,
                                width: 2,
                              ),
                            ),
                          ),
                          onChanged:
                              (val) => setState(() => _selectedCategory = val),
                          validator:
                              (value) =>
                                  value == null ? 'Select a category' : null,
                        ),
                        SizedBox(height: 16.h),
                        TextFormField(
                          controller: _issueController,
                          maxLines: 5,
                          style: TextStyle(color: textColor),
                          decoration: InputDecoration(
                            labelText: 'Describe the Issue',
                            labelStyle: TextStyle(
                              color: textColor.withOpacity(0.8),
                            ),
                            filled: true,
                            fillColor:
                                isDarkMode
                                    ? const Color(0xFF2D1F14)
                                    : const Color(0xFFF9F6F2),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: primaryColor.withOpacity(0.5),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: primaryColor,
                                width: 2,
                              ),
                            ),
                            alignLabelWithHint: true,
                          ),
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Describe your issue'
                                      : null,
                        ),
                        SizedBox(height: 28.h),
                        Row(
                          children: [
                            Expanded(
                              child: Material(
                                color:
                                    isDarkMode
                                        ? const Color(0xFF3C2A21)
                                        : Colors.white,
                                borderRadius: BorderRadius.circular(15.r),
                                elevation: 4,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(15.r),
                                  onTap: () => Navigator.pop(context),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 14.h,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                          color:
                                              isDarkMode
                                                  ? const Color(0xFFF5F5DC)
                                                  : darkBackground,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Material(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(15.r),
                                elevation: 4,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(15.r),
                                  onTap: _submitAppeal,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 14.h,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Submit Appeal',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.sp,
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
            ),
          ),
        ),
      ),
    );
  }
}
