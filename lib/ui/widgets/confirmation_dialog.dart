import 'package:flutter/material.dart';

/// A utility class that provides a standardized confirmation dialog.
///
/// This class offers a static method to display an alert dialog with
/// customizable title, message, and action buttons for confirming or
/// canceling an action.
class ConfirmationDialog {
  /// Shows a confirmation dialog with customizable content and actions.
  ///
  /// Parameters:
  /// - [context]: The build context for showing the dialog
  /// - [title]: The title displayed at the top of the dialog
  /// - [message]: The main content message of the dialog
  /// - [label]: The text for the confirm button
  /// - [onPressed]: Callback function executed when confirm is pressed
  /// - [cancelLabel]: Optional text for the cancel button (defaults to 'Cancel')
  /// - [confirmColor]: Optional color for the confirm button
  ///
  /// Returns a [Future<bool>] that completes with:
  /// - `true` if the user confirms the action
  /// - `false` if the user cancels or dismisses the dialog
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