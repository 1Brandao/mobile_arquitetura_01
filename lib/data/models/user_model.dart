import 'package:mobile_arquitetura_02/domain/entities/user.dart';

class UserModel {
  final int id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String token;

  UserModel({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      token: json['accessToken'] ?? '',
    );
  }

  User toEntity() => User(
        id: id,
        username: username,
        firstName: firstName,
        lastName: lastName,
        email: email,
        token: token,
      );
}
