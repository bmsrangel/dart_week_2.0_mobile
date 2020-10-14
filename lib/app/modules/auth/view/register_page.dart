import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

import '../../../shared/components/pizza_delivery_button.dart';
import '../../../shared/components/pizza_delivery_input.dart';
import '../../../shared/mixins/loader_mixin.dart';
import '../../../shared/mixins/messages_mixin.dart';
import '../controllers/register_controller.dart';

class RegisterPage extends StatelessWidget {
  static const router = "/register";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ChangeNotifierProvider(
            create: (context) => RegisterController(),
            child: RegisterContent(),
          ),
        ),
      ),
    );
  }
}

class RegisterContent extends StatefulWidget {
  @override
  _RegisterContentState createState() => _RegisterContentState();
}

class _RegisterContentState extends State<RegisterContent>
    with LoaderMixin, MessagesMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> obscureTextPassword = ValueNotifier<bool>(true);
  final ValueNotifier<bool> obscureTextConfirmPassword =
      ValueNotifier<bool>(true);
  final TextEditingController nameEditingController = TextEditingController();
  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController passwordEditingController =
      TextEditingController();
  final TextEditingController confirmPasswordEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    final RegisterController controller = context.read<RegisterController>();
    controller.addListener(() {
      showHideLoaderHelper(context, controller.loading);
      if (!isNull(controller.error)) {
        showError(message: controller.error, context: context);
      }
      if (controller.registerSuccess) {
        showSuccess(
            message: "Usuário cadastrado com sucesso!", context: context);
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pop();
        });
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Cadastre-se",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  PizzaDeliveryInput(
                    "Nome",
                    controller: nameEditingController,
                    validator: (value) {
                      if (value == null || value.toString().isEmpty) {
                        return "Nome obrigatório";
                      } else {
                        return null;
                      }
                    },
                  ),
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
                    valueListenable: obscureTextPassword,
                    builder: (_, obscureTextPasswordValue, child) {
                      return PizzaDeliveryInput(
                        "Senha",
                        controller: passwordEditingController,
                        obscureText: obscureTextPasswordValue,
                        suffixIcon: Icon(FontAwesome.key),
                        suffixIconOnPressed: () {
                          obscureTextPassword.value =
                              !obscureTextPassword.value;
                        },
                        validator: (value) {
                          if (!isLength(value.toString(), 6)) {
                            return "Senha precisa ter pelo menos 6 caracteres";
                          } else {
                            return null;
                          }
                        },
                      );
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: obscureTextConfirmPassword,
                    builder: (_, obscureTextConfirmPasswordValue, child) {
                      return PizzaDeliveryInput(
                        "Confirmar senha",
                        controller: confirmPasswordEditingController,
                        obscureText: obscureTextConfirmPasswordValue,
                        suffixIcon: Icon(FontAwesome.key),
                        suffixIconOnPressed: () {
                          obscureTextConfirmPassword.value =
                              !obscureTextConfirmPassword.value;
                        },
                        validator: (value) {
                          if (value.toString().isEmpty) {
                            return "Confirmação da senha é obrigatória";
                          } else if (passwordEditingController.text !=
                              value.toString()) {
                            return "As senhas não conferem";
                          } else {
                            return null;
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20.0),
                  PizzaDeliveryButton(
                    "Salvar",
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        context.read<RegisterController>().registerUser(
                              nameEditingController.text,
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
                  const SizedBox(height: 10.0),
                  PizzaDeliveryButton(
                    "Voltar",
                    width: MediaQuery.of(context).size.width * .8,
                    height: 50,
                    labelColor: Colors.black,
                    labelSize: 18.0,
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
