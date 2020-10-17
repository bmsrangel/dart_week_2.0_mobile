import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pizza_delivery_app/app/models/menu_item_model.dart';

class ShoppingCartItem extends StatelessWidget {
  ShoppingCartItem(
    this.item, {
    Key key,
  }) : super(key: key);

  final MenuItemModel item;
  final NumberFormat numberFormat =
      NumberFormat.currency(name: "R\$", locale: "pt_BR", decimalDigits: 2);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(item.name ?? ""),
          Text(numberFormat.format(item.price ?? 0.00)),
        ],
      ),
    );
  }
}
