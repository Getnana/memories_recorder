
import '../models/memory.dart';

/// Service sederhana untuk mengelola data Memory.
/// Saat ini masih in-memory (belum pakai database / backend),
/// tapi strukturnya disiapkan supaya nanti mudah diganti ke API / lokal storage.
class MemoryService {
  MemoryService._internal() {
    _seedDummyData();
  }

  static final MemoryService _instance = MemoryService._internal();

  /// Cara akses:
  /// final service = MemoryService();
  factory MemoryService() => _instance;

  final List<Memory> _memories = [];

  /// Dummy data awal untuk kebutuhan UI / prototyping.
  void _seedDummyData() {
    if (_memories.isNotEmpty) return;

    for (var i = 1; i <= 6; i++) {
      _memories.add(
        Memory.sample(index: i, isDraft: false),
      );
    }

    for (var i = 1; i <= 3; i++) {
      _memories.add(
        Memory.sample(index: 100 + i, isDraft: true),
      );
    }
  }

  /// Mengambil semua memori.
  /// [includeDrafts] = false jika hanya ingin yang sudah publish.
  List<Memory> getAll({bool includeDrafts = true}) {
    if (includeDrafts) {
      return List.unmodifiable(
        _memories
          ..sort((a, b) => b.date.compareTo(a.date)),
      );
    }
    return List.unmodifiable(
      _memories
          .where((m) => !m.isDraft)
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date)),
    );
  }

  /// Mengambil semua memori yang sudah publish.
  List<Memory> getPublished() {
    return getAll(includeDrafts: false);
  }

  /// Mengambil semua draft.
  List<Memory> getDrafts() {
    return List.unmodifiable(
      _memories
          .where((m) => m.isDraft)
          .toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt)),
    );
  }

  /// Mencari memori berdasarkan id.
  Memory? getById(String id) {
    try {
      return _memories.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Membuat id sederhana berbasis waktu.
  String _generateId() {
    return 'mem_${DateTime.now().microsecondsSinceEpoch}';
  }

  /// Membuat memori baru.
  Future<Memory> createMemory({
    required String title,
    required String content,
    required DateTime date,
    bool isDraft = false,
    String? aiSuggestion,
  }) async {
    final now = DateTime.now();

    final memory = Memory(
      id: _generateId(),
      title: title,
      content: content,
      date: date,
      createdAt: now,
      updatedAt: now,
      isDraft: isDraft,
      aiSuggestion: aiSuggestion,
    );

    _memories.add(memory);
    return memory;
  }

  /// Memperbarui memori yang sudah ada.
  Future<Memory?> updateMemory(
    String id, {
    String? title,
    String? content,
    DateTime? date,
    bool? isDraft,
    String? aiSuggestion,
  }) async {
    final index = _memories.indexWhere((m) => m.id == id);
    if (index == -1) return null;

    final existing = _memories[index];
    final updated = existing.copyWith(
      title: title,
      content: content,
      date: date,
      isDraft: isDraft,
      aiSuggestion: aiSuggestion,
      updatedAt: DateTime.now(),
    );

    _memories[index] = updated;
    return updated;
  }

  /// Menghapus memori berdasarkan id.
  Future<bool> deleteMemory(String id) async {
    final index = _memories.indexWhere((m) => m.id == id);
    if (index == -1) return false;
    _memories.removeAt(index);
    return true;
  }

  /// Menghapus semua memori (hati-hati, biasanya hanya dipakai untuk debugging).
  Future<void> clearAll() async {
    _memories.clear();
  }
}
