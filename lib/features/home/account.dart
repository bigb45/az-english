import 'package:ez_english/features/auth/view_model/auth_view_model.dart';
import 'package:ez_english/features/models/user.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:ez_english/widgets/info_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Account extends StatelessWidget {
  Account({super.key});
  final AuthViewModel vm = AuthViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.accountSettingsScreenTitle,
          style: TextStyle(color: Palette.primaryText),
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
                  subtitle: "${vm.userData?.studentName}"),
              InfoCard(
                  title: AppStrings.emailAddress,
                  subtitle: "${vm.userData?.emailAddress}"),
              InfoCard(
                  title: AppStrings.phoneNumber,
                  subtitle: "${vm.userData?.parentPhoneNumber}"),
              if (vm.userData?.userType == UserType.admin ||
                  vm.userData?.userType == UserType.developer) ...[
                Button(
                  text: 'Manage Content and Users',
                  onPressed: () {
                    context.push('/admin');
                  },
                ),
                SizedBox(height: 20),
              ],
              Button(
                text: 'Sign out',
                type: ButtonType.error,
                onPressed: () async {
                  await vm.signOut(context);
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
