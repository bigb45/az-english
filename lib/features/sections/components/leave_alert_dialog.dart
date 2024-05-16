import 'package:flutter/material.dart';

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
