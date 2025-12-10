// lib/services/memory_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/memory.dart';

class MemoryService {
  MemoryService._internal();
  static final MemoryService _instance = MemoryService._internal();
  factory MemoryService() => _instance;

  final FirebaseDatabase _db = FirebaseDatabase.instance;

  /// 🔐 Ambil UID user aktif
  String get _uid {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");
    return user.uid;
  }

  /// ================================================================
  /// 🔹 CREATE MEMORY
  /// ================================================================
  Future<Memory> createMemory({
    required String title,
    required String content,
    required DateTime date,
    bool isDraft = false,
    String? aiSuggestion,
  }) async {
    final now = DateTime.now();
    final id = "mem_${now.microsecondsSinceEpoch}";

    final memory = Memory(
      id: id,
      title: title,
      content: content,
      date: date,
      createdAt: now,
      updatedAt: now,
      isDraft: isDraft,
      aiSuggestion: aiSuggestion,
    );

    final path = isDraft
        ? "drafts/$_uid/$id"
        : "memories/$_uid/$id";

    await _db.ref(path).set(memory.toMap());

    return memory;
  }

  /// ================================================================
  /// 🔹 STREAM MEMORY (published)
  /// ================================================================
  Stream<List<Memory>> memoriesStream() {
    return _db.ref("memories/$_uid").onValue.map((event) {
      if (event.snapshot.value == null) return [];

      final raw = Map<String, dynamic>.from(event.snapshot.value as Map);

      return raw.entries.map((e) {
        final map = Map<String, dynamic>.from(e.value);
        map["id"] = e.key;
        return Memory.fromMap(map);
      }).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
    });
  }

  /// ================================================================
  /// 🔹 STREAM DRAFTS
  /// ================================================================
  Stream<List<Memory>> draftsStream() {
    return _db.ref("drafts/$_uid").onValue.map((event) {
      if (event.snapshot.value == null) return [];

      final raw = Map<String, dynamic>.from(event.snapshot.value as Map);

      return raw.entries.map((e) {
        final map = Map<String, dynamic>.from(e.value);
        map["id"] = e.key;
        return Memory.fromMap(map);
      }).toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    });
  }

  /// ================================================================
  /// 🔹 ALIAS — supaya file lama tetap bekerja
  /// ================================================================
  Stream<List<Memory>> getAllStream() => memoriesStream();
  Stream<List<Memory>> getDraftStream() => draftsStream();

  /// ================================================================
  /// 🔹 GET ONCE (NO STREAM)
  /// ================================================================
  Future<List<Memory>> getMemoriesOnce() async {
    final snap = await _db.ref("memories/$_uid").get();
    if (!snap.exists || snap.value == null) return [];

    final raw = Map<String, dynamic>.from(snap.value as Map);

    return raw.entries.map((e) {
      final map = Map<String, dynamic>.from(e.value);
      map["id"] = e.key;
      return Memory.fromMap(map);
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<List<Memory>> getDraftsOnce() async {
    final snap = await _db.ref("drafts/$_uid").get();
    if (!snap.exists || snap.value == null) return [];

    final raw = Map<String, dynamic>.from(snap.value as Map);

    return raw.entries.map((e) {
      final map = Map<String, dynamic>.from(e.value);
      map["id"] = e.key;
      return Memory.fromMap(map);
    }).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  /// dipakai LoginScreen → cek apakah user punya memory
  Future<bool> hasPublished() async {
    final list = await getMemoriesOnce();
    return list.isNotEmpty;
  }

  /// ================================================================
  /// 🔹 GET BY ID (untuk detail page)
  /// ================================================================
  Future<Memory?> getById(String id, {required bool isDraft}) async {
    final path = isDraft
        ? "drafts/$_uid/$id"
        : "memories/$_uid/$id";

    final snap = await _db.ref(path).get();
    if (!snap.exists || snap.value == null) return null;

    final map = Map<String, dynamic>.from(snap.value as Map);
    map["id"] = id;

    return Memory.fromMap(map);
  }

  /// ================================================================
  /// 🔹 UPDATE MEMORY
  /// ================================================================
  Future<void> updateMemory(
    String id, {
    required bool wasDraft,
    required String title,
    required String content,
    required DateTime date,
    required bool isDraft,
  }) async {
    final now = DateTime.now();

    /// ambil lokasi lama (draft atau memory)
    final oldPath = wasDraft
        ? "drafts/$_uid/$id"
        : "memories/$_uid/$id";

    /// hapus dari lokasi lama jika pindah kategori
    if (wasDraft != isDraft) {
      await _db.ref(oldPath).remove();
    }

    final newPath = isDraft
        ? "drafts/$_uid/$id"
        : "memories/$_uid/$id";

    final updated = {
      "id": id,
      "title": title,
      "content": content,
      "date": date.toIso8601String(),
      "createdAt": now.toIso8601String(), // tidak masalah overwrite
      "updatedAt": now.toIso8601String(),
      "isDraft": isDraft,
    };

    await _db.ref(newPath).set(updated);
  }

  /// ================================================================
  /// 🔹 DELETE MEMORY
  /// ================================================================
  Future<void> deleteMemory(String id, {required bool isDraft}) async {
    final path = isDraft
        ? "drafts/$_uid/$id"
        : "memories/$_uid/$id";

    await _db.ref(path).remove();
  }
}
