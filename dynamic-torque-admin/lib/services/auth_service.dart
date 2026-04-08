import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  AdminUser? _user;
  bool _loading = false;

  AdminUser? get user => _user;
  AdminUser? get currentAdmin => _user;
  bool get isAuthenticated => _user != null;
  bool get loading => _loading;

  Future<bool> login(String email, String password) async {
    _loading = true;
    notifyListeners();

    // Simulated auth — will be replaced with Firebase
    await Future.delayed(const Duration(milliseconds: 800));

    if (email == 'admin@dynamictorque.com' && password == 'admin123') {
      _user = const AdminUser(
        id: 'admin-1',
        email: 'admin@dynamictorque.com',
        fullName: 'Admin User',
        role: 'super_admin',
      );
      _loading = false;
      notifyListeners();
      return true;
    }

    _loading = false;
    notifyListeners();
    return false;
  }

  void logout() {
    _user = null;
    notifyListeners();
  }

  void signOut() => logout();
}
