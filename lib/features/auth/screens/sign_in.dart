import 'package:ez_english/core/constants.dart';
import 'package:ez_english/core/validators/form_validator.dart';
import 'package:ez_english/features/auth/view_model/auth_view_model.dart';
import 'package:ez_english/features/models/user.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:ez_english/widgets/text_field.dart';
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
  final formKey = GlobalKey<FormState>();

  late List<String> textFieldHints;
  late List<TextEditingController> textFieldControllers;
  late List<String? Function(String? email)> textFieldValidators;
  late List<TextFieldType> textFieldTypes;
  late AuthViewModel authViewModel;

  @override
  void initState() {
    textFieldHints = [AppStrings.emailAddress, AppStrings.password];
    textFieldValidators = [
      Validators.validateEmailAddress,
      Validators.validatePassword,
    ];
    textFieldControllers = [emailAddressTextController, passwordTextController];
    textFieldTypes = [TextFieldType.text, TextFieldType.password];

    authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    //TODO delete this if you want to stop auto login for test purposes
    authViewModel.signInDev();

    super.initState();
  }

  @override
  void dispose() {
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
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Constants.gapAppBarH,
                Text(
                  AppStrings.loginScreenTitile,
                  style: TextStyles.cardHeader
                      .copyWith(color: Palette.primaryText),
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
                    return Column(
                      children: [
                        SizedBox(
                          child: CustomTextField(
                            fieldType: textFieldTypes[index],
                            validator: textFieldValidators[index],
                            focusNode: FocusNode(),
                            hintText: textFieldHints[index],
                            controller: textFieldControllers[index],
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
                    final isValid = formKey.currentState!.validate();
                    if (!isValid) return;
                    final user = UserModel(
                        emailAddress: emailAddressTextController.text,
                        password: passwordTextController.text);
                    await authViewModel.signIn(user, context);
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
      ),
    );
  }
}
