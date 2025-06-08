import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/bottom_nav_widget.dart';
import '../widgets/fade_page_route.dart';
import 'login_screen.dart';
import 'property_details_screen.dart';
import '../constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> properties = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProperties();
  }

  Future<void> fetchProperties() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/properties'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          properties = data;
          isLoading = false;
        });
      } else {
        print('Failed to load properties: ${response.statusCode}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Error fetching properties: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final columns = isLandscape ? 3 : 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Horizon Real Estates'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Login',
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              final token = prefs.getString('token');
              if (token != null) {
                Navigator.pushNamed(context, '/dashboard');
              } else {
                Navigator.push(context, FadePageRoute(page: const LoginScreen()));
              }
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : properties.isEmpty
              ? const Center(child: Text('No properties found.'))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: properties.length,
                    itemBuilder: (context, index) {
                      final property = properties[index];
                      return PropertyCard(
                        title: property['title'] ?? '',
                        location: property['location'] ?? '',
                        price: 'LKR ${property['price'] ?? '0'}',
                        imageUrl: property['images'] != null &&
                                  property['images'].isNotEmpty &&
                                  property['images'][0].toString().isNotEmpty
                            ? '$baseUrl/${property['images'][0]}'
                            : '$baseUrl/storage/uploads/properties/default.jpg',

                        onViewDetails: () {
                          Navigator.push(
                            context,
                            FadePageRoute(page: PropertyDetailsScreen(property: property)),
                          );
                        },
                      );
                    },
                  ),
                ),
      bottomNavigationBar: const Footer(currentIndex: 0),
    );
  }
}

class PropertyCard extends StatelessWidget {
  final String title;
  final String location;
  final String price;
  final String imageUrl;
  final VoidCallback onViewDetails;

  const PropertyCard({
    super.key,
    required this.title,
    required this.location,
    required this.price,
    required this.imageUrl,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 100, color: Colors.grey),
                  )
                : const Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        location,
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        price,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onViewDetails,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('View Details'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
