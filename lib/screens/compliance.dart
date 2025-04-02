import 'package:flutter/material.dart';

class ComplianceGuideScreen extends StatefulWidget {
  const ComplianceGuideScreen({super.key});

  @override
  State<ComplianceGuideScreen> createState() => _ComplianceGuideScreenState();
}

class _ComplianceGuideScreenState extends State<ComplianceGuideScreen> {
  String _selectedCountry = 'Egypt';
  final List<String> _countries = ['Egypt'];
  final List<String> _prohibitedItems = [
    'Counterfeit currency',
    'Illegal substances',
    'Endangered species products',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Regulatory Guide')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField(
              value: _selectedCountry,
              items:
                  _countries.map((String country) {
                    return DropdownMenuItem<String>(
                      value: country,
                      child: Text(country),
                    );
                  }).toList(),
              onChanged: (value) => setState(() => _selectedCountry = value!),
              decoration: const InputDecoration(
                labelText: 'Select Country',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Prohibited Items in $_selectedCountry:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _prohibitedItems.length,
                itemBuilder:
                    (context, index) => ListTile(
                      leading: const Icon(Icons.dangerous, color: Colors.red),
                      title: Text(_prohibitedItems[index]),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
