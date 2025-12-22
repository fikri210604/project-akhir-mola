class AppUser {
  final String id;
  final String email;
  final String name;
  final String? photoUrl;
  final String? phoneNumber;

  AppUser({
    required this.id,
    required this.email,
    required this.name,
    this.photoUrl,
    this.phoneNumber,
  });

  factory AppUser.fromMap(Map<String, dynamic> data, String uid) {
    return AppUser(
      id: uid,
      email: data['email'] ?? '',
      name: data['name'] ?? data['displayName'] ?? 'User', 
      photoUrl: data['photoUrl'] ?? data['photo_url'],
      phoneNumber: data['phoneNumber'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
    };
  }
}