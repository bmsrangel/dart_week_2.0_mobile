import 'package:flutter/material.dart';

import 'app/modules/auth/view/login_page.dart';
import 'app/modules/auth/view/register_page.dart';
import 'app/modules/home/view/home_page.dart';
import 'app/modules/splash/view/splash_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pizza Delivery App',
      theme: ThemeData(
        primaryColor: Color(0xFF9D0000),
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: SplashPage.router,
      routes: {
        SplashPage.router: (_) => SplashPage(),
        HomePage.router: (_) => HomePage(),
        LoginPage.router: (_) => LoginPage(),
        RegisterPage.router: (_) => RegisterPage(),
      },
    );
  }
}
