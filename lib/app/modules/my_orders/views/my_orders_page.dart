import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

import '../../../models/order_model.dart';
import '../../../shared/mixins/loader_mixin.dart';
import '../../../shared/mixins/messages_mixin.dart';
import '../controllers/my_orders_controller.dart';

class MyOrdersPage extends StatefulWidget {
  @override
  _MyOrdersPageState createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage>
    with LoaderMixin, MessagesMixin {
  final NumberFormat formatNumberPrice =
      NumberFormat.currency(name: "R\$", decimalDigits: 2, locale: "pt_BR");
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (this.mounted) {
        context.read<MyOrdersController>().findAll();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => context.read<MyOrdersController>().findAll(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Consumer<MyOrdersController>(
            builder: (_, controller, __) {
              if (controller.loading) {
                return ListView(
                  children: [
                    Center(child: CircularProgressIndicator()),
                  ],
                );
              }
              if (!isNull(controller.error)) {
                return ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Center(
                            child: Text(
                                "Erro ao buscar os pedidos. Tente novamente mais tarde."),
                          ),
                          const SizedBox(height: 15.0),
                          RaisedButton(
                            onPressed: controller.findAll,
                            child: Text("Tentar novamente"),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return ListView.builder(
                  itemCount: controller?.orders?.length ?? 0,
                  itemBuilder: (_, index) {
                    final OrderModel order = controller.orders[index];
                    return ExpansionTile(
                      title: Text("Pedido ${order.id}"),
                      children: [
                        Divider(
                          color: Colors.grey[300],
                          thickness: 1.0,
                        ),
                        ...order.items.map<Widget>((o) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(o?.item?.name ?? ""),
                                Text(formatNumberPrice.format(o?.item?.price)),
                              ],
                            ),
                          );
                        }).toList(),
                        Divider(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total"),
                              Text(_calculateTotalOrder(order)),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }

  String _calculateTotalOrder(OrderModel order) {
    final double totalOrder = order.items.fold(
        0.0, (totalValue, orderItem) => totalValue += orderItem.item.price);
    return formatNumberPrice.format(totalOrder);
  }
}
