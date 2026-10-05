enum UserRole { volunteer, ngo, admin }

extension UserRoleLabel on UserRole {
  String get label {
    switch (this) {
      case UserRole.volunteer:
        return 'Volunteer';
      case UserRole.ngo:
        return 'NGO';
      case UserRole.admin:
        return 'Admin';
    }
  }


  static UserRole fromString(String value) {
    switch (value.toLowerCase()) {
      case 'ngo':
        return UserRole.ngo;
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.volunteer;
    }
  }
}

class AppUser {
  final String uid;
  final String name;
  final String email;
  final UserRole role;
  final String? photoUrl;
  final DateTime? createdAt;

  const AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    this.photoUrl,
    this.createdAt,
  });

  factory AppUser.fromMap(String uid, Map<String, dynamic> data) {
    return AppUser(
      uid: uid,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: UserRoleLabel.fromString(data['role'] ?? ''),
      photoUrl: data['photoUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role.name,
      'photoUrl': photoUrl,
    };
  }

  AppUser copyWith({
    String? name,
    String? email,
    UserRole? role,
    String? photoUrl,
  }) {
    return AppUser(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt,
    );
  }
}