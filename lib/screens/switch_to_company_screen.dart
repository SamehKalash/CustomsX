import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class SwitchToCompanyScreen extends StatefulWidget {
  const SwitchToCompanyScreen({Key? key}) : super(key: key);

  @override
  State<SwitchToCompanyScreen> createState() => _SwitchToCompanyScreenState();
}

class _SwitchToCompanyScreenState extends State<SwitchToCompanyScreen> {
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _registrationNumberController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _companyNameController.dispose();
    _registrationNumberController.dispose();
    super.dispose();
  }

  Future<void> _switchToCompanyAccount() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final user = userProvider.user;

        // Check if the user is logged in
        if (user == null || user['id'] == null) {
          throw Exception('User not logged in.');
        }

        final userId = user['id'];

        // Call API to update profile type
        await ApiService.updateProfileType(
          userId: userId,
          profileType: 'company',
          companyName: _companyNameController.text.trim(),
          registrationNumber: _registrationNumberController.text.trim(),
        );

        // Update user provider
        userProvider.updateProfileType('company');

        // Navigate back
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Switched to Company Account successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Company Account',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1A120B),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A120B), Color(0xFF3C2A21)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Company Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              _buildInputField(
                controller: _companyNameController,
                label: 'Company Name',
                hintText: 'Enter your company name',
              ),
              const SizedBox(height: 16),
              _buildInputField(
                controller: _registrationNumberController,
                label: 'Registration Number',
                hintText: 'Enter your registration number',
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _switchToCompanyAccount,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4A373),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Switch to Company Account',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.white54),
            filled: true,
            fillColor: const Color(0xFF3C2A21),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(color: Colors.white),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$label is required';
            }
            return null;
          },
        ),
      ],
    );
  }
}