import 'package:flutter/material.dart';

class ThemeSettingsPage extends StatefulWidget {
  const ThemeSettingsPage({super.key});

  @override
  _ThemeSettingsPageState createState() => _ThemeSettingsPageState();
}

class _ThemeSettingsPageState extends State<ThemeSettingsPage> {
  bool _isDarkMode = false; // Default ke Light mode

  void _toggleTheme(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personalization'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'Choose your theme',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Dark Mode'),
                Switch(
                  value: _isDarkMode,
                  onChanged: _toggleTheme,
                  activeColor: Colors.white,
                  inactiveTrackColor: Colors.grey,
                  inactiveThumbColor: Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
