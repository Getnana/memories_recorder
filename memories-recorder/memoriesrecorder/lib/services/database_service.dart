import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.reference();

  // Menyimpan data pengguna
  Future<void> saveUserData(String userId, String username, String email) async {
    try {
      await _dbRef.child("users").child(userId).set({
        'username': username,
        'email': email,
        'createdAt': DateTime.now().toString(),
      });
      print('Data user disimpan dengan sukses');
    } catch (e) {
      print('Error menyimpan data user: $e');
    }
  }

  // Mengambil data pengguna
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      DataSnapshot snapshot = await _dbRef.child("users").child(userId).get();
      if (snapshot.exists) {
        return Map<String, dynamic>.from(snapshot.value as Map);
      } else {
        return null;
      }
    } catch (e) {
      print('Error mengambil data user: $e');
      return null;
    }
  }
}
