import 'dart:convert';

import 'menu_item_model.dart';

class MenuModel {
  final int id;
  final String name;
  final List<MenuItemModel> items;

  MenuModel(this.id, this.name, this.items);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'items': items?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory MenuModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return MenuModel(
      map['id'],
      map['name'],
      List<MenuItemModel>.from(
          map['items']?.map((x) => MenuItemModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory MenuModel.fromJson(String source) =>
      MenuModel.fromMap(json.decode(source));
}
