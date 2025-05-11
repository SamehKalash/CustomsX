import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ComplianceGuideScreen extends StatefulWidget {
  const ComplianceGuideScreen({super.key});

  @override
  State<ComplianceGuideScreen> createState() => _ComplianceGuideScreenState();
}

class _ComplianceGuideScreenState extends State<ComplianceGuideScreen> {
  String _selectedCountry = 'Egypt';
  List<String> _countries = [];
  List<String> _prohibitedItems = [];
  bool _isLoading = true;
  bool _isDropdownLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadCountries();
    _loadProhibitedItems();
  }

  Future<void> _loadCountries() async {
    setState(() {
      _isDropdownLoading = true;
    });

    try {
      // Simulate loading countries
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _countries = ['Egypt', 'USA', 'Canada'];
        _selectedCountry = _countries.first;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load countries: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isDropdownLoading = false;
      });
    }
  }

  Future<void> _loadProhibitedItems() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Simulate loading prohibited items
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _prohibitedItems = [
          'Firearms and Ammunition',
          'Drugs and Narcotics',
          'Counterfeit Goods',
          'Endangered Species',
          'Explosives',
        ];
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load items: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshProhibitedItems() async {
    await _loadProhibitedItems();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color cardColor = isDarkMode ? const Color(0xFF3C2A21) : Colors.white;
    final Color textColor =
        isDarkMode ? const Color(0xFFF5F5DC) : const Color(0xFF1A120B);
    final Color iconBg = const Color(0xFFD4A373).withOpacity(0.2);
    final Color iconColor = const Color(0xFFD4A373);

    final BoxDecoration backgroundDecoration = BoxDecoration(
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
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Compliance Guide'),
        backgroundColor: isDarkMode ? const Color(0xFF1A120B) : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        elevation: 2,
      ),
      body: Container(
        decoration: backgroundDecoration,
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dashboard-style title
              Padding(
                padding: EdgeInsets.only(bottom: 18.h, top: 4.h),
                child: Text(
                  'Customs Regulations & Restrictions',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              // Dropdown
              if (_isDropdownLoading)
                const Center(child: CircularProgressIndicator())
              else if (_countries.isNotEmpty)
                DropdownButtonFormField(
                  value: _selectedCountry,
                  items:
                      _countries
                          .map(
                            (String country) => DropdownMenuItem<String>(
                              value: country,
                              child: Text(country),
                            ),
                          )
                          .toList(),
                  onChanged: (value) async {
                    if (value != null) {
                      setState(() => _selectedCountry = value);
                      await _loadProhibitedItems();
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Select Country',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    filled: true,
                    fillColor: cardColor,
                  ),
                ),
              if (!_isDropdownLoading && _countries.isEmpty)
                Center(
                  child: Text(
                    'No countries available.',
                    style: TextStyle(color: textColor.withOpacity(0.7)),
                  ),
                ),
              SizedBox(height: 20.h),
              if (_errorMessage.isNotEmpty)
                Column(
                  children: [
                    Text(
                      _errorMessage,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _errorMessage = '';
                          _isLoading = true;
                        });
                        _loadCountries();
                        _loadProhibitedItems();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              SizedBox(height: 10.h),
              Text(
                'Prohibited Items in $_selectedCountry:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.h),
              Expanded(
                child:
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _prohibitedItems.isEmpty
                        ? Center(
                          child: Text(
                            'No prohibited items found for $_selectedCountry.',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: textColor.withOpacity(0.7)),
                          ),
                        )
                        : RefreshIndicator(
                          onRefresh: _refreshProhibitedItems,
                          child: ListView.separated(
                            itemCount: _prohibitedItems.length,
                            separatorBuilder: (_, __) => SizedBox(height: 12.h),
                            itemBuilder:
                                (context, index) => Material(
                                  color: cardColor,
                                  borderRadius: BorderRadius.circular(12.r),
                                  elevation: 2,
                                  child: ListTile(
                                    leading: Container(
                                      padding: EdgeInsets.all(8.w),
                                      decoration: BoxDecoration(
                                        color: iconBg,
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.block,
                                        color: iconColor,
                                        size: 24.w,
                                      ),
                                    ),
                                    title: Text(
                                      _prohibitedItems[index],
                                      style: TextStyle(
                                        color: textColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Prohibited in $_selectedCountry',
                                      style: TextStyle(
                                        color: textColor.withOpacity(0.7),
                                      ),
                                    ),
                                    trailing: Icon(
                                      Icons.dangerous,
                                      color: Colors.red.shade400,
                                    ),
                                  ),
                                ),
                          ),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
