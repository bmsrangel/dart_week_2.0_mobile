import 'package:dio/dio.dart';
import 'package:pizza_delivery_app/app/shared/utils/constants.dart'
    as constants;

import '../exceptions/rest_exception.dart';
import '../models/order_model.dart';

class OrdersRepository {
  Future<List<OrderModel>> findMyOrders(int userId) async {
    try {
      final Response response = await Dio(BaseOptions(connectTimeout: 2000))
          .get("${constants.baseUrl}/orders/user/$userId");
      return response.data
          .map<OrderModel>(((o) => OrderModel.fromMap(o)))
          .toList();
    } on DioError catch (e) {
      print(e);
      throw RestException("Erro ao buscar pedidos");
    }
  }
}
