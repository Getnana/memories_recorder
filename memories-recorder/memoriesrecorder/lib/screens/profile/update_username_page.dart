import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/responsive.dart';
import '../../services/auth_service.dart';

class UpdateUsernamePage extends StatefulWidget {
  const UpdateUsernamePage({super.key});

  @override
  State<UpdateUsernamePage> createState() => _UpdateUsernamePageState();
}

class _UpdateUsernamePageState extends State<UpdateUsernamePage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _usernameController.text = user?.displayName ?? '';
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  // update username
  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await AuthService().updateUsername(_usernameController.text.trim());

      // **Memastikan widget masih terpasang**
      if (!mounted) return;
      setState(() => _isLoading = false);
      
      // **Menampilkan Snackbar terlebih dahulu**
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username updated successfully.')),
      );

      // **Pemberian sedikit waktu agar snackbar terlihat sebelum navigasi**
      await Future.delayed(Duration(seconds: 1)); // Penundaan 1 detik

      // **PushReplacementNamed untuk menggantikan halaman**
      Navigator.pushNamedAndRemoveUntil(context, '/profile', (route) => false);
    } on AuthException catch (e) {
      if (!mounted) return;
      // **Pesan kesalahan jika terjadi AuthException**
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;
      // **Tampilkan pesan kesalahan untuk kesalahan lainnya**
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update username: $e')));
    } finally {
      // **Pastikan setState untuk menghentikan loading dijalankan di akhirnya**
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final horizontalPadding = Responsive.horizontalPadding(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Update Username'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 24,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('New Username', style: textTheme.labelLarge),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your new username',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Username cannot be empty';
                    }
                    if (value.trim().length < 3) {
                      return 'Username should be at least 3 characters';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _isLoading ? null : _onSave,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),

                const SizedBox(height: 12),

                TextButton(
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

