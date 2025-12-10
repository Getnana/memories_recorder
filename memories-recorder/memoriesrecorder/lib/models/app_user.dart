class AppUser {
  final String id;
  final String username;
  final String email;
  final String password; // untuk auth lokal (tidak dipakai di Firebase)
  final DateTime createdAt;
  final bool isDarkMode;

  const AppUser({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.createdAt,
    this.isDarkMode = false,
  });

  AppUser copyWith({
    String? id,
    String? username,
    String? email,
    String? password,
    DateTime? createdAt,
    bool? isDarkMode,
  }) {
    return AppUser(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'createdAt': createdAt.toIso8601String(),
      'isDarkMode': isDarkMode,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    final createdRaw = map['createdAt'];

    DateTime createdAt;
    if (createdRaw is String) {
      createdAt = DateTime.tryParse(createdRaw) ?? DateTime.now();
    } else if (createdRaw is DateTime) {
      createdAt = createdRaw;
    } else {
      // kalau null / tipe lain
      createdAt = DateTime.now();
    }

    return AppUser(
      id: (map['id'] ?? '') as String,
      username: (map['username'] ?? '') as String,
      email: (map['email'] ?? '') as String,
      password: (map['password'] ?? '') as String,
      isDarkMode: (map['isDarkMode'] as bool?) ?? false,
      createdAt: createdAt,
    );
  }

  @override
  String toString() =>
      'AppUser(id: $id, email: $email, isDarkMode: $isDarkMode)';
}
