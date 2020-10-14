import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../exceptions/rest_exception.dart';
import '../../../repositories/auth_repository.dart';

class LoginController extends ChangeNotifier {
  bool showLoader;
  String error;
  bool loginSuccess;
  final AuthRepository _authRepository = AuthRepository();

  Future<void> login(String email, String password) async {
    showLoader = true;
    error = null;
    loginSuccess = false;
    notifyListeners();
    try {
      final user = await _authRepository.login(email, password);
      final sp = await SharedPreferences.getInstance();
      sp.setString('user', user.toJson());
      showLoader = false;
      loginSuccess = true;
    } on RestException catch (e) {
      error = e.message;
      showLoader = false;
    } catch (e) {
      error = "Erro ao autenticar o usuário";
      showLoader = false;
    } finally {
      notifyListeners();
    }
  }
}
