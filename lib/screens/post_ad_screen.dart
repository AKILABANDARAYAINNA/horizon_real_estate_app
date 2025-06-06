import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'login_screen.dart';
import 'home_screen.dart';
import '../constants.dart';

class PostAdScreen extends StatefulWidget {
  const PostAdScreen({super.key});

  @override
  State<PostAdScreen> createState() => _PostAdScreenState();
}

class _PostAdScreenState extends State<PostAdScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();
  final _areaController = TextEditingController();
  String? _propertyType;
  String? _purpose;
  bool _isFeatured = false;
  List<XFile> _images = [];

  bool isSubmitting = false;
  String? token;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    if (token == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final selectedImages = await picker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      setState(() {
        _images = selectedImages;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSubmitting = true);

    final uri = Uri.parse(postAdUrl);
    final request = http.MultipartRequest('POST', uri);
    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
    request.fields.addAll({
      'title': _titleController.text.trim(),
      'description': _descController.text.trim(),
      'price': _priceController.text.trim(),
      'location': _locationController.text.trim(),
      'area': _areaController.text.trim(),
      'property_type': _propertyType ?? '',
      'for_sale_or_rent': _purpose ?? '',
      'is_featured': _isFeatured ? '1' : '0',
    });

    for (var image in _images) {
      request.files.add(await http.MultipartFile.fromPath('images[]', image.path));
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      setState(() => isSubmitting = false);

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Property posted successfully!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        print('Error ${response.statusCode}: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.body}')),
        );
      }
    } catch (e) {
      setState(() => isSubmitting = false);
      print('Exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong. Try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Property'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_titleController, 'Title'),
              _buildTextField(_descController, 'Description', isMultiLine: true),
              _buildTextField(_priceController, 'Price (LKR)', keyboardType: TextInputType.number),
              _buildTextField(_locationController, 'Location'),
              _buildTextField(_areaController, 'Area (sq. ft.)'),
              _buildDropdown('Property Type', ['house', 'apartment', 'land', 'commercial'], (val) => _propertyType = val),
              _buildDropdown('For', ['sale', 'rent'], (val) => _purpose = val),
              CheckboxListTile(
                value: _isFeatured,
                onChanged: (val) => setState(() => _isFeatured = val ?? false),
                title: const Text('Feature on Homepage'),
              ),
              ElevatedButton.icon(
                onPressed: _pickImages,
                icon: const Icon(Icons.image),
                label: const Text('Pick Images'),
              ),
              const SizedBox(height: 10),
              if (_images.isNotEmpty)
                Wrap(
                  spacing: 10,
                  children: _images.map((img) => Image.file(File(img.path), width: 80, height: 80)).toList(),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isSubmitting ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Post Property'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text, bool isMultiLine = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: isMultiLine ? 4 : 1,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) => value == null || value.isEmpty ? 'Enter $label' : null,
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> options, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: options
            .map((e) => DropdownMenuItem(value: e, child: Text(e.toUpperCase())))
            .toList(),
        onChanged: onChanged,
        validator: (value) => value == null || value.isEmpty ? 'Select $label' : null,
      ),
    );
  }
}
