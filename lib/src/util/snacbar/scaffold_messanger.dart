import 'package:flutter/material.dart';

class ScaffoldMessengerUtil {
  static void showSnackBar(
      BuildContext context,
      String message, {
        Duration duration = const Duration(seconds: 3),
        Color backgroundColor = Colors.black87,
        TextStyle textStyle =
        const TextStyle(color: Colors.white),
      }) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    scaffoldMessenger.hideCurrentSnackBar();
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: textStyle,
        ),
        duration: duration,
        backgroundColor: backgroundColor,
      ),
    );
  }


  static void showErrorSnackBar(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 3)}) {
    showSnackBar(
      context,
      message,
      duration: duration,
      backgroundColor: Theme.of(context).colorScheme.error,
      textStyle: const TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold),
    );
  }
  static void showLoadingSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Text(message),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static void showSuccessSnackBar(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 3)}) {
    showSnackBar(
      context,
      message,
      duration: duration,
      backgroundColor: Colors.green,
      textStyle: const TextStyle(color: Colors.white),
    );
  }
}