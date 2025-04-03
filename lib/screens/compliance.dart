import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class ComplianceGuideScreen extends StatefulWidget {
  const ComplianceGuideScreen({super.key});

  @override
  State<ComplianceGuideScreen> createState() => _ComplianceGuideScreenState();
}

class _ComplianceGuideScreenState extends State<ComplianceGuideScreen> {
  String _selectedCountry = 'Egypt';
  List<String> _countries = ['Egypt'];
  List<String> _prohibitedItems = [];
  bool _isLoading = true;
  String _errorMessage = '';
  bool _firebaseReady = false;

  // Method to verify Firebase connection
  Future<void> _verifyFirebaseConnection() async {
    try {
      final firestore = FirebaseFirestore.instance;
      debugPrint('Firestore instance created');

      // Test with a simple read operation
      final testDoc = await firestore.collection('compliance').doc('test').get();
      debugPrint('Firestore test read successful: ${testDoc.exists}');

      // Get actual server version
      await firestore.terminate();
      debugPrint('Firestore connection terminated successfully');

      await firestore.clearPersistence();
      await firestore.enableNetwork();
    } catch (e) {
      debugPrint('Firestore connection failed: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _verifyFirebaseConnection(); // Verify Firebase connection
    _checkFirebaseAndLoad(); // Check Firebase initialization and load data
  }

  Future<void> _checkFirebaseAndLoad() async {
    try {
      // Check if Firebase is initialized
      try {
        Firebase.app();
        _firebaseReady = true;
      } catch (_) {
        _firebaseReady = false;
        _errorMessage = 'Firebase not initialized';
        _isLoading = false;
        return;
      }

      await _loadCountries();
      await _loadProhibitedItems();
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadCountries() async {
    if (!_firebaseReady) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('compliance')
          .doc('countries')
          .get();

      if (snapshot.exists) {
        setState(() {
          _countries = List<String>.from(snapshot.data()?['list'] ?? ['Egypt']);
          _selectedCountry = _countries.first;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load countries: ${e.toString()}';
      });
    }
  }

  Future<void> _loadProhibitedItems() async {
    if (!_firebaseReady) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('compliance')
          .doc('prohibited_items')
          .collection(_selectedCountry)
          .get();

      setState(() {
        _prohibitedItems = querySnapshot.docs.map((doc) => doc['name'] as String).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load items: ${e.toString()}';
        _isLoading = false;
      });
    }
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
            DropdownButtonFormField(
              value: _selectedCountry,
              items: _countries.map((String country) {
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
              Text(
                _errorMessage,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            const SizedBox(height: 10),
            Text(
              'Prohibited Items in $_selectedCountry:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            _isLoading
                ? const Expanded(child: Center(child: CircularProgressIndicator()))
                : _prohibitedItems.isEmpty
                    ? const Expanded(child: Center(child: Text('No items found')))
                    : Expanded(
                        child: ListView.builder(
                          itemCount: _prohibitedItems.length,
                          itemBuilder: (context, index) => ListTile(
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
