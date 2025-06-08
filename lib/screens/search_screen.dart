import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart'; // Geolocation
import '../widgets/bottom_nav_widget.dart';
import '../constants.dart'; // for searchUrl

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

  bool _useCurrentLocation = false;
  Position? _currentPosition;

  final List<String> propertyTypes = ['Any', 'House', 'Apartment', 'Land', 'Commercial'];
  final List<String> transactionTypes = ['For Sale', 'For Rent'];

  late stt.SpeechToText _speech;
  bool _isListening = false;
  List<Map<String, dynamic>> _results = [];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
          return;
        }
      }

      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = pos;
      });
    } catch (e) {
      print("Geolocation error: $e");
    }
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
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _searchController.clear();
            _budgetController.clear();
            _propertyType = 'Any';
            _transactionType = 'For Sale';
            _results.clear();
            _useCurrentLocation = false;
            _currentPosition = null;
          });
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SwitchListTile(
                value: _useCurrentLocation,
                onChanged: (val) async {
                  setState(() => _useCurrentLocation = val);
                  if (val) await _getCurrentLocation();
                },
                title: const Text("Use Current Location"),
              ),
              TextField(
                controller: _searchController,
                enabled: !_useCurrentLocation,
                decoration: InputDecoration(
                  hintText: 'Location...',
                  prefixIcon: const Icon(Icons.location_on),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _budgetController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Budget (LKR)',
                  prefixIcon: const Icon(Icons.monetization_on),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _transactionType,
                decoration: InputDecoration(
                  labelText: 'Transaction Type',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
                items: transactionTypes
                    .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (value) => setState(() => _transactionType = value!),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _propertyType,
                decoration: InputDecoration(
                  labelText: 'Property Type',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
                items: propertyTypes
                    .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (value) => setState(() => _propertyType = value!),
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
                        subtitle: Text(
                          '${property['location'] ?? ''} - LKR ${property['price'] ?? ''}',
                        ),
                        onTap: () {
                          // Optional: Navigate to property details
                        },
                      ),
                    );
                  },
                ),
            ],
          ),
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

  Future<void> _performSearch() async {
    try {
      final uri = Uri.parse(searchUrl);
      final body = {
        'location': _useCurrentLocation ? '' : _searchController.text.trim(),
        'price': _budgetController.text.trim(),
        'property_type': _propertyType == 'Any' ? '' : _propertyType.toLowerCase(),
        'for_sale_or_rent': _transactionType == 'For Sale' ? 'sale' : 'rent',
      };

      if (_useCurrentLocation && _currentPosition != null) {
        body['latitude'] = _currentPosition!.latitude.toString();
        body['longitude'] = _currentPosition!.longitude.toString();
      }

      final response = await http.post(uri, headers: {'Accept': 'application/json'}, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _results = List<Map<String, dynamic>>.from(data['properties']);
        });

        if (_results.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No matching properties found')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to connect to server')),
      );
    }
  }
}
