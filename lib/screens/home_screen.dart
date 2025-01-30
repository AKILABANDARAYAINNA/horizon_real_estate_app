import 'package:flutter/material.dart';
import '../widgets/bottom_nav_widget.dart';
import 'login_screen.dart'; // Import Login Screen

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // ✅ Updated Property Data
  final List<Map<String, String>> properties = const [
    {
      'title': 'Luxury Villa',
      'location': 'Kottawa',
      'price': 'LKR 12,000,000',
      'image': 'https://mistertlk.s3.ap-southeast-1.amazonaws.com/property/sales/1317_1_1736505292.jpg',
    },
    {
      'title': 'Modern House',
      'location': 'Colombo 3',
      'price': 'LKR 850,000',
      'image': 'https://luxely.lk/img/properties/4750466-8918501.jpeg',
    },
    {
      'title': 'Building for sale',
      'location': 'Maharagama',
      'price': 'LKR 9,500,000',
      'image': 'https://www.lankapropertyweb.com/pics/5733795/thumb_5733795_1737112221_6826.jpeg',
    },
    {
      'title': 'Flat Land',
      'location': 'Ratnapura',
      'price': 'LKR 7,000,000',
      'image': 'https://remaxnorth.lk/wp-content/uploads/2025/01/WhatsApp-Image-2025-01-13-at-5.00.20-PM-525x328.jpeg',
    },
    {
      'title': 'Rubber Estate for Sale',
      'location': 'Horana',
      'price': 'LKR 6,550,000',
      'image': 'https://www.lankapropertyweb.com/pics/528906/thumb_528906_1715875867_3854.jpeg',
    },
    {
      'title': 'Building for Rent',
      'location': 'Nugegoda',
      'price': 'LKR 150,000',
      'image': 'https://colomborealtors.lk/wp-content/uploads/2021/08/15000-sqft-road-frontage-malabe-junction-new-kandy-road-commercial-building-rent-lease-best-colombo-realtors-lk-sri-lanka-sl-94.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Horizon Real Estates'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.person), // Login Button
            tooltip: 'Login',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded( // ✅ Prevents Overflow Issue
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView( // ✅ Allows scrolling if needed
                  physics: const BouncingScrollPhysics(),
                  child: GridView.builder(
                    shrinkWrap: true, // ✅ Ensures GridView does not take infinite height
                    physics: const NeverScrollableScrollPhysics(), // ✅ Prevents double scrolling
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // ✅ 2 Cards Per Row
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.7, // ✅ Adjusted to Fix Overflow
                    ),
                    itemCount: properties.length,
                    itemBuilder: (context, index) {
                      final property = properties[index];
                      return PropertyCard(
                        title: property['title']!,
                        location: property['location']!,
                        price: property['price']!,
                        imageUrl: property['image']!,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Footer(currentIndex: 0),
    );
  }
}

// ✅ Updated Property Card Widget
class PropertyCard extends StatelessWidget {
  final String title;
  final String location;
  final String price;
  final String imageUrl;

  const PropertyCard({
    super.key,
    required this.title,
    required this.location,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.network(
              imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image, size: 120, color: Colors.grey);
              },
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  location,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Text(
                  price,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
          ),
          const Spacer(), // ✅ Pushes button to the bottom
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Viewing Details of $title')),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                textStyle: const TextStyle(fontSize: 14),
              ),
              child: const Text('View Details'),
            ),
          ),
        ],
      ),
    );
  }
}
