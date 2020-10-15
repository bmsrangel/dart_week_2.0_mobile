import 'package:flutter/material.dart';

import '../../../models/menu_model.dart';
import '../../../repositories/menu_repository.dart';

class MenuController extends ChangeNotifier {
  MenuRepository _repository = MenuRepository();
  List<MenuModel> menu = [];
  bool loading = false;
  String error;

  Future<void> findMenu() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      menu = await _repository.findAll();
    } catch (e) {
      print(e);
      error = "Erro ao buscar o cardápio";
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
