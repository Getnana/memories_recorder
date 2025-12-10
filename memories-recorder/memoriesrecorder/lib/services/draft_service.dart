import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/memory.dart';

class DraftService {
  static final DraftService _instance = DraftService._internal();
  factory DraftService() => _instance;
  DraftService._internal();

  /// SAVE draft
  Future<void> saveDraft(Memory memory) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final ref = FirebaseDatabase.instance.ref('users/${user.uid}/drafts');

    await ref.push().set({
      'id': memory.id,
      'title': memory.title,
      'content': memory.content,
      'date': memory.date.toIso8601String(),
      'createdAt': memory.createdAt.toIso8601String(),
      'updatedAt': memory.updatedAt.toIso8601String(),
      'isDraft': true,
      'aiSuggestion': memory.aiSuggestion,
    });
  }

  /// GET all drafts
  Future<List<Memory>> fetchDrafts() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final ref = FirebaseDatabase.instance.ref('users/${user.uid}/drafts');
    final snapshot = await ref.get();

    if (!snapshot.exists) return [];

    List<Memory> result = [];

    for (var child in snapshot.children) {
      final data = child.value as Map;

      result.add(
        Memory(
          id: data['id'],
          title: data['title'],
          content: data['content'],
          date: DateTime.parse(data['date']),
          createdAt: DateTime.parse(data['createdAt']),
          updatedAt: DateTime.parse(data['updatedAt']),
          isDraft: true,
          aiSuggestion: data['aiSuggestion'],
        ),
      );
    }

    return result;
  }

  /// DELETE draft
  Future<void> deleteDraft(String draftKey) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final ref = FirebaseDatabase.instance.ref('users/${user.uid}/drafts/$draftKey');
    await ref.remove();
  }
}
