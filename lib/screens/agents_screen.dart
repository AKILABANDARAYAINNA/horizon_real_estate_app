import 'package:flutter/material.dart';
import '../widgets/bottom_nav_widget.dart';

class AgentsScreen extends StatelessWidget {
  const AgentsScreen({super.key});

  // Sample Agents Data
  final List<Map<String, dynamic>> agents = const [
    {
      'name': 'Arjun',
      'image': 'https://www.profilebakery.com/wp-content/uploads/2024/05/Profile-picture-created-with-ai.jpeg',
      'rating': 4.5,
    },
    {
      'name': 'Kamala',
      'image': 'https://www.profilebakery.com/wp-content/uploads/2023/04/AI-Profile-Picture.jpg',
      'rating': 4.8,
    },
    {
      'name': 'Banda',
      'image': 'https://www.profilebakery.com/wp-content/uploads/2023/04/PROFILE-PICTURE-FOR-FACEBOOK.jpg',
      'rating': 4.2,
    },
    {
      'name': 'Chanuli',
      'image': 'https://www.profilebakery.com/wp-content/uploads/2023/04/women-AI-Profile-Picture.jpg',
      'rating': 4.7,
    },
    {
      'name': 'Ranjith',
      'image': 'https://www.profilebakery.com/wp-content/uploads/2023/04/Profile-Image-AI.jpg',
      'rating': 4.3,
    },
    {
      'name': 'Chithra',
      'image': 'https://easy-peasy.ai/cdn-cgi/image/quality=80,format=auto,width=700/https://fdczvxmwwjwpwbeeqcth.supabase.co/storage/v1/object/public/images/78e88f76-29bf-4289-9624-719aec0f7bcb/e516f677-4846-4a28-9707-ba00ffa49479.png',
      'rating': 3.2,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Detecting screen orientation
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final columns = isLandscape ? 3 : 2; // 3 columns in landscape, 2 in portrait

    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Agents'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns, // Adjusting columns dynamically
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.8,
          ),
          itemCount: agents.length,
          itemBuilder: (context, index) {
            final agent = agents[index];
            return AgentCard(
              name: agent['name'],
              imageUrl: agent['image'],
              rating: agent['rating'],
            );
          },
        ),
      ),
      bottomNavigationBar: const Footer(currentIndex: 3), // Highlighting "Agents" tab
    );
  }
}

// Agent Card Widget
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
            backgroundImage: NetworkImage(imageUrl),
            radius: 50,
            onBackgroundImageError: (_, __) => const Icon(
              Icons.person,
              size: 50,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 1; i <= 5; i++)
                Icon(
                  i <= rating ? Icons.star : Icons.star_border,
                  size: 16,
                  color: i <= rating ? Colors.amber : Colors.grey,
                ),
            ],
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Connected with $name')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white, 
              textStyle: const TextStyle(fontSize: 14),
            ),
            child: const Text('Connect'),
          ),
        ],
      ),
    );
  }
}
