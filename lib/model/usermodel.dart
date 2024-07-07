class User {
  final String username;
  final String email;
  final String password;

  User({required this.username, required this.email, required this.password});

  // Convert a User into a Map. The keys must correspond to the names of the fields.
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'password': password,
    };
  }

  // A method that retrieves a User from a Map.
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'],
      email: map['email'],
      password: map['password'],
    );
  }
}
