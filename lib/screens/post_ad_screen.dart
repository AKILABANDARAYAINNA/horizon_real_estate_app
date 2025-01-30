import 'package:flutter/material.dart';
import '../widgets/bottom_nav_widget.dart';

class PostAdScreen extends StatelessWidget {
  const PostAdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _descriptionController = TextEditingController();
    final TextEditingController _priceController = TextEditingController();
    final TextEditingController _locationController = TextEditingController();
    String _propertyType = 'House';

    // Property type dropdown options
    final List<String> propertyTypes = [
      'House',
      'Apartment',
      'Land',
      'Commercial',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Your Ad'),
        backgroundColor: const Color.fromARGB(255, 0, 110, 4),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Property Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the property title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price (LKR)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _propertyType,
                decoration: const InputDecoration(
                  labelText: 'Property Type',
                  border: OutlineInputBorder(),
                ),
                items: propertyTypes
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  _propertyType = value!;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Pretend camera functionality for demo
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Camera placeholder')),
                      );
                    },
                    icon: const Icon(Icons.camera_alt), // Camera icon
                    label: const Text('Add Images'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 110, 4),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text('No images added yet'),
                ],
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Ad Submitted Successfully!')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    backgroundColor: const Color.fromARGB(255, 0, 110, 4),
                  ),
                  child: const Text('Submit Ad', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const Footer(currentIndex: 2), // Highlight "Post Ad" Tab
    );
  }
}
