import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreateCompanyScreen extends StatefulWidget {
  const CreateCompanyScreen({super.key});

  @override
  State<CreateCompanyScreen> createState() => _CreateCompanyScreenState();
}

class _CreateCompanyScreenState extends State<CreateCompanyScreen> {
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _branchOfficeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _registrationNumberController = TextEditingController();
  final TextEditingController _vatNumberController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();

  String? _companyNameError;
  String? _addressError;
  String? _zipError;
  String? _cityError;
  String? _registrationNumberError;
  String? _phoneNumberError;

  bool _consentGiven = false;
  XFile? _selectedLogo;

  final ImagePicker _picker = ImagePicker();

  // Define the yellowish color to match the dashboard theme
  static const Color yellowishColor = Color(0xFFE3B505);

  void _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedLogo = pickedFile;
    });
  }

  void _clearImage() {
    setState(() {
      _selectedLogo = null;
    });
  }

  void _submitForm() {
    setState(() {
      _companyNameError = _companyNameController.text.trim().isEmpty
          ? 'Company name is required'
          : null;
      _addressError = _addressController.text.trim().isEmpty
          ? 'Address is required'
          : null;
      _zipError = _zipController.text.trim().isEmpty
          ? 'ZIP/Postal code is required'
          : null;
      _cityError = _cityController.text.trim().isEmpty
          ? 'City is required'
          : null;
      _registrationNumberError = _registrationNumberController.text.trim().isEmpty
          ? 'National company registration number is required'
          : null;
      _phoneNumberError = _phoneNumberController.text.trim().isEmpty
          ? 'Phone number is required'
          : null;
    });

    if (_companyNameError == null &&
        _addressError == null &&
        _zipError == null &&
        _cityError == null &&
        _registrationNumberError == null &&
        _phoneNumberError == null &&
        _consentGiven) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Company details submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushNamed(context, '/createAccount'); // Navigate to Create Account Screen
    } else if (!_consentGiven) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must agree to the terms to proceed.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a Company'),
        backgroundColor: isDarkMode ? Colors.grey[900] : yellowishColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Please provide your company details to begin registration.',
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _companyNameController,
                labelText: 'Company Name',
                errorText: _companyNameError,
                isDarkMode: isDarkMode,
                helperText: 'Enter the legal name, short name, or trade name exactly as it appears on the official company registration document.',
                isRequired: true,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _branchOfficeController,
                labelText: 'Branch Office (optional)',
                isDarkMode: isDarkMode,
                isRequired: false,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _addressController,
                labelText: 'Address',
                errorText: _addressError,
                isDarkMode: isDarkMode,
                helperText: 'Enter the street name, building number, and/or any other relevant details to specify the exact location.',
                isRequired: true,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _zipController,
                labelText: 'ZIP / Postal Code',
                errorText: _zipError,
                isDarkMode: isDarkMode,
                helperText: 'Enter your ZIP or postal code. If your company does not have one, enter 0000.',
                isRequired: true,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _cityController,
                labelText: 'City',
                errorText: _cityError,
                isDarkMode: isDarkMode,
                isRequired: true,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _locationController,
                labelText: 'Location',
                isDarkMode: isDarkMode,
                helperText: 'The listed locations are based on ISO 3166 standard which includes the names of countries, dependent territories, and special areas of geographical interest.',
                isRequired: false,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _registrationNumberController,
                labelText: 'National Company Registration Number',
                errorText: _registrationNumberError,
                isDarkMode: isDarkMode,
                helperText: 'Enter a unique identifier assigned to a business when it is officially registered with a government authority or regulatory body.',
                isRequired: true,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _vatNumberController,
                labelText: 'VAT Number (optional)',
                isDarkMode: isDarkMode,
                helperText: 'Enter your VAT number for EU countries (e.g., XY123456789) or the relevant tax identification number for other countries.',
                isRequired: false,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _phoneNumberController,
                labelText: 'Phone Number',
                errorText: _phoneNumberError,
                isDarkMode: isDarkMode,
                isRequired: true,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _websiteController,
                labelText: 'Website (optional)',
                isDarkMode: isDarkMode,
                isRequired: false,
              ),
              const SizedBox(height: 20),
              Text(
                'Company Logo (optional)',
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              if (_selectedLogo != null)
                Column(
                  children: [
                    Image.file(
                      File(_selectedLogo!.path),
                      height: 100,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: _pickImage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: yellowishColor,
                          ),
                          child: const Text('Change Image'),
                        ),
                        ElevatedButton(
                          onPressed: _clearImage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: yellowishColor,
                          ),
                          child: const Text('Clear Image'),
                        ),
                      ],
                    ),
                  ],
                )
              else
                ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: yellowishColor,
                  ),
                  child: const Text('Upload Logo'),
                ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: _consentGiven,
                    onChanged: (value) {
                      setState(() {
                        _consentGiven = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      'I am allowed to share my employee data with SCCF and give explicit consent to store this data on our company\'s behalf.',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  backgroundColor: isDarkMode ? Colors.grey[800] : yellowishColor,
                ),
                child: const Text(
                  'Next',
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
    String? errorText,
    required bool isDarkMode,
    String? helperText,
    required bool isRequired,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        return TextField(
          controller: controller,
          onChanged: (value) {
            setState(() {}); // Trigger a rebuild to update the helper text
          },
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black,
            ),
            helperText: controller.text.trim().isEmpty && isRequired
                ? 'Please fill the fields'
                : helperText,
            helperStyle: TextStyle(
              color: controller.text.trim().isEmpty && isRequired
                  ? Colors.red
                  : (isDarkMode ? Colors.white54 : Colors.black54),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: isDarkMode ? Colors.white70 : Colors.grey,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: yellowishColor),
            ),
            errorText: errorText,
            filled: true,
            fillColor: isDarkMode ? Colors.grey[850] : Colors.white,
          ),
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        );
      },
    );
  }
}