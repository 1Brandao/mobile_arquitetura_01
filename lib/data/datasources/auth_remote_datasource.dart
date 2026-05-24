import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile_arquitetura_02/data/models/user_model.dart';

class AuthRemoteDatasource {
  final http.Client client;
  static const _baseUrl = 'https://dummyjson.com';

  AuthRemoteDatasource(this.client);

  Future<UserModel> login(String username, String password) async {
    final response = await client.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 400 || response.statusCode == 401) {
      throw Exception('Credenciais inválidas');
    }

    if (response.statusCode != 200) {
      throw Exception('Erro ao fazer login: ${response.statusCode}');
    }

    final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return UserModel.fromJson(data);
  }
}
