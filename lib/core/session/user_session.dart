import 'package:flutter/foundation.dart';
import 'package:mobile_arquitetura_02/domain/entities/user.dart';

class UserSession extends ChangeNotifier {
  User? _user;

  User? get user => _user;
  bool get isLoggedIn => _user != null;

  void login(User user) {
    _user = user;
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
