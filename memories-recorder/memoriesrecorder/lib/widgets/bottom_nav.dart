import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;

  const BottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/homeList');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/draft');
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/profile');
            break;
        }
      },
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), label: "Home"),
        NavigationDestination(icon: Icon(Icons.add), label: "Draft"),
        NavigationDestination(icon: Icon(Icons.person_outline), label: "Profile"),
      ],
    );
  }
}
