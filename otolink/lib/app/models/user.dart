class AppUser {
  final String id;
  final String displayName;
  final String? photoUrl;
  final String? email;

  const AppUser({
    required this.id,
    required this.displayName,
    this.photoUrl,
    this.email,
  });
}