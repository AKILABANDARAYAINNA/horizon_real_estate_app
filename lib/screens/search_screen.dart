import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http/http.dart' as http;
import 'dart:convert';
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

  late stt.SpeechToText _speech;
  bool _isListening = false;
  List<Map<String, dynamic>> _results = [];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Properties'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
            tooltip: 'Voice Search',
            onPressed: _handleVoiceSearch,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
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
            ElevatedButton(
              onPressed: _performSearch,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Search'),
            ),
            const SizedBox(height: 10),
            if (_results.isNotEmpty)
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  final property = _results[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.home),
                      title: Text(property['title'] ?? 'No Title'),
                      subtitle: Text('${property['location'] ?? ''} - LKR ${property['price'] ?? ''}'),
                      onTap: () {
                        // TODO: Navigate to PropertyDetailsScreen
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

  void _handleVoiceSearch() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(onResult: (result) {
        setState(() {
          _searchController.text = result.recognizedWords;
          _isListening = false;
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Speech recognition not available')),
      );
    }
  }

  void _performSearch() async {
    final uri = Uri.parse('http://your-laravel-api-url/api/search'); // Replace with your backend API
    final response = await http.post(
      uri,
      headers: {'Accept': 'application/json'},
      body: {
        'location': _searchController.text.trim(),
        'price': _budgetController.text.trim(),
        'property_type': _propertyType == 'Any' ? '' : _propertyType,
        'for_sale_or_rent': _transactionType == 'For Sale' ? 'sale' : 'rent',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _results = List<Map<String, dynamic>>.from(data['properties']);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No properties found')),
      );
    }
  }
}
