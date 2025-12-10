import 'package:flutter/material.dart';

import '../../models/memory.dart';
import '../../utils/responsive.dart';

class MemorySinglePage extends StatelessWidget {
  const MemorySinglePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final horizontalPadding = Responsive.horizontalPadding(context);

    // Ambil argument Memory
    final args = ModalRoute.of(context)?.settings.arguments;
    final memory = args is Memory ? args : null;

    if (memory == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Memory Detail'),
        ),
        body: const Center(
          child: Text('Memory not found.'),
        ),
      );
    }

    final date = memory.date;
    final formattedDate =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Detail'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/memoryUpdate',
                arguments: memory,
              );
            },
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Memory',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    formattedDate,
                    style: textTheme.bodyMedium?.copyWith(
                      color:
                          theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Title
              Text(
                memory.title,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              // Content
              Text(
                memory.content.isEmpty
                    ? 'No content has been written for this memory yet.'
                    : memory.content,
                style: textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 32),

              Divider(
                thickness: 0.8,
                color: theme.dividerColor.withOpacity(0.7),
              ),

              const SizedBox(height: 16),

              /// AI SECTION
              Text(
                'AI Suggestions',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                memory.aiSuggestion ??
                    'In the future, AI can generate reflections or activity ideas for this memory.',
                style: textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),

              const SizedBox(height: 12),

              // === BUTTON menuju AI Recommendation Page ===
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/aiRecommendation');
                },
                icon: const Icon(Icons.auto_awesome_outlined),
                label: const Text('Ask AI about this memory'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
