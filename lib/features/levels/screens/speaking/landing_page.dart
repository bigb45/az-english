// ignore_for_file: prefer_const_constructors

import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/levels/screens/speaking/speaking_practice_viewmodel.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SpeakingSection extends StatefulWidget {
  const SpeakingSection({super.key});

  @override
  State<SpeakingSection> createState() => _SpeakingSectionState();
}

class _SpeakingSectionState extends State<SpeakingSection> {
  late SpeakingPracticeViewmodel vm;

  @override
  void initState() {
    vm = Provider.of<SpeakingPracticeViewmodel>(context, listen: false);
    // vm.levelId = widget.levelId;
    vm.init();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // vm.setValuesAndInit();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          contentPadding: EdgeInsets.only(left: 0, right: 0),
          title: Text(
            AppStrings.speakingPracticeScreenTitle,
            style: TextStyle(
              fontSize: 24.sp,
              color: Palette.secondary,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
          // subtitle: Text(
          //   // TODO: Change this to be dynamic from the API
          //   "Daily Conversations",
          //   style: TextStyle(
          //     fontSize: 17.sp,
          //     color: Palette.secondary,
          //     fontFamily: 'Inter',
          //     fontWeight: FontWeight.w400,
          //   ),
          // ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Constants.padding12, vertical: Constants.padding20),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/speaking_section_onboarding.svg',
                      width: 200,
                      colorFilter: ColorFilter.mode(
                          Palette.primaryText, BlendMode.srcIn),
                    ),
                    Text(
                      AppStrings.speakingSectionPageTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32.sp,
                        color: Palette.primaryText,
                        fontFamily: 'Inter',
                        height: 2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Constants.gapH12,
                    Text(
                      AppStrings.speakingSectionOnboardingText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        height: 2,
                        fontSize: 16.sp,
                        color: Palette.primaryText,
                      ),
                    ),
                  ],
                ),
              ),
              Button(
                onPressed: () {
                  context.push('/speaking_practice/practice');
                },
                type: ButtonType.primary,
                text: AppStrings.startPracticingButton,
              )
            ],
          ),
        ),
      ),
    );
  }
}
