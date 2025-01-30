import 'package:flutter/material.dart';
import '../widgets/bottom_nav_widget.dart';
import 'login_screen.dart';
import 'property_details_screen.dart'; // Import Property Details Screen

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Map<String, String>> properties = const [
    {
      'title': 'Luxury Villa',
      'location': 'Kottawa',
      'price': 'LKR 12,000,000',
      'description': 'A luxury villa with modern amenities and a beautiful garden.',
      'image': 'https://mistertlk.s3.ap-southeast-1.amazonaws.com/property/sales/1317_1_1736505292.jpg',
    },
    {
      'title': 'Modern House',
      'location': 'Colombo 3',
      'price': 'LKR 850,000',
      'description': 'A modern house located in the heart of Colombo.',
      'image': 'https://luxely.lk/img/properties/4750466-8918501.jpeg',
    },
    {
      'title': 'Building for sale',
      'location': 'Maharagama',
      'price': 'LKR 9,500,000',
      'description': 'A commercial building ideal for office spaces.',
      'image': 'https://www.lankapropertyweb.com/pics/5733795/thumb_5733795_1737112221_6826.jpeg',
    },
    {
      'title': 'Flat Land',
      'location': 'Ratnapura',
      'price': 'LKR 7,000,000',
      'description': 'A flat land suitable for agricultural or residential use.',
      'image': 'https://remaxnorth.lk/wp-content/uploads/2025/01/WhatsApp-Image-2025-01-13-at-5.00.20-PM-525x328.jpeg',
    },
    {
      'title': 'Rubber Estate for Sale',
      'location': 'Horana',
      'price': 'LKR 6,550,000',
      'description': 'A rubber estate with excellent yield potential.',
      'image': 'https://www.lankapropertyweb.com/pics/528906/thumb_528906_1715875867_3854.jpeg',
    },
    {
      'title': 'Building for Rent',
      'location': 'Nugegoda',
      'price': 'LKR 150,000',
      'description': 'A building ideal for restaurants or retail shops.',
      'image': 'https://colomborealtors.lk/wp-content/uploads/2021/08/15000-sqft-road-frontage-malabe-junction-new-kandy-road-commercial-building-rent-lease-best-colombo-realtors-lk-sri-lanka-sl-94.jpg',
    },
  ];

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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
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
              title: property['title']!,
              location: property['location']!,
              price: property['price']!,
              imageUrl: property['image']!,
              onViewDetails: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PropertyDetailsScreen(property: property),
                  ),
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
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(location, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 8),
          Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: onViewDetails,
             style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green, // ✅ Green Button
              foregroundColor: Colors.white, // ✅ White Text
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('View Details'),
          ),
        ],
      ),
    );
  }
}
