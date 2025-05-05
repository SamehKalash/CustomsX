import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name, _email, _message, _inquiryType;
  File? _attachment;

  // Pick file from device
  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() => _attachment = File(result.files.single.path!));
    }
  }

  // Submit form to backend
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // 🚨 REPLACE WITH YOUR BACKEND URL
      var uri = Uri.parse('https://your-api-domain.com/contact');
      
      var request = http.MultipartRequest('POST', uri)
        ..fields['name'] = _name!
        ..fields['email'] = _email!
        ..fields['message'] = _message!
        ..fields['inquiryType'] = _inquiryType!;

      if (_attachment != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'attachment', 
          _attachment!.path,
        ));
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Message sent successfully!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contact Us')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Inquiry Type Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Inquiry Type'),
                items: [
                  'Payment Issue',
                  'Calculation Error',
                  'Account Problem',
                  'General Feedback',
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _inquiryType = value),
                validator: (value) => value == null ? 'Required' : null,
              ),
              SizedBox(height: 20),

              // Name Field
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
                onSaved: (value) => _name = value,
              ),
              SizedBox(height: 20),

              // Email Field
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) => 
                    !value!.contains('@') ? 'Invalid email' : null,
                onSaved: (value) => _email = value,
              ),
              SizedBox(height: 20),

              // Message Field
              TextFormField(
                decoration: InputDecoration(labelText: 'Message'),
                maxLines: 5,
                validator: (value) => value!.isEmpty ? 'Required' : null,
                onSaved: (value) => _message = value,
              ),
              SizedBox(height: 20),

              // File Attachment
              ElevatedButton.icon(
                onPressed: _pickFile,
                icon: Icon(Icons.attach_file),
                label: Text(_attachment == null ? 'Attach File' : 'File Selected'),
              ),
              SizedBox(height: 30),

              // Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}