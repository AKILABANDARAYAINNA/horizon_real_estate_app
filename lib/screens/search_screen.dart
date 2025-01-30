import 'package:flutter/material.dart';
import '../widgets/bottom_nav_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  String _propertyType = 'Any';
  String _transactionType = 'For Sale'; 

  final List<String> propertyTypes = [
    'Any',
    'House',
    'Apartment',
    'Land',
    'Commercial',
  ];

  final List<String> transactionTypes = [
    'For Sale',
    'For Rent',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Properties'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.mic),
            tooltip: 'Voice Search',
            onPressed: _handleVoiceSearch, // Voice search functionality
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // Location Input Field
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Location...',
                prefixIcon: const Icon(Icons.location_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Budget Input Field
            TextField(
              controller: _budgetController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Budget (LKR)',
                prefixIcon: const Icon(Icons.monetization_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Transaction Type Dropdown (For Sale or For Rent)
            DropdownButtonFormField<String>(
              value: _transactionType,
              decoration: InputDecoration(
                labelText: 'Transaction Type',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              items: transactionTypes
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _transactionType = value!;
                });
              },
            ),
            const SizedBox(height: 10),

            // Property Type Dropdown
            DropdownButtonFormField<String>(
              value: _propertyType,
              decoration: InputDecoration(
                labelText: 'Property Type',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              items: propertyTypes
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _propertyType = value!;
                });
              },
            ),
            const SizedBox(height: 10),

            // Search Button
            ElevatedButton(
              onPressed: _performSearch,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Search'),
            ),
            const SizedBox(height: 10),

            // Dynamic Results Section
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 5, 
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.home),
                    title: Text('Property ${index + 1}'),
                    subtitle: const Text('Details about this property...'),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Clicked on Property ${index + 1}'),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Footer(currentIndex: 1),
    );
  }

  // Handles Voice Search
  void _handleVoiceSearch() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Voice Search Coming Soon!')),
    );
  }

  // Handles Search Button Click
  void _performSearch() {
    String location = _searchController.text;
    String budget = _budgetController.text;
    String propertyType = _propertyType;
    String transactionType = _transactionType;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Searching for $transactionType $propertyType properties in $location within budget LKR $budget'),
      ),
    );
  }
}
