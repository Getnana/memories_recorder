import 'package:flutter/material.dart';

class MemoryCard extends StatelessWidget {
  final String title;
  final String desc;
  final String date;

  const MemoryCard({
    super.key,
    required this.title,
    required this.desc,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        title: Text(title),
        subtitle: Text(desc),
        trailing: Text(date),
      ),
    );
  }
}
