import 'package:mobile_arquitetura_02/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String username, String password);
}
