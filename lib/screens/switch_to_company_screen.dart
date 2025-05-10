import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
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
  final TextEditingController _authorizedRepresentativesController =
      TextEditingController();

  File? _licenseFile;
  File? _socialInsuranceFile;
  File? _commercialRegisterFile;
  File? _taxCardFile;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _companyNameController.dispose();
    _registrationNumberController.dispose();
    _authorizedRepresentativesController.dispose();
    super.dispose();
  }

  Future<void> _pickFile(Function(File) onFilePicked) async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      onFilePicked(File(result.files.single.path!));
    }
  }

  Future<void> _switchToCompanyAccount() async {
    if (_formKey.currentState!.validate() &&
        _licenseFile != null &&
        _socialInsuranceFile != null &&
        _commercialRegisterFile != null &&
        _taxCardFile != null) {
      setState(() => _isLoading = true);

      try {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final user = userProvider.user;

        // Check if the user is logged in
        if (user == null || user['id'] == null) {
          throw Exception('User not logged in.');
        }

        final userId = user['id'];

        // Create an instance of ApiService
        final apiService = ApiService();

        // Call API to update profile type
        await apiService.updateProfileTypeWithFiles(
          userId: userId,
          profileType: 'company',
          companyName: _companyNameController.text.trim(),
          registrationNumber: _registrationNumberController.text.trim(),
          authorizedRepresentatives: _authorizedRepresentativesController.text.trim(),
          licenseFile: _licenseFile!,
          socialInsuranceFile: _socialInsuranceFile!,
          commercialRegisterFile: _commercialRegisterFile!,
          taxCardFile: _taxCardFile!,
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields and upload required documents.'),
          backgroundColor: Colors.red,
        ),
      );
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
          child: SingleChildScrollView(
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
                const SizedBox(height: 16),
                _buildFileUploadField(
                  label: 'License Document',
                  file: _licenseFile,
                  onFilePicked: (file) => setState(() => _licenseFile = file),
                ),
                const SizedBox(height: 16),
                _buildFileUploadField(
                  label: 'Social Insurance Document',
                  file: _socialInsuranceFile,
                  onFilePicked: (file) =>
                      setState(() => _socialInsuranceFile = file),
                ),
                const SizedBox(height: 16),
                _buildFileUploadField(
                  label: 'Commercial Register Extract',
                  file: _commercialRegisterFile,
                  onFilePicked: (file) =>
                      setState(() => _commercialRegisterFile = file),
                ),
                const SizedBox(height: 16),
                _buildFileUploadField(
                  label: 'Tax Card',
                  file: _taxCardFile,
                  onFilePicked: (file) => setState(() => _taxCardFile = file),
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  controller: _authorizedRepresentativesController,
                  label: 'Authorized Representatives',
                  hintText: 'Enter authorized representatives',
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

  Widget _buildFileUploadField({
    required String label,
    required File? file,
    required Function(File) onFilePicked,
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
        Row(
          children: [
            Expanded(
              child: Text(
                file != null ? file.path.split('/').last : 'No file selected',
                style: const TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              onPressed: () => _pickFile(onFilePicked),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4A373),
              ),
              child: const Text('Upload'),
            ),
          ],
        ),
      ],
    );
  }
}