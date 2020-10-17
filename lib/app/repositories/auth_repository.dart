import 'package:dio/dio.dart';
import 'package:pizza_delivery_app/app/shared/utils/constants.dart'
    as constants;

import '../exceptions/rest_exception.dart';
import '../models/user_model.dart';
import '../view_models/register_input_model.dart';

class AuthRepository {
  Future<UserModel> login(String email, String password) async {
    try {
      final Response response = await Dio(BaseOptions(connectTimeout: 2000))
          .post("${constants.baseUrl}/user/auth", data: {
        "email": email,
        "password": password,
      });
      return UserModel.fromMap(response.data);
    } on DioError catch (e) {
      print(e);
      String message = "Erro ao autenticar o usuário";
      if (e?.response?.statusCode == 403) {
        message = "Usuário ou senha inválidos";
      }

      throw RestException(message);
    }
  }

  Future<void> saveUser(RegisterInputModel registerInputModel) async {
    try {
      await Dio().post("${constants.baseUrl}/user", data: {
        "name": registerInputModel.name,
        "email": registerInputModel.email,
        "password": registerInputModel.password,
      });
    } on DioError catch (e) {
      print(e);
      throw RestException("Falha ao registrar usuário");
    }
  }
}
