import 'package:dio/dio.dart';

import '../exceptions/rest_exception.dart';
import '../models/menu_model.dart';
import '../shared/utils/constants.dart' as constants;

class MenuRepository {
  Future<List<MenuModel>> findAll() async {
    try {
      final Response response = await Dio(BaseOptions(connectTimeout: 2000))
          .get("${constants.baseUrl}/menu");
      return response.data.map<MenuModel>((m) => MenuModel.fromMap(m)).toList();
    } on DioError catch (e) {
      print(e);
      throw RestException("Erro ao buscar cardápio");
    }
  }
}
