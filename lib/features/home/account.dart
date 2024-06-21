import 'package:ez_english/core/Constants.dart';
import 'package:ez_english/features/auth/view_model/auth_view_model.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Account extends StatelessWidget {
  Account({super.key});
  final AuthViewModel vm = AuthViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Signed in as ${vm.user?.email}'),
            Button(
              text: 'Sign out',
              onPressed: () async {
                await vm.signOut(context);
              },
            ),
            SizedBox(
              height: Constants.padding8,
            ),
            Button(
              text: 'Go to Components',
              onPressed: () {
                context.push('/components');
              },
            ),
            SizedBox(
              height: Constants.padding8,
            ),
            Button(
              text: 'Go to Settings',
              onPressed: () {
                context.push('/settings');
              },
            ),
          ],
        ),
      ),
    );
  }
}
