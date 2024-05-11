import 'package:ez_english/core/constants.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:ez_english/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final Map<String, TextEditingController> textFieldMap = {
    AppStrings.studentName: TextEditingController(),
    AppStrings.parentPhoneNumber: TextEditingController(),
    AppStrings.emailAddress: TextEditingController(),
    AppStrings.password: TextEditingController(),
  };

  @override
  Widget build(BuildContext context) {
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
              Constants.gapH8,
              // TODO change logo
              Image.asset(
                "assets/images/test_icon.png",
              ),

              Constants.gapH8,
              ListView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 4, // Number of text fields you want
                itemBuilder: (context, index) {
                  final hint = textFieldMap.keys.elementAt(index);
                  final controller = textFieldMap[hint]!;
                  return Column(
                    children: [
                      SizedBox(
                        height: 50.h,
                        child: CustomTextField(
                          hintText: hint,
                          controller: controller,
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
                onPressed: () {},
                type: ButtonType.primary,
              ),
              Constants.gapH12,
              Button(
                text: AppStrings.loginButton,
                onPressed: () {},
                type: ButtonType.secondary,
              ),
              Constants.gapH12,
            ],
          ),
        ),
      ),
    );
  }
}
