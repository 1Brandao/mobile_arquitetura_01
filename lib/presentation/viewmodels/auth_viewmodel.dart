import 'package:flutter/foundation.dart';
import 'package:mobile_arquitetura_02/core/session/user_session.dart';
import 'package:mobile_arquitetura_02/domain/repositories/auth_repository.dart';

class AuthViewmodel extends ChangeNotifier {
  final AuthRepository repository;
  final UserSession session;

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  AuthViewmodel(this.repository, this.session);

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await repository.login(username, password);
      session.login(user);
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    session.logout();
  }
}
