import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = MediaQuery.of(context).size.width * 0.1; // Misalnya responsive padding
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    // Controller untuk email
    TextEditingController emailController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),

                // Title
                Text(
                  'Forgot Password',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter your registered email address and we\'ll send you a link to reset your password.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                // Email label + field
                Text(
                  'Email',
                  style: textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.mail_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Button: Send reset link
                ElevatedButton(
                  onPressed: () async {
                    String email = emailController.text;

                    if (email.isEmpty) {
                      // Tampilkan pesan error jika email kosong
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please enter your email.")),
                      );
                      return;
                    }

                    try {
                      // Kirim email reset password
                      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                      // Navigasi ke halaman konfirmasi pengiriman reset email
                      Navigator.pushNamed(context, '/forgotPasswordSent');
                    } catch (e) {
                      // Tangani error
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: ${e.toString()}")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Send Reset Link',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),

                const SizedBox(height: 16),

                // Back to login
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Text('Back to Sign In'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
