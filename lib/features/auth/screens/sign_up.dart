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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController studentNameTextController =
      TextEditingController();
  final TextEditingController parentPhoneNumberTextController =
      TextEditingController();
  final TextEditingController emailAddressTextController =
      TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();

  late List<String> textFieldHints;
  late List<TextEditingController> textFieldControllers;
  late List<String? Function(String? email)> textFieldValidators;
  late List<TextFieldType> textFieldTypes;

  @override
  void initState() {
    textFieldHints = [
      AppStrings.studentName,
      AppStrings.parentPhoneNumber,
      AppStrings.emailAddress,
      AppStrings.password
    ];
    textFieldValidators = [
      Validators.validateStudentName,
      Validators.validateParentPhoneNumber,
      Validators.validateEmailAddress,
      Validators.validatePassword,
    ];
    textFieldControllers = [
      studentNameTextController,
      parentPhoneNumberTextController,
      emailAddressTextController,
      passwordTextController
    ];
    textFieldTypes = [
      TextFieldType.text,
      TextFieldType.phone,
      TextFieldType.email,
      TextFieldType.password,
    ];
    super.initState();
  }

  @override
  void dispose() {
    passwordTextController.dispose();
    studentNameTextController.dispose();
    parentPhoneNumberTextController.dispose();
    emailAddressTextController.dispose();
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
                Constants.gapH8,
                // TODO change logo
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.0.r),
                  child: Image.asset(
                    "assets/images/logo2.png",
                    width: 200.w,
                    height: 200.w,
                  ),
                ),

                Constants.gapH36,
                ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 4, // Number of text fields you want
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        SizedBox(
                          // height: 50.h,
                          child: CustomTextField(
                            hintText: textFieldHints[index],
                            controller: textFieldControllers[index],
                            validator: textFieldValidators[index],
                            fieldType: textFieldTypes[index],
                          ),
                        ),
                        Constants
                            .gapH8, // Assuming Constants.gapH8 is a SizedBox with height 8
                      ],
                    );
                  },
                ),
                Button(
                  text: AppStrings.createAccountButton,
                  onPressed: () async {
                    final isValid = formKey.currentState!.validate();
                    if (!isValid) return;
                    final user = UserModel(
                      studentName: studentNameTextController.text,
                      parentPhoneNumber: parentPhoneNumberTextController.text,
                      emailAddress: emailAddressTextController.text,
                      password: passwordTextController.text,
                    );
                    await authViewModel.signUp(user, context);
                  },
                  type: ButtonType.primary,
                ),
                Constants.gapH12,
                Button(
                  text: AppStrings.loginButton,
                  onPressed: () {
                    context.pop();
                  },
                  type: ButtonType.secondary,
                ),
                Constants.gapH12,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
