import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  String? _firstNameError;
  String? _lastNameError;
  String? _emailError;
  String? _mobileError;

  void _createAccount() {
    final email = _emailController.text.trim();
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final mobile = _mobileController.text.trim();

    setState(() {
      _firstNameError =
          firstName.isEmpty || !RegExp(r'^[a-zA-Z]+$').hasMatch(firstName)
              ? 'First name must contain letters only'
              : null;

      _lastNameError =
          lastName.isEmpty || !RegExp(r'^[a-zA-Z]+$').hasMatch(lastName)
              ? 'Last name must contain letters only'
              : null;

      _emailError =
          email.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email)
              ? 'Enter a valid email address'
              : null;

      _mobileError =
          mobile.isEmpty || !RegExp(r'^\+20\d{10}$').hasMatch(mobile)
              ? 'Phone number must start with +20 and contain exactly 10 digits'
              : null;
    });

    if (_firstNameError == null &&
        _lastNameError == null &&
        _emailError == null &&
        _mobileError == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to the Login Screen
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create New Account',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.blue,
        elevation: isDarkMode ? 2 : 4,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(
                controller: _firstNameController,
                labelText: 'First Name',
                icon: Icons.person,
                errorText: _firstNameError,
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _lastNameController,
                labelText: 'Last Name',
                icon: Icons.person_outline,
                errorText: _lastNameError,
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _emailController,
                labelText: 'Email',
                icon: Icons.email,
                errorText: _emailError,
                isDarkMode: isDarkMode,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              _buildPhoneNumberField(
                controller: _mobileController,
                errorText: _mobileError,
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _createAccount,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  backgroundColor: Colors.blue,
                  elevation: 4,
                ),
                child: const Text(
                  'Create Account',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    String? errorText,
    required bool isDarkMode,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black26 : Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.black,
          ),
          prefixIcon: Icon(
            icon,
            color: isDarkMode ? Colors.white70 : Colors.grey,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: isDarkMode ? Colors.white70 : Colors.grey,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue),
          ),
          errorText: errorText,
          filled: true,
          fillColor: isDarkMode ? Colors.grey[850] : Colors.white,
        ),
        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
      ),
    );
  }

  Widget _buildPhoneNumberField({
    required TextEditingController controller,
    String? errorText,
    required bool isDarkMode,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black26 : Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: 'Phone Number',
          labelStyle: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.black,
          ),
          prefixIcon: Icon(
            Icons.phone,
            color: isDarkMode ? Colors.white70 : Colors.grey,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: isDarkMode ? Colors.white70 : Colors.grey,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue),
          ),
          errorText: errorText,
          filled: true,
          fillColor: isDarkMode ? Colors.grey[850] : Colors.white,
        ),
        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        keyboardType: TextInputType.phone,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(13),
        ],
      ),
    );
  }
}
