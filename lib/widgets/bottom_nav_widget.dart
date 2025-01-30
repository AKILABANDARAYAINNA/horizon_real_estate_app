import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/search_screen.dart';
import '../screens/post_ad_screen.dart';
import '../screens/agents_screen.dart';

class Footer extends StatelessWidget {
  final int currentIndex;
  const Footer({super.key, required this.currentIndex});

  void _navigateToScreen(BuildContext context, int index) {
    if (index == currentIndex) return; // Prevent unnecessary navigation

    Widget screen;
    switch (index) {
      case 0:
        screen = const HomeScreen();
        break;
      case 1:
        screen = const SearchScreen();
        break;
      case 2:
        screen = const PostAdScreen();
        break;
      case 3:
        screen = const AgentsScreen();
        break;
      default:
        screen = const HomeScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex, 
      onDestinationSelected: (index) {
        _navigateToScreen(context, index);
      },
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
        NavigationDestination(icon: Icon(Icons.add), label: 'Post Ad'),
        NavigationDestination(icon: Icon(Icons.group), label: 'Agents'),
      ],
    );
  }
}
