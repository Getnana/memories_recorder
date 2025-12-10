import 'package:flutter/material.dart';

import '../../utils/responsive.dart';
import '../../widgets/bottom_nav.dart';

class HomePageEmpty extends StatelessWidget {
  const HomePageEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final horizontalPadding = Responsive.horizontalPadding(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Memories Recorder'),
        centerTitle: true,
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 0),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Ilustrasi / ikon kosong
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.primary.withOpacity(0.08),
                  ),
                  child: Icon(
                    Icons.menu_book_outlined,
                    size: 72,
                    color: theme.colorScheme.primary,
                  ),
                ),

                const SizedBox(height: 24),

                // Judul empty state
                Text(
                  'No Memories Yet',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                // Deskripsi singkat
                Text(
                  'Start by creating your first memory. Capture your thoughts, moments, and activities so you can revisit them anytime.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 28),

                // Tombol utama: Create Memory
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Arahkan ke halaman create/update memory dengan mode create
                      Navigator.pushNamed(context, '/memoryCreate');
                    },
                    icon: const Icon(Icons.add),
                    label: const Text(
                      'Create Memory',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Hint kecil (opsional)
                Text(
                  'You can always edit or save it as draft later.',
                  style: textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
