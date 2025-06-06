import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart'; // Ensure this has your baseUrl and agent register URL

class RegisterAgentScreen extends StatefulWidget {
  const RegisterAgentScreen({super.key});

  @override
  State<RegisterAgentScreen> createState() => _RegisterAgentScreenState();
}

class _RegisterAgentScreenState extends State<RegisterAgentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _businessController = TextEditingController();

  File? _profileImage;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _profileImage = File(pickedFile.path));
    }
  }

  Future<void> _registerAgent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    var uri = Uri.parse('$baseUrl/register-agent'); // Replace with your actual endpoint
    var request = http.MultipartRequest('POST', uri);

    request.fields['name'] = _nameController.text.trim();
    request.fields['email'] = _emailController.text.trim();
    request.fields['password'] = _passwordController.text.trim();
    request.fields['password_confirmation'] = _confirmController.text.trim();
    request.fields['contact_number'] = _contactController.text.trim();
    request.fields['business_area'] = _businessController.text.trim();
    request.fields['payment_status'] = 'Paid'; // Simulated payment

    if (_profileImage != null) {
      request.files.add(await http.MultipartFile.fromPath('profile_image', _profileImage!.path));
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      setState(() => _isLoading = false);

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Optionally store token if returned
        final prefs = await SharedPreferences.getInstance();
        if (data['token'] != null) {
          await prefs.setString('token', data['token']);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Agent registered successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: ${data['message'] ?? 'Unknown error'}')),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error registering agent.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register as Agent'), backgroundColor: Colors.green),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
              validator: (value) => value!.isEmpty ? 'Enter name' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) => value!.isEmpty ? 'Enter email' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
              validator: (value) => value!.length < 6 ? 'Min 6 characters' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _confirmController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
              validator: (value) => value != _passwordController.text ? 'Passwords do not match' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _contactController,
              decoration: const InputDecoration(labelText: 'Contact Number'),
              validator: (value) => value!.isEmpty ? 'Enter contact number' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _businessController,
              decoration: const InputDecoration(labelText: 'Business Area (e.g., Colombo)'),
              validator: (value) => value!.isEmpty ? 'Enter area' : null,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text("Choose Profile Image"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
                const SizedBox(width: 10),
                if (_profileImage != null)
                  Text(_profileImage!.path.split('/').last, overflow: TextOverflow.ellipsis),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _registerAgent,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Register"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
