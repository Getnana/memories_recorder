import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class TestDatabasePage extends StatefulWidget {
  const TestDatabasePage({super.key});

  @override
  State<TestDatabasePage> createState() => _TestDatabasePageState();
}

class _TestDatabasePageState extends State<TestDatabasePage> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref(); // Referensi ke Realtime Database
  bool _isDataSaved = false;
  String _retrievedData = '';  // Untuk menyimpan data yang diambil dari Firebase

  // Controller untuk menangani input
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Fungsi untuk menyimpan data
  Future<void> saveData() async {
    try {
      // Simpan data pengguna ke Realtime Database
      await _dbRef.child('users').child('user123').set({
        'username': _usernameController.text,
        'email': _emailController.text,
        'createdAt': DateTime.now().toString(),
      });

      setState(() {
        _isDataSaved = true; // Tandakan bahwa data telah disimpan
      });

      print('Data saved successfully!');
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  // Fungsi untuk mengambil data
  Future<void> getData() async {
    try {
      final snapshot = await _dbRef.child('users').child('user123').get();
      if (snapshot.exists) {
        setState(() {
          _retrievedData = snapshot.value.toString();
        });
        print('Data retrieved: ${snapshot.value}');
      } else {
        setState(() {
          _retrievedData = 'No data available';
        });
      }
    } catch (e) {
      print('Error retrieving data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Realtime Database')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input fields untuk username dan email
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Tombol untuk menyimpan data ke Firebase
            ElevatedButton(
              onPressed: saveData,
              child: const Text('Save Data to Realtime Database'),
            ),
            if (_isDataSaved)
              const Text('Data has been saved successfully!'),
            const SizedBox(height: 20),

            // Tombol untuk mengambil data dari Firebase
            ElevatedButton(
              onPressed: getData,
              child: const Text('Get Data from Realtime Database'),
            ),
            const SizedBox(height: 20),

            // Menampilkan data yang diambil dari Firebase
            if (_retrievedData.isNotEmpty)
              Text('Retrieved Data: $_retrievedData'),
          ],
        ),
      ),
    );
  }
}
