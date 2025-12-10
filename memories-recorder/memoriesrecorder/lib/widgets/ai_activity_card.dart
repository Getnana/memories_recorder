import 'package:flutter/material.dart';

class AIActivityCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback? onApply;

  const AIActivityCard({
    super.key,
    required this.title,
    required this.description,
    this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            offset: const Offset(0, 6),
            color: Colors.black.withOpacity(0.05),
          ),
        ],
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: ikon + judul
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.auto_awesome_outlined,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            description,
            style: textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.8),
              height: 1.5,
            ),
          ),

          const SizedBox(height: 12),

          if (onApply != null)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onApply,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Apply to my memory'),
              ),
            ),
        ],
      ),
    );
  }
}
