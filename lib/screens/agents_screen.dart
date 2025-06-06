import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../constants.dart';
import '../widgets/bottom_nav_widget.dart';

class AgentsScreen extends StatefulWidget {
  const AgentsScreen({super.key});

  @override
  State<AgentsScreen> createState() => _AgentsScreenState();
}

class _AgentsScreenState extends State<AgentsScreen> {
  List<dynamic> agents = [];
  bool isLoading = true;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _contactController = TextEditingController();
  final _businessAreaController = TextEditingController();
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    fetchAgents();
  }

  Future<void> fetchAgents() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/agents'));
      if (response.statusCode == 200) {
        setState(() {
          agents = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        print('Error loading agents: ${response.body}');
      }
    } catch (e) {
      print('Exception loading agents: $e');
    }
  }

  Future<void> registerAgent() async {
    if (!_formKey.currentState!.validate()) return;

    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/agent/register'));
    request.fields['name'] = _nameController.text.trim();
    request.fields['email'] = _emailController.text.trim();
    request.fields['password'] = _passwordController.text;
    request.fields['password_confirmation'] = _confirmPasswordController.text;
    request.fields['contact_number'] = _contactController.text.trim();
    request.fields['business_area'] = _businessAreaController.text.trim();

    if (_pickedImage != null) {
      request.files.add(await http.MultipartFile.fromPath('profile_image', _pickedImage!.path));
    }

    final response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agent registration submitted. Pending approval.')),
      );
      fetchAgents();
    } else {
      final resBody = await response.stream.bytesToString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: $resBody')),
      );
    }
  }

  void _showRegisterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Register as Agent'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  validator: (v) => v!.isEmpty ? 'Enter name' : null,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (v) => v!.isEmpty ? 'Enter email' : null,
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (v) => v!.length < 6 ? 'Min 6 chars' : null,
                ),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Confirm Password'),
                  validator: (v) => v != _passwordController.text ? 'Passwords don\'t match' : null,
                ),
                TextFormField(
                  controller: _contactController,
                  decoration: const InputDecoration(labelText: 'Contact Number'),
                  validator: (v) => v!.isEmpty ? 'Enter contact number' : null,
                ),
                TextFormField(
                  controller: _businessAreaController,
                  decoration: const InputDecoration(labelText: 'Business Area'),
                  validator: (v) => v!.isEmpty ? 'Enter business area' : null,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
                        if (picked != null) {
                          setState(() => _pickedImage = File(picked.path));
                        }
                      },
                      child: const Text('Pick Profile Image'),
                    ),
                    const SizedBox(width: 10),
                    _pickedImage != null
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : const Icon(Icons.image_not_supported, color: Colors.grey),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: registerAgent,
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final columns = isLandscape ? 3 : 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Agents'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.8,
                ),
                itemCount: agents.length,
                itemBuilder: (context, index) {
                  final agent = agents[index];
                  return AgentCard(
                    name: agent['name'],
                    imageUrl: agent['profile_image'] ?? '',
                    rating: (agent['average_rating'] ?? 0).toDouble(),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showRegisterDialog,
        backgroundColor: Colors.green,
        child: const Icon(Icons.person_add),
      ),
      bottomNavigationBar: const Footer(currentIndex: 3),
    );
  }
}

class AgentCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final double rating;

  const AgentCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage:
                imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
            radius: 50,
            child: imageUrl.isEmpty ? const Icon(Icons.person, size: 50) : null,
          ),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (i) => Icon(
                i < rating ? Icons.star : Icons.star_border,
                color: i < rating ? Colors.amber : Colors.grey,
                size: 16,
              ),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Connected with $name')),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Connect'),
          ),
        ],
      ),
    );
  }
}
