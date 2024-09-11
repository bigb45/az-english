import 'package:ez_english/features/auth/view_model/auth_view_model.dart';
import 'package:ez_english/features/models/user.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:ez_english/widgets/info_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(builder: (context, viewmodel, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            AppStrings.accountSettingsScreenTitle,
            style: const TextStyle(color: Palette.primaryText),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.account_circle,
                  size: 200,
                  color: Palette.primaryText,
                ),
                InfoCard(
                    title: AppStrings.username,
                    subtitle: "${viewmodel.userData?.studentName}"),
                InfoCard(
                    title: AppStrings.emailAddress,
                    subtitle: "${viewmodel.userData?.emailAddress}"),
                InfoCard(
                    title: AppStrings.phoneNumber,
                    subtitle: "${viewmodel.userData?.parentPhoneNumber}"),
                if (viewmodel.userData?.userType == UserType.admin ||
                    viewmodel.userData?.userType == UserType.developer) ...[
                  Button(
                    text: 'Manage Content and Users',
                    onPressed: () {
                      context.push('/admin');
                    },
                  ),
                  const SizedBox(height: 20),
                ],
                Button(
                  text: 'Sign out',
                  type: ButtonType.error,
                  onPressed: () async {
                    await viewmodel.signOut(context);
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
    });
  }
}
