import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/responsive.dart';
import '../../widgets/bottom_nav.dart';
import '../../services/auth_service.dart';
import 'theme_settings_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final horizontalPadding = Responsive.horizontalPadding(context);

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Kalau entah kenapa user = null, suruh login lagi
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('No user logged in. Please sign in again.'),
        ),
      );
    }

    final username = user.displayName ?? 'Anonymous';
    final email = user.email ?? '';
    final createdAt = user.metadata.creationTime ?? DateTime.now();
    final joined =
        'Joined ${createdAt.day.toString().padLeft(2, '0')}/${createdAt.month.toString().padLeft(2, '0')}/${createdAt.year}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header user
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor:
                        theme.colorScheme.primary.withOpacity(0.15),
                    child: Text(
                      username.isNotEmpty ? username[0].toUpperCase() : '?',
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          email,
                          style: textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          joined,
                          style: textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Divider(
                thickness: 0.8,
                color: theme.dividerColor.withOpacity(0.7),
              ),

              const SizedBox(height: 8),

              Text(
                'Account Settings',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              // Update username
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Update Username'),
                subtitle: const Text('Change how your name appears'),
                onTap: () {
                  Navigator.pushNamed(context, '/updateUsername');
                },
              ),

              // Update email
              ListTile(
                leading: const Icon(Icons.mail_outline),
                title: const Text('Update Email'),
                subtitle: const Text('Change your login email address'),
                onTap: () {
                  Navigator.pushNamed(context, '/updateEmail');
                },
              ),

              // Update password
              ListTile(
                leading: const Icon(Icons.lock_outline),
                title: const Text('Update Password'),
                subtitle: const Text('Set a new password to secure your account'),
                onTap: () {
                  Navigator.pushNamed(context, '/updatePassword');
                },
              ),

              const SizedBox(height: 8),

              Divider(
                thickness: 0.8,
                color: theme.dividerColor.withOpacity(0.7),
              ),

              const SizedBox(height: 8),

              // Personalization (tema)
              ListTile(
                leading: const Icon(Icons.palette_outlined),
                title: const Text('Personalization'),
                subtitle: const Text('Change your app theme'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ThemeSettingsPage(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Danger Zone
              Text(
                'Danger Zone',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.error,
                ),
              ),

              const SizedBox(height: 8),

              ListTile(
                leading: Icon(
                  Icons.delete_forever_outlined,
                  color: theme.colorScheme.error,
                ),
                title: Text(
                  'Delete Account',
                  style: TextStyle(
                    color: theme.colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  'Permanently remove your account and memories',
                  style: textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/deleteAccount');
                },
              ),

              const SizedBox(height: 16),

              // Logout
              OutlinedButton.icon(
                onPressed: () async {
                  await AuthService().logout();
                  // abaikan warning use_build_context_synchronously, sederhana saja dulu
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
