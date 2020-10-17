import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

import '../../../models/menu_item_model.dart';
import '../../home/controllers/home_controller.dart';
import '../../shopping_cart/controllers/shopping_cart_controller.dart';
import '../controllers/menu_controller.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              _buildMenu(context),
            ],
          ),
        ),
      ),
      floatingActionButton: Consumer<ShoppingCartController>(
        builder: (_, controller, __) {
          if (controller.hasItemsSelected) {
            return FloatingActionButton.extended(
              onPressed: () {
                context.read<HomeController>().changeTab(2);
              },
              label: Text("Finalizar Pedido"),
              icon: Icon(Icons.monetization_on),
              backgroundColor: Theme.of(context).primaryColor,
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 350.0,
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 300.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/topoCardapio.png"),
                    fit: BoxFit.none,
                  ),
                ),
              ),
              Positioned(
                bottom: 0.0,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  height: 200.0,
                  child: Image.asset("assets/images/logo.png"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenu(BuildContext context) {
    return Consumer<MenuController>(
      builder: (_, controller, __) {
        if (controller.loading) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (!isNull(controller.error)) {
          return Text(controller.error);
        } else {
          var menu = controller.menu;
          return Column(
            children: [
              ...menu.map<Widget>((m) {
                return _buildGroup(context, m.name, m.items);
              }).toList(),
              const SizedBox(height: 60.0),
            ],
          );
        }
      },
    );
  }

  Widget _buildGroup(
      BuildContext context, String name, List<MenuItemModel> items) {
    var formatter = NumberFormat("###.00", "pt_BR");
    return Column(
      children: [
        const SizedBox(height: 10.0),
        Container(
          padding: const EdgeInsets.all(10.0),
          width: MediaQuery.of(context).size.width,
          child: Text(
            name,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Divider(),
        ListView.builder(
          itemCount: items.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (_, index) {
            var menuItem = items[index];
            return ListTile(
              title: Text(
                menuItem.name,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text("R\$ ${formatter.format(menuItem.price)}"),
              trailing: Consumer<ShoppingCartController>(
                builder: (_, controllerShoppingCart, __) {
                  final bool isItemSelected =
                      controllerShoppingCart.isItemSelected(menuItem);
                  return IconButton(
                    icon: Icon(isItemSelected
                        ? FontAwesome.minus_square
                        : FontAwesome.plus_square),
                    color: Theme.of(context).primaryColor,
                    iconSize: 20.0,
                    onPressed: () =>
                        controllerShoppingCart.addOrRemoveItem(menuItem),
                  );
                },
              ),
            );
          },
        )
      ],
    );
  }
}
