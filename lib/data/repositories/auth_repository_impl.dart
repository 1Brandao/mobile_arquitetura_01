import 'package:mobile_arquitetura_02/data/datasources/auth_remote_datasource.dart';
import 'package:mobile_arquitetura_02/domain/entities/user.dart';
import 'package:mobile_arquitetura_02/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<User> login(String username, String password) async {
    final model = await remote.login(username, password);
    return model.toEntity();
  }
}
