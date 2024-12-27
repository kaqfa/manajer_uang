class User {
  int id;
  String username;
  String firstname;
  String lastname;

  User({
    required this.id,
    required this.username,
    required this.firstname,
    required this.lastname,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      firstname: json['first_name'] as String,
      lastname: json['last_name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'first_name': firstname,
      'last_name': lastname,
    };
  }
}
