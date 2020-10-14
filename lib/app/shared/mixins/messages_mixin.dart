import 'package:flutter/material.dart';

abstract class MessagesMixin {
  final GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();

  showError({
    @required String message,
    BuildContext context,
    GlobalKey<ScaffoldState> key,
  }) =>
      _showSnackbar(
          message: message, context: context, key: key, color: Colors.red);
  showSuccess({
    @required String message,
    BuildContext context,
    GlobalKey<ScaffoldState> key,
  }) =>
      _showSnackbar(
          message: message,
          context: context,
          key: key,
          color: Theme.of(context).primaryColor);

  void _showSnackbar({
    String message,
    BuildContext context,
    GlobalKey<ScaffoldState> key,
    Color color,
  }) {
    final SnackBar snackbar =
        SnackBar(backgroundColor: color, content: Text(message));
    if (key != null) {
      key.currentState.showSnackBar(snackbar);
    } else {
      Scaffold.of(context).showSnackBar(snackbar);
    }
  }
}
