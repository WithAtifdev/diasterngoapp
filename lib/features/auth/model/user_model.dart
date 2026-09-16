class UserModel {
  final String uid;
  final String email;

  UserModel({
    required this.uid,
    required this.email,
  });


  factory UserModel.fromFirebase(dynamic user) {
    return UserModel(
      uid: user.uid ?? '',
      email: user.email ?? '',
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
    );
  }
}