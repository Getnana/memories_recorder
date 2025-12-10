import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final IconData icon;
  final String hint;
  final bool obscure;

  const AuthTextField({
    super.key,
    required this.icon,
    required this.hint,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscure,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
      ),
    );
  }
}
