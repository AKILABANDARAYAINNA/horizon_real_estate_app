import 'package:flutter/material.dart';
import '../widgets/bottom_nav_widget.dart';

class PostAdScreen extends StatelessWidget {
  const PostAdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Your Ad'),
        backgroundColor: const Color.fromARGB(255, 0, 110, 4),
      ),
      body: const Center(
        child: Text('Ad Posting Form Here'),
      ),
      bottomNavigationBar: const Footer(currentIndex: 2), // ✅ Highlight Post Ad Tab
    );
  }
}
