import 'package:flutter/material.dart';

import '../../../exceptions/rest_exception.dart';
import '../../../repositories/auth_repository.dart';
import '../../../view_models/register_input_model.dart';

class RegisterController extends ChangeNotifier {
  bool loading;
  bool registerSuccess;
  String error;
  final AuthRepository _repository = AuthRepository();

  Future<void> registerUser(String name, String email, String password) async {
    loading = true;
    registerSuccess = false;
    notifyListeners();
    final RegisterInputModel registerInputModel = RegisterInputModel(
      name: name,
      email: email,
      password: password,
    );
    try {
      await _repository.saveUser(registerInputModel);

      registerSuccess = true;
    } on RestException catch (e) {
      registerSuccess = false;
      error = e.message;
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
