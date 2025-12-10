import 'dart:math';
import 'package:flutter/material.dart';

import '../../models/memory.dart';
import '../../services/memory_service.dart';
import '../../utils/responsive.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/memory_card.dart';
import '../../screens/ai/ai_recommendation_page.dart';

class HomePageList extends StatefulWidget {
  const HomePageList({super.key});

  @override
  State<HomePageList> createState() => _HomePageListState();
}

class _HomePageListState extends State<HomePageList> {
  final MemoryService _memoryService = MemoryService();

  bool _showIntro = true;

  final List<String> _quotes = [
    "Sometimes the smallest step in the right direction ends up being the biggest step of your life.",
    "Be gentle with yourself. You're doing the best you can.",
    "Your story matters, keep going.",
    "Every day may not be good, but there is something good in every day.",
    "You are stronger than you think.",
  ];

  late String _selectedQuote;

  @override
  void initState() {
    super.initState();
    _selectedQuote = _quotes[Random().nextInt(_quotes.length)];
  }

  void _goToCreateMemory() async {
    await Navigator.pushNamed(context, '/memoryCreate');
  }

  void _openMemory(Memory memory) async {
    await Navigator.pushNamed(context, '/memoryDetail', arguments: memory);
  }

  void _hideIntro() {
    setState(() {
      _showIntro = false;
    });
  }

  void _goToAISuggestions() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AIRecommendationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final horizontalPadding = Responsive.horizontalPadding(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Memories'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/notification');
            },
            icon: const Icon(Icons.notifications),
            tooltip: 'Notifications',
          ),
        ],
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 0),
      floatingActionButton: !_showIntro
          ? FloatingActionButton.extended(
              onPressed: _goToCreateMemory,
              icon: const Icon(Icons.add),
              label: const Text('New Memory'),
            )
          : null,
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: _showIntro
                  ? _buildIntroView(textTheme, theme)
                  : _buildListView(textTheme, theme, horizontalPadding),
            ),
            _buildMascot(),
          ],
        ),
      ),
    );
  }

  // ---------------- INTRO VIEW ----------------
  Widget _buildIntroView(TextTheme textTheme, ThemeData theme) {
    return GestureDetector(
      onTap: _hideIntro,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.book_rounded,
                size: 120,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                _selectedQuote,
                textAlign: TextAlign.center,
                style: textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.75),
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                "Tap The Book to continue",
                style: textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- LIST VIEW (REALTIME) ----------------
  Widget _buildListView(
      TextTheme textTheme, ThemeData theme, double horizontalPadding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 12),
      child: StreamBuilder<List<Memory>>(
        stream: _memoryService.memoriesStream(),   // ✔ FIXED — realtime per user
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final published = snapshot.data!
              .where((m) => !m.isDraft)
              .toList()
            ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

          if (published.isEmpty) {
            return Center(
              child: Text(
                'No memories yet.\nTap “New Memory” to start.',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            );
          }

          return ListView.separated(
            itemCount: published.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final memory = published[index];
              final date = memory.date;

              final formattedDate =
                  '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

              final desc = memory.content.length > 120
                  ? '${memory.content.substring(0, 120)}...'
                  : memory.content;

              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => _openMemory(memory),
                child: MemoryCard(
                  title: memory.title,
                  desc: desc,
                  date: formattedDate,
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ---------------- MASKOT ----------------
  Widget _buildMascot() {
    final theme = Theme.of(context);

    return Positioned(
      right: 16,
      bottom: 80,
      child: GestureDetector(
        onTap: _goToAISuggestions,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: Container(
            key: const ValueKey<String>("maskot"),
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Image.asset(
              'lib/assets/images/robot.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
