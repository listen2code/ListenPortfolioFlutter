/// User entity - represents a user in the domain layer
/// This is a pure business object with no dependencies on external frameworks
class User {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String? bio;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.bio,
    required this.createdAt,
  });
}
