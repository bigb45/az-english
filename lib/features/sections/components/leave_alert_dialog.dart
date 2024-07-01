import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Widget leavePracticeAlertDialog(
    {required Function onConfirm,
    required Function onCancel,
    final String? title,
    final String? body}) {
  return AlertDialog(
    title: Text(title ?? "Leave Practice?"),
    content: Text(
      body ??
          "Are you sure you want to leave the practice? Your progress will not be saved.",
    ),
    actions: [
      TextButton(
        onPressed: () {
          onConfirm();
        },
        child: const Text(
          "Confirm",
        ),
      ),
      TextButton(
        onPressed: () {
          onCancel();
        },
        child: const Text(
          "Cancel",
        ),
      ),
    ],
  );
}

void showAlertDialog(BuildContext context,
    {Future<void> Function()? onConfirm,
    Function? onCancel,
    String? title,
    String? body}) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return leavePracticeAlertDialog(
        onConfirm: onConfirm != null
            ? () {
                onConfirm();

                Navigator.pop(dialogContext);
                context.go('/');
              }
            : () {
                Navigator.pop(dialogContext);
                // this pops the whole stack and navigates back to the home screen
                context.go('/');
              },
        onCancel: onCancel ??
            () {
              // only pop the dialog
              Navigator.pop(dialogContext);
            },
        body: body,
        title: title,
      );
    },
  );
}
