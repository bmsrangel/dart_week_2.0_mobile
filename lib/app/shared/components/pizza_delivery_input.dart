import 'package:flutter/material.dart';

class PizzaDeliveryInput extends TextFormField {
  PizzaDeliveryInput(
    label, {
    TextInputType keyboardType,
    FormFieldValidator validator,
    TextEditingController controller,
    Icon suffixIcon,
    Function suffixIconOnPressed,
    bool obscureText = false,
  }) : super(
          keyboardType: keyboardType,
          validator: validator,
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            labelText: label,
            suffixIcon: suffixIcon != null
                ? IconButton(icon: suffixIcon, onPressed: suffixIconOnPressed)
                : null,
          ),
        );
}
