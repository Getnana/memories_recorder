import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DeleteAccountPage extends StatelessWidget {
  const DeleteAccountPage({super.key});

  void _confirmDelete(BuildContext context) async {
    try {
      // Mendapatkan pengguna yang sedang login
      User? user = FirebaseAuth.instance.currentUser;

      // Jika pengguna ada dan terautentikasi
      if (user != null) {
        // Menghapus akun pengguna
        await user.delete();

        // Berhasil menghapus akun, beri umpan balik ke pengguna
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account deleted successfully.'),
          ),
        );

        // Arahkan pengguna ke halaman login setelah penghapusan akun
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      } else {
        // Jika tidak ada pengguna yang terautentikasi
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No user is currently logged in.'),
          ),
        );
      }
    } catch (e) {
      // Tangani error jika penghapusan akun gagal (misalnya masalah jaringan atau pengguna tidak dapat dihapus)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Account'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.delete_forever_outlined,
                size: 72,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Are you sure?',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Deleting your account will permanently remove your profile and all of your memories from this app. This action cannot be undone.',
                style: textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: () => _confirmDelete(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                  foregroundColor: theme.colorScheme.onError,
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Yes, delete my account',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context); // Kembali ke halaman sebelumnya
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
