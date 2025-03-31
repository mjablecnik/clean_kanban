import 'package:flutter/material.dart';

class ConfirmationDialog {
  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String message,
    required String label,
    required VoidCallback onPressed,
    String cancelLabel = 'Cancel',
    Color? confirmColor,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            child: Text(cancelLabel),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: confirmColor ?? Colors.red[400],
            ),
            child: Text(label),
            onPressed: () {
              onPressed();
              Navigator.of(context).pop(true);
            },
          ),
        ],
      ),
    ).then((value) => value ?? false);
  }
}