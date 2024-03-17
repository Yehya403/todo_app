import 'package:flutter/material.dart';

class DialogUtils {
  static void showLoading(BuildContext context, String message,
      {bool isCancelable = true}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Row(
              children: [
                const CircularProgressIndicator(),
                const SizedBox(
                  width: 4,
                ),
                Text(message),
              ],
            ),
          );
        },
        barrierDismissible: isCancelable);
  }

  static void hideDialog(BuildContext context) {
    Navigator.pop(context);
  }

  static void showMessage(
    BuildContext context,
    String message, {
    bool isCanceable = true,
    String? posActionTitle,
    VoidCallback? posAction,
    VoidCallback? negAction,
    String? negActionTitle,
  }) {
    List<Widget> actions = [];

    if (posActionTitle != null) {
      actions.add(TextButton(
        onPressed: () {
          Navigator.pop(context);
          posAction?.call();
        },
        child: Text(posActionTitle),
      ));
    }
    if (negActionTitle != null) {
      actions.add(TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(negActionTitle)));
    }
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: actions,
            content: Text(message),
          );
        },
        barrierDismissible: isCanceable);
  }
}
