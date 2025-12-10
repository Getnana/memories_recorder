import 'package:flutter/material.dart';
import '../../widgets/bottom_nav.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: const Center(child: Text("User profile settings go here.")),
      bottomNavigationBar: const BottomNav(currentIndex: 2),
    );
  }
}
