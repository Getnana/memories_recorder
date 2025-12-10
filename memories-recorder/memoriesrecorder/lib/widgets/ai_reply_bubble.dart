import 'package:flutter/material.dart';

class AIReplyBubble extends StatelessWidget {
  final String text;
  final bool isUser; // kalau mau dipakai dua arah; untuk sekarang bisa selalu false

  const AIReplyBubble({
    super.key,
    required this.text,
    this.isUser = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final bubbleColor = isUser
        ? theme.colorScheme.primary
        : theme.colorScheme.surfaceVariant;
    final textColor = isUser
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.onSurface;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft:
                isUser ? const Radius.circular(16) : const Radius.circular(4),
            bottomRight:
                isUser ? const Radius.circular(4) : const Radius.circular(16),
          ),
        ),
        child: Text(
          text,
          style: textTheme.bodyMedium?.copyWith(
            color: textColor,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
