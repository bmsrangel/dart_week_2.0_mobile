import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/menu_item_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/orders_repository.dart';
import '../../../view_models/checkout_input_model.dart';

class ShoppingCartController extends ChangeNotifier {
  UserModel user;
  Set<MenuItemModel> itemsSelected = {};
  String _address = "";
  String _paymentType = "";
  String _error = "";
  bool _success = false;
  bool _loading = false;

  final TextEditingController addressEditingController =
      TextEditingController();
  final OrdersRepository _repository = OrdersRepository();

  String get paymentType => _paymentType;
  String get address => _address;
  String get error => _error;
  bool get success => _success;
  bool get loading => _loading;

  Future<void> loadPage() async {
    _error = null;
    _success = false;
    _loading = true;
    notifyListeners();
    final SharedPreferences sp = await SharedPreferences.getInstance();
    user = UserModel.fromJson(sp.getString("user"));
    _loading = false;
    notifyListeners();
  }

  bool isItemSelected(MenuItemModel item) {
    return itemsSelected.contains(item);
  }

  bool get hasItemsSelected => itemsSelected.length > 0;

  double get totalPrice =>
      itemsSelected.fold(0.0, (total, item) => total += item.price);

  void addOrRemoveItem(MenuItemModel item) {
    if (isItemSelected(item)) {
      _removeFromShoppingCart(item);
    } else {
      _addToShoppingCart(item);
    }
  }

  void _addToShoppingCart(MenuItemModel item) {
    itemsSelected.add(item);
    notifyListeners();
  }

  void _removeFromShoppingCart(MenuItemModel item) {
    itemsSelected.remove(item);
    notifyListeners();
  }

  void clearShoppingCart() {
    itemsSelected.clear();
    _address = "";
    _paymentType = "";
    _loading = false;
    _error = null;
    _success = false;
    notifyListeners();
  }

  void changeAddress(String newAddress) {
    _error = null;
    _address = newAddress;
    notifyListeners();
  }

  void changePaymentType(String newPaymentType) {
    _error = null;
    _paymentType = newPaymentType;
    notifyListeners();
  }

  Future<void> checkout() async {
    _error = null;
    _success = false;
    if (_address.isEmpty) {
      _error = "Endereço de entrega obrigatório";
      notifyListeners();
    } else if (_paymentType.isEmpty) {
      _error = "Tipo de pagamento obrigatório";
      notifyListeners();
    } else {
      String paymentTypeBackend;
      switch (paymentType) {
        case "Cartão de Crédito":
          paymentTypeBackend = "crédito";
          break;
        case "Cartão de Débito":
          paymentTypeBackend = "débito";
          break;
        case "Dinheiro":
          paymentTypeBackend = "dinheiro";
          break;
      }

      _loading = true;
      notifyListeners();
      try {
        await _repository.checkout(CheckoutInputModel(
          userId: user.id,
          address: address,
          paymentType: paymentTypeBackend,
          itemsId: itemsSelected.map((i) => i.id).toList(),
        ));
        _success = true;
        addressEditingController.clear();
      } on Exception catch (_) {
        _error = "Erro ao registrar pedido";
      } finally {
        _loading = false;
        notifyListeners();
      }
    }
  }
}
