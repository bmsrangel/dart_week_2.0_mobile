import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

import '../../../shared/components/pizza_delivery_button.dart';
import '../../../shared/components/pizza_delivery_input.dart';
import '../../../shared/mixins/loader_mixin.dart';
import '../../../shared/mixins/messages_mixin.dart';
import '../../splash/view/splash_page.dart';
import '../controllers/login_controller.dart';
import 'register_page.dart';

class LoginPage extends StatelessWidget {
  static const router = "/login";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ChangeNotifierProvider(
            create: (context) => LoginController(),
            child: LoginContent(),
          ),
        ),
      ),
    );
  }
}

class LoginContent extends StatefulWidget {
  @override
  _LoginContentState createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent>
    with LoaderMixin, MessagesMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController passwordEditingController =
      TextEditingController();
  final ValueNotifier<bool> obscurePasswordValueNotifier =
      ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    final loginController = context.read<LoginController>();
    loginController.addListener(() {
      showHideLoaderHelper(context, loginController.showLoader);
      if (!isNull(loginController.error)) {
        showError(message: loginController.error, context: context);
      }
      if (loginController.loginSuccess) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(SplashPage.router, (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          "assets/images/logo.png",
          width: 250.0,
        ),
        Container(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  PizzaDeliveryInput(
                    "E-mail",
                    keyboardType: TextInputType.emailAddress,
                    controller: emailEditingController,
                    validator: (value) {
                      if (!isEmail(value?.toString() ?? "")) {
                        return "E-mail inválido";
                      } else {
                        return null;
                      }
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: obscurePasswordValueNotifier,
                    builder: (_, obscurePasswordValueNotifierValue, child) {
                      return PizzaDeliveryInput(
                        "Senha",
                        controller: passwordEditingController,
                        suffixIcon: Icon(FontAwesome.key),
                        suffixIconOnPressed: () {
                          obscurePasswordValueNotifier.value =
                              !obscurePasswordValueNotifier.value;
                        },
                        obscureText: obscurePasswordValueNotifierValue,
                        validator: (value) {
                          if (!isLength(value?.toString(), 6)) {
                            return "Senha deve conter no mínimo 6 caracteres";
                          } else {
                            return null;
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20.0),
                  PizzaDeliveryButton(
                    "LOGIN",
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        context.read<LoginController>().login(
                              emailEditingController.text,
                              passwordEditingController.text,
                            );
                      }
                    },
                    width: MediaQuery.of(context).size.width * .8,
                    height: 50,
                    labelColor: Colors.white,
                    labelSize: 18.0,
                    buttonColor: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 50.0),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(RegisterPage.router);
                    },
                    child: Text(
                      "Cadastre-se",
                      style: TextStyle(fontSize: 20.0, fontFamily: "Arial"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
