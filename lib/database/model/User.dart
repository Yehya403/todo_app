class User {
  static const String collectionName = 'users';
  String? id;
  String? fullName;
  String? email;
  String? username;

  User(
      {required this.id,
      required this.fullName,
      required this.email,
      required this.username});

  User.fromFireStore(Map<String, dynamic>? data)
      : this(
          id: data?['id'],
          fullName: data?['fullName'],
          email: data?['email'],
          username: data?['username'],
        );

  Map<String, dynamic> toFireStore() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'username': username,
    };
  }
}
