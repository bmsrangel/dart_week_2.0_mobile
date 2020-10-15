import 'package:flutter/material.dart';
import '../../../exceptions/rest_exception.dart';
import '../../../models/order_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/orders_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyOrdersController extends ChangeNotifier {
  bool loading = false;
  String error;
  List<OrderModel> orders = [];
  final OrdersRepository _repository = OrdersRepository();

  Future<void> findAll() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final SharedPreferences sp = await SharedPreferences.getInstance();
      final UserModel user = UserModel.fromJson(sp.getString("user"));
      orders = await _repository.findMyOrders(user.id);
    } on RestException catch (e) {
      error = e.message;
    } catch (e) {
      error = "Erro ao buscar meus pedidos";
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
