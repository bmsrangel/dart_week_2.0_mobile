import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../menu/controllers/menu_controller.dart';
import '../../menu/views/menu_page.dart';
import '../../my_orders/controllers/my_orders_controller.dart';
import '../../my_orders/views/my_orders_page.dart';
import '../../shopping_cart/controllers/shopping_cart_controller.dart';
import '../../shopping_cart/views/shopping_cart_page.dart';
import '../../splash/view/splash_page.dart';
import '../controllers/home_controller.dart';

class HomePage extends StatelessWidget {
  static const router = "/home";
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeController(),
      child: HomeContent(),
    );
  }
}

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent>
    with SingleTickerProviderStateMixin {
  HomeController controller;
  final _titles = [
    "Cardápio",
    "Meus Pedidos",
    "Carrinho de compras",
    "Configurações",
  ];
  ValueNotifier<int> currentIndex = ValueNotifier<int>(0);

  @override
  void initState() {
    controller = context.read<HomeController>();
    controller.tabController = TabController(
      vsync: this,
      length: 4,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: ValueListenableBuilder(
          valueListenable: currentIndex,
          builder: (_, currentIndexValue, child) {
            return Text(_titles[currentIndexValue]);
          },
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: controller.bottomNavigationKey,
        backgroundColor: backgroundColor,
        buttonBackgroundColor: backgroundColor,
        color: Theme.of(context).primaryColor,
        height: 60.0,
        items: <Widget>[
          Image.asset(
            "assets/images/logo.png",
            width: 30.0,
          ),
          ValueListenableBuilder(
            valueListenable: currentIndex,
            builder: (_, currentIndexValue, child) {
              return Icon(
                FontAwesome.list,
                color: currentIndexValue == 1
                    ? Theme.of(context).primaryColor
                    : Colors.white,
              );
            },
          ),
          ValueListenableBuilder(
            valueListenable: currentIndex,
            builder: (_, currentIndexValue, child) {
              return Icon(
                Icons.shopping_cart,
                color: currentIndexValue == 2
                    ? Theme.of(context).primaryColor
                    : Colors.white,
              );
            },
          ),
          ValueListenableBuilder(
            valueListenable: currentIndex,
            builder: (_, currentIndexValue, child) {
              return Icon(
                Icons.menu,
                color: currentIndexValue == 3
                    ? Theme.of(context).primaryColor
                    : Colors.white,
              );
            },
          ),
        ],
        onTap: (index) {
          controller.tabController
              .animateTo(index, duration: Duration(milliseconds: 600));
          currentIndex.value = index;
        },
      ),
      body: SafeArea(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => MenuController()..findMenu(),
            ),
            ChangeNotifierProvider(
              create: (context) => MyOrdersController(),
            ),
            ChangeNotifierProvider(
              create: (context) => ShoppingCartController(),
            ),
          ],
          child: TabBarView(
            controller: controller.tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              MenuPage(),
              MyOrdersPage(),
              ShoppingCartPage(),
              FlatButton(
                onPressed: () async {
                  final SharedPreferences sp =
                      await SharedPreferences.getInstance();
                  sp.clear();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      SplashPage.router, (route) => false);
                },
                child: Text("Sair", style: TextStyle(fontSize: 20.0)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
