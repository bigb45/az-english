import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/auth/view_model/auth_view_model.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/router.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:ez_english/widgets/text_field.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final usedGap = Constants.gapH16;
  final emailAddressTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  late Map<String, TextEditingController> textFieldMap;
  @override
  void initState() {
    textFieldMap = {
      AppStrings.emailAddress: emailAddressTextController,
      AppStrings.password: passwordTextController,
    };
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailAddressTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(Constants.padding12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Constants.gapAppBarH,
              Text(
                AppStrings.loginScreenTitile,
                style:
                    TextStyles.cardHeader.copyWith(color: Palette.primaryText),
              ),
              Constants.gapH36,
              // TODO change logo
              Image.asset(
                "assets/images/test_icon.png",
              ),
              usedGap,
              ListView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 2, // Number of text fields you want
                itemBuilder: (context, index) {
                  final hint = textFieldMap.keys.elementAt(index);
                  final controller = textFieldMap[hint]!;
                  return Column(
                    children: [
                      SizedBox(
                        // giving custom height textfield causes text to be off-center
                        // height: 50.h,
                        child: CustomTextField(
                          focusNode: FocusNode(),
                          hintText: hint,
                          controller: controller,
                        ),
                      ),
                      usedGap, // Assuming Constants.gapH8 is a SizedBox with height 8
                    ],
                  );
                },
              ),
              Button(
                text: AppStrings.loginButton,
                onPressed: () async {
                  await authViewModel.signIn(
                    emailAddressTextController.text,
                    passwordTextController.text,
                    context,
                  );
                },
                type: ButtonType.primary,
              ),
              usedGap,
              Button(
                text: AppStrings.createAccountButton,
                onPressed: () {
                  context.push('/sign_up');
                },
                type: ButtonType.secondary,
              ),
              usedGap,
              GestureDetector(
                onTap: () async {
                  await authViewModel.resetPassword(
                    emailAddressTextController.text,
                    context,
                  );
                },
                child: Text(
                  "RESET PASSWORD",
                  style: TextStyles.cardText
                      .copyWith(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
