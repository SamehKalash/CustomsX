import 'package:flutter/material.dart';

class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name, _email, _message, _inquiryType;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // TODO: Integrate with backend/Firebase
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Message sent successfully!')));
      Navigator.pop(context);
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
                items:
                    [
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
                validator:
                    (value) => !value!.contains('@') ? 'Invalid email' : null,
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
