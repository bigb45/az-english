import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Widget leavePracticeAlertDialog(
    {required Function onConfirm, required Function onCancel}) {
  return AlertDialog(
    title: const Text("Leave Practice?"),
    content: const Text(
        "Are you sure you want to leave the practice? Your progress will not be saved."),
    actions: [
      TextButton(
        onPressed: () {
          print("Leave practice");
          onConfirm();
        },
        child: const Text(
          "Confirm",
        ),
      ),
      TextButton(
        onPressed: () {
          print("Stay");
          onCancel();
        },
        child: const Text(
          "Cancel",
        ),
      ),
    ],
  );
}

void showLeaveAlertDialog(BuildContext context,
    {Function? onConfirm, Function? onCancel}) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return leavePracticeAlertDialog(
          onConfirm: onConfirm ??
              () {
                Navigator.pop(dialogContext);
                // this pops the whole stack and navigates back to the home screen
                context.go('/');
              },
          onCancel: onCancel ??
              () {
                // only pop the dialog
                Navigator.pop(dialogContext);
              });
    },
  );
}
