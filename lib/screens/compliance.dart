import 'package:flutter/material.dart';

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
        _prohibitedItems = ['Item 1', 'Item 2', 'Item 3'];
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
    return Scaffold(
      appBar: AppBar(title: const Text('Regulatory Guide')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _isDropdownLoading
                ? const Center(child: CircularProgressIndicator())
                : DropdownButtonFormField(
                  value: _selectedCountry,
                  items:
                      _countries.map((String country) {
                        return DropdownMenuItem<String>(
                          value: country,
                          child: Text(country),
                        );
                      }).toList(),
                  onChanged: (value) async {
                    if (value != null) {
                      setState(() => _selectedCountry = value);
                      await _loadProhibitedItems();
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Select Country',
                    border: OutlineInputBorder(),
                  ),
                ),
            const SizedBox(height: 20),
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
            const SizedBox(height: 10),
            Text(
              'Prohibited Items in $_selectedCountry:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            _isLoading
                ? const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
                : _prohibitedItems.isEmpty
                ? Expanded(
                  child: Center(
                    child: Text(
                      'No prohibited items found for $_selectedCountry.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                )
                : Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refreshProhibitedItems,
                    child: ListView.builder(
                      itemCount: _prohibitedItems.length,
                      itemBuilder:
                          (context, index) => ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.red.shade100,
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                            title: Text(_prohibitedItems[index]),
                            subtitle: Text('Prohibited in $_selectedCountry'),
                            trailing: const Icon(
                              Icons.dangerous,
                              color: Colors.red,
                            ),
                          ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
