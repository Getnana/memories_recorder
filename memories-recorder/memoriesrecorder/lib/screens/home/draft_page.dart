import 'package:flutter/material.dart';

import '../../models/memory.dart';
import '../../services/memory_service.dart';
import '../../utils/responsive.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/memory_card.dart';

class DraftPage extends StatefulWidget {
  const DraftPage({super.key});

  @override
  State<DraftPage> createState() => _DraftPageState();
}

class _DraftPageState extends State<DraftPage> {
  final MemoryService _memoryService = MemoryService();
  List<Memory> _drafts = [];

  @override
  void initState() {
    super.initState();
    _loadDrafts();
  }

  void _loadDrafts() {
    setState(() {
      _drafts = _memoryService.getDrafts();
    });
  }

  Future<void> _goToCreateDraft() async {
    await Navigator.pushNamed(context, '/memoryCreate');
    _loadDrafts();
  }

  Future<void> _goToUpdateDraft(Memory draft) async {
    await Navigator.pushNamed(
      context,
      '/memoryUpdate',
      arguments: draft,
    );
    _loadDrafts();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final horizontalPadding = Responsive.horizontalPadding(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Drafts'),
        centerTitle: true,
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 1),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToCreateDraft,
        icon: const Icon(Icons.add),
        label: const Text('New Draft'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 12,
          ),
          child: _drafts.isEmpty
              ? _buildEmptyState(textTheme, theme)
              : ListView.separated(
                  itemCount: _drafts.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final draft = _drafts[index];
                    final date = draft.date;
                    final formattedDate =
                        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

                    final desc = draft.content.length > 120
                        ? '${draft.content.substring(0, 120)}...'
                        : draft.content;

                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _goToUpdateDraft(draft),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Badge "Draft"
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin:
                                  const EdgeInsets.only(left: 4, bottom: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.secondary
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                'Draft',
                                style: textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.secondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          MemoryCard(
                            title: draft.title,
                            desc: desc,
                            date: formattedDate,
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(TextTheme textTheme, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.insert_drive_file_outlined,
            size: 72,
            color: theme.colorScheme.primary.withOpacity(0.8),
          ),
          const SizedBox(height: 16),
          Text(
            'No drafts yet',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start writing a memory and save it as draft if you\'re not ready to publish.',
            style: textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
