import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

import '../../../models/menu_item_model.dart';
import '../../../shared/components/pizza_delivery_button.dart';
import '../../../shared/components/shopping_cart_item.dart';
import '../../../shared/mixins/loader_mixin.dart';
import '../../../shared/mixins/messages_mixin.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/shopping_cart_controller.dart';

class ShoppingCartPage extends StatefulWidget {
  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage>
    with LoaderMixin, MessagesMixin {
  final NumberFormat numberFormat =
      NumberFormat.currency(name: "R\$", locale: "pt_BR", decimalDigits: 2);

  final ValueNotifier<String> paymentTypeSelected = ValueNotifier<String>("");

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final ShoppingCartController controller =
          context.read<ShoppingCartController>();
      controller.loadPage();
      controller.addListener(() async {
        if (this.mounted) {
          showHideLoaderHelper(context, controller.loading);
          if (!isNull(controller.error)) {
            showError(message: controller.error, context: context);
          }

          if (controller.success) {
            showSuccess(
                message: "Pedido realizado com sucesso!", context: context);
            Future.delayed(Duration(seconds: 1), () {
              controller.clearShoppingCart();
              context.read<HomeController>().changeTab(1);
            });
          }
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ShoppingCartController>(
        builder: (_, controller, __) {
          return !controller.hasItemsSelected
              ? _buildClearShoppingCart(context)
              : SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height - 140.0,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        ListTile(
                          title: Text("Nome"),
                          subtitle: Text(controller?.user?.name ?? ""),
                        ),
                        const Divider(),
                        _buildShoppingCartItems(context, controller),
                        const Divider(),
                        ListTile(
                          title: Text("Endereço de entrega"),
                          subtitle: Text(controller.address ?? ""),
                          trailing: FlatButton(
                            child: Text(
                              "Alterar",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            onPressed: () =>
                                _changeAddress(context, controller),
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          title: Text("Tipo de Pagamento"),
                          subtitle: Text(controller.paymentType),
                          trailing: FlatButton(
                            child: Text(
                              "Alterar",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            onPressed: () =>
                                _changePaymentType(context, controller),
                          ),
                        ),
                        const Divider(),
                        Expanded(child: Container()),
                        PizzaDeliveryButton(
                          "Finalizar pedido",
                          width: MediaQuery.of(context).size.width * .9,
                          height: 50.0,
                          buttonColor: Theme.of(context).primaryColor,
                          labelSize: 18.0,
                          labelColor: Colors.white,
                          onPressed: () => controller.checkout(),
                        ),
                        const SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }

  Widget _buildShoppingCartItems(
      BuildContext context, ShoppingCartController controller) {
    final List<MenuItemModel> items = controller.itemsSelected.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Text(
            "Pedido",
            style: TextStyle(fontSize: 16.0),
          ),
        ),
        const SizedBox(height: 10.0),
        ...items.map<ShoppingCartItem>((i) => ShoppingCartItem(i)).toList(),
        const Divider(),
        const SizedBox(height: 10.0),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total"),
              Text(numberFormat.format(controller.totalPrice)),
            ],
          ),
        ),
        FlatButton(
          child: Text(
            "Limpar carrinho",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
          onPressed: () {
            controller.clearShoppingCart();
          },
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildClearShoppingCart(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(
            AntDesign.shoppingcart,
            size: 200.0,
          ),
          Text("Seu carrinho está vazio"),
        ],
      ),
    );
  }

  void _changeAddress(BuildContext context, ShoppingCartController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Endereço de entrega"),
          content: TextField(
            controller: controller.addressEditingController,
          ),
          actions: [
            RaisedButton(
              child: Text("Cancelar"),
              onPressed: () => Navigator.pop(context),
            ),
            RaisedButton(
              child: Text("Alterar"),
              onPressed: () {
                controller
                    .changeAddress(controller.addressEditingController.text);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _changePaymentType(
      BuildContext context, ShoppingCartController controller) {
    showDialog(
      context: context,
      builder: (context) {
        paymentTypeSelected.value = controller.paymentType;

        return AlertDialog(
          title: Text("Tipo de Pagamento"),
          content: Container(
            height: 150.0,
            child: ValueListenableBuilder(
              valueListenable: paymentTypeSelected,
              builder: (_, paymentTypeSelectedValue, child) {
                return RadioButtonGroup(
                  labels: [
                    "Cartão de Crédito",
                    "Cartão de Débito",
                    "Dinheiro",
                  ],
                  onSelected: (selected) {
                    paymentTypeSelected.value = selected;
                  },
                  picked: paymentTypeSelectedValue,
                );
              },
            ),
          ),
          actions: [
            RaisedButton(
              child: Text("Cancelar"),
              onPressed: () => Navigator.pop(context),
            ),
            RaisedButton(
              child: Text("Alterar"),
              onPressed: () {
                controller.changePaymentType(paymentTypeSelected.value);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
