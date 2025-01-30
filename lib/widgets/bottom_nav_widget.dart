import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/search_screen.dart';
import '../screens/post_ad_screen.dart';
import '../screens/agents_screen.dart';

class Footer extends StatelessWidget {
  final int currentIndex;
  const Footer({super.key, required this.currentIndex});

  void _navigateToScreen(BuildContext context, int index) {
    if (index == currentIndex) return; // Preventing unnecessary navigation

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
      backgroundColor: Colors.white, 
      indicatorColor: Colors.transparent,
      selectedIndex: currentIndex, 
      onDestinationSelected: (index) {
        _navigateToScreen(context, index);
      },
      destinations: [
        NavigationDestination(
          icon: Icon(Icons.home, color: currentIndex == 0 ? Colors.green : Colors.grey),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.search, color: currentIndex == 1 ? Colors.green : Colors.grey),
          label: 'Search',
        ),
        NavigationDestination(
          icon: Icon(Icons.add, color: currentIndex == 2 ? Colors.green : Colors.grey),
          label: 'Post Ad',
        ),
        NavigationDestination(
          icon: Icon(Icons.group, color: currentIndex == 3 ? Colors.green : Colors.grey),
          label: 'Agents',
        ),
      ],
    );
  }
}
