class User {
  final String email;
  final String firstName;
  final String lastName;

  User({
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  // Converte o JSON recebido em um objeto User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
    );
  }
}
