
/// Model inti untuk satu catatan / memori.
/// Nanti bisa dipakai di Home list, Draft, Detail, AI, dsb.
class Memory {
  final String id;               // Bisa UUID / id dari backend
  final String title;            // Judul singkat
  final String content;          // Isi lengkap memori
  final DateTime date;           // Tanggal kejadian memori
  final DateTime createdAt;      // Waktu dibuat
  final DateTime updatedAt;      // Waktu terakhir diubah
  final bool isDraft;            // True jika masih draft
  final String? aiSuggestion;    // Ringkasan / saran dari AI (opsional)

  const Memory({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    this.isDraft = false,
    this.aiSuggestion,
  });

  /// Factory contoh untuk keperluan dummy / prototyping UI.
  factory Memory.sample({
    required int index,
    bool isDraft = false,
  }) {
    final now = DateTime.now();
    final date = now.subtract(Duration(days: index));

    return Memory(
      id: 'memory_$index',
      title: 'My Memory Title #$index',
      content:
          'This is a sample memory content for item #$index. You can replace this with real data from your storage or backend service.',
      date: date,
      createdAt: date,
      updatedAt: date,
      isDraft: isDraft,
      aiSuggestion: null,
    );
  }

  /// Membuat salinan dengan beberapa field diubah.
  Memory copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? date,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDraft,
    String? aiSuggestion,
  }) {
    return Memory(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDraft: isDraft ?? this.isDraft,
      aiSuggestion: aiSuggestion ?? this.aiSuggestion,
    );
  }

  /// Konversi ke Map (berguna untuk local storage / API).
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isDraft': isDraft,
      'aiSuggestion': aiSuggestion,
    };
  }

  /// Membuat Memory dari Map.
  factory Memory.fromMap(Map<String, dynamic> map) {
    return Memory(
      id: map['id'] as String,
      title: map['title'] as String? ?? '',
      content: map['content'] as String? ?? '',
      date: DateTime.parse(map['date'] as String),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      isDraft: map['isDraft'] as bool? ?? false,
      aiSuggestion: map['aiSuggestion'] as String?,
    );
  }

  /// Konversi ke JSON sederhana (String).
  String toJson() {
    return toMap().toString(); // nanti bisa diganti dengan jsonEncode
  }

  /// Equality & hashCode biar enak dipakai di list / state management.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Memory &&
        other.id == id &&
        other.title == title &&
        other.content == content &&
        other.date == date &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.isDraft == isDraft &&
        other.aiSuggestion == aiSuggestion;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      title,
      content,
      date,
      createdAt,
      updatedAt,
      isDraft,
      aiSuggestion,
    );
  }

  @override
  String toString() {
    return 'Memory(id: $id, title: $title, isDraft: $isDraft)';
  }
}
