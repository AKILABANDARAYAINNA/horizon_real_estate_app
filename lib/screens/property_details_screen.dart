import 'package:flutter/material.dart';

class PropertyDetailsScreen extends StatelessWidget {
  final Map<String, String> property;

  const PropertyDetailsScreen({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(property['title']!),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                property['image']!,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 250, color: Colors.grey);
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              property['title']!,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              property['location']!,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              property['price']!,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 16),

            // ExpansionTile for Additional Details as Another Component Type
            ExpansionTile(
              title: const Text("Additional Details"),
              leading: const Icon(Icons.info_outline, color: Colors.green), 
              children: const [
                ListTile(
                  title: Text("Land Area: 20 Perches"),
                ),
                ListTile(
                  title: Text("Year Built: 2019"),
                ),
                ListTile(
                  title: Text("Parking Spaces: 2"),
                ),
                ListTile(
                  title: Text("Ownership: Freehold"),
                ),
              ],
            ),

            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Contacting Seller...')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, 
                  foregroundColor: Colors.white, 
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: const Text("Contact Seller"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
