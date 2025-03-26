class User {
  final String id;
  final String email;
  final String authProvider;
  final bool emailVerified;

  const User({
    required this.id,
    required this.email,
    required this.authProvider,
    required this.emailVerified,
  });
}
