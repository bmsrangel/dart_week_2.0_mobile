import 'dart:convert';

import 'order_item_model.dart';

class OrderModel {
  final int id;
  final String paymentType;
  final String address;
  final List<OrderItemModel> items;

  OrderModel({
    this.id,
    this.paymentType,
    this.address,
    this.items,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'paymentType': paymentType,
      'address': address,
      'items': items?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return OrderModel(
      id: map['id'],
      paymentType: map['paymentType'],
      address: map['address'],
      items: List<OrderItemModel>.from(
          map['items']?.map((x) => OrderItemModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source));
}
