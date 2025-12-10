import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/app_user.dart';

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}

class AuthService {
  AuthService._internal();
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();  // Realtime Database

  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  /// Stream perubahan user (login / logout / update profile / theme)
  Stream<AppUser?> get userChanges async* {
    await for (final firebaseUser in _firebaseAuth.authStateChanges()) {
      if (firebaseUser == null) {
        _currentUser = null;
        yield null;
        continue;
      }

      try {
        await firebaseUser.reload();
      } catch (_) {
        // kadang error di web, abaikan saja
      }

      _currentUser = await _fromFirebaseUser(firebaseUser);
      yield _currentUser;
    }
  }

  Future<AppUser> _fromFirebaseUser(User user) async {
    Map<String, dynamic>? data;
    try {
      // Mengambil data dari realtime database
      final snapshot = await _dbRef.child('users').child(user.uid).get();
      if (snapshot.exists) {
        data = Map<String, dynamic>.from(snapshot.value as Map);
      }
    } catch (_) {
      // Jika terjadi error, gunakan data default
    }

    return AppUser(
      id: user.uid,
      username:
          (data?['username'] as String?) ?? user.displayName ?? 'Anonymous',
      email: (data?['email'] as String?) ?? user.email ?? '',
      password: '',
      createdAt: user.metadata.creationTime ?? DateTime.now(),
      isDarkMode: (data?['isDarkMode'] as bool?) ?? false,
    );
  }

  // ---------------------------------------------------------------------------
  // AUTH DASAR
  // ---------------------------------------------------------------------------

  Future<AppUser> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw const AuthException('User not created');
      }

      // Update displayName di Auth
      await user.updateDisplayName(username);

      // Simpan data user ke realtime database
      await _dbRef.child('users').child(user.uid).set({
        'username': username,
        'email': email,
        'isDarkMode': false,
        'createdAt': DateTime.now().toString(),
      });

      _currentUser = await _fromFirebaseUser(user);
      return _currentUser!;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Registration failed');
    }
  }

  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = cred.user;
      if (user == null) {
        throw const AuthException('Login failed: user is null');
      }

      _currentUser = await _fromFirebaseUser(user);
      return _currentUser!;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Login failed');
    }
  }

  Future<void> loadUserProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    } catch (_) {}
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    _currentUser = null;
  }

  // ---------------------------------------------------------------------------
  // UPDATE ACCOUNT
  // ---------------------------------------------------------------------------

  /// Update username (displayName di Auth + `username` di Firestore)
  Future<AppUser> updateUsername(String newUsername) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw const AuthException('No user logged in');
    }

    try {
      // Update displayName di Auth
      await user.updateDisplayName(newUsername);

      // Update username di realtime database
      await _dbRef.child('users').child(user.uid).update({
        'username': newUsername,
      });

      _currentUser = await _fromFirebaseUser(user);
      return _currentUser!;
    } catch (e) {
      throw AuthException('Failed to update username: $e');
    }
  }

  /// Update email (langsung, tanpa kirim link verifikasi)
  Future<void> updateEmail(String newEmail, String currentPassword) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw const AuthException('No user logged in');
    }

    try {
      // 1. Re-auth pakai email & password SEKARANG
      final cred = EmailAuthProvider.credential(
        email: user.email ?? '',
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(cred);

      // 2. MINTA FIREBASE kirim email verifikasi ke EMAIL BARU
      //    Ini cara resmi & satu-satunya yang diizinkan sekarang.
      await user.verifyBeforeUpdateEmail(newEmail.trim());

      // 3. (Opsional) catat pendingEmail di Firestore biar kelihatan aja
      await _dbRef.child('users').child(user.uid).update({
        'pendingEmail': newEmail.trim(),
      });

      // Belum ada perubahan di _currentUser karena email baru
      // baru aktif setelah link di email DIKLIK.
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Failed to request email change');
    } catch (e) {
      throw AuthException('Failed to request email change: $e');
    }
  }

  /// Update password
  Future<void> updatePassword(
    String currentPassword,
    String newPassword,
  ) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw const AuthException('No user logged in');
    }

    try {
      final cred = EmailAuthProvider.credential(
        email: user.email ?? '',
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);

      _currentUser = await _fromFirebaseUser(user);
    } catch (e) {
      throw AuthException('Failed to update password: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // THEME (DARK / LIGHT)
  // ---------------------------------------------------------------------------

  Future<void> updateTheme(bool isDarkMode) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw const AuthException('No user logged in');
    }

    try {
      await _dbRef.child('users').child(user.uid).update({
        'isDarkMode': isDarkMode,
      });

      if (_currentUser != null) {
        _currentUser = _currentUser!.copyWith(isDarkMode: isDarkMode);
      }
    } catch (e) {
      throw AuthException('Failed to update theme: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // MENAMBAHKAN DATA PENGGUNA KE REALETIME DATABASE
  // ---------------------------------------------------------------------------

  /// Fungsi untuk mendapatkan data pengguna berdasarkan UID
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final snapshot = await _dbRef.child('users').child(uid).get();
      if (snapshot.exists) {
        return Map<String, dynamic>.from(snapshot.value as Map);
      } else {
        return null;  // Jika data tidak ditemukan
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;  // Error saat mengambil data
    }
  }

  /// Fungsi untuk menyimpan data pengguna di Realtime Database
  Future<void> saveUserData(String uid, String email, String username) async {
    try {
      await _dbRef.child('users').child(uid).set({
        'email': email,
        'username': username,
        'createdAt': DateTime.now().toString(),
      });
    } catch (e) {
      print('Error saving user data: $e');
    }
  }
}
