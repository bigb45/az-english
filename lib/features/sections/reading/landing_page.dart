// ignore_for_file: prefer_const_constructors

import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/sections/reading/view_model/reading_section_viewmodel.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ReadingSection extends StatefulWidget {
  final String levelId;
  final String sectionName;
  final String levelName;
  final String sectionId;
  const ReadingSection(
      {super.key,
      required this.levelId,
      required this.sectionName,
      required this.levelName,
      required this.sectionId});

  @override
  State<ReadingSection> createState() => _ReadingSectionState();
}

class _ReadingSectionState extends State<ReadingSection> {
  late ReadingQuestionViewmodel readingSectionVm;

  @override
  void initState() {
    // setStatusBar to make the top side of the navbar with a different color since this is not supported for IOS in the default implementation of AppBar
    readingSectionVm =
        Provider.of<ReadingQuestionViewmodel>(context, listen: false);
    readingSectionVm.levelId = widget.levelId;
    readingSectionVm.levelName = widget.levelName;
    readingSectionVm.sectionName = widget.sectionName;
    readingSectionVm.sectionId = widget.sectionId;
    getQs();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterStatusbarcolor.setStatusBarColor(Palette.primary);
    });

    super.initState();
  }

  void getQs() async {
    await readingSectionVm.fetchQuestions(
        widget.levelName, widget.levelId, widget.sectionName, widget.sectionId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          contentPadding: EdgeInsets.only(left: 0, right: 0),
          title: Text(
            AppStrings.readingSectionOnboardingAppbarTitle,
            style: TextStyle(
              fontSize: 24.sp,
              color: Palette.secondary,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            // TODO: Change this to be dynamic from the API
            "Daily Conversations",
            style: TextStyle(
              fontSize: 17.sp,
              color: Palette.secondary,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
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
                      'assets/images/reading_secton_onboarding_vector.svg',
                      width: 200,
                      colorFilter: ColorFilter.mode(
                          Palette.primaryText, BlendMode.srcIn),
                    ),
                    Text(
                      AppStrings.readingSectionOnboardingTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32.sp,
                        color: Palette.primaryText,
                        fontFamily: 'Inter',
                        height: 2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    // TODO add the same gab to all onboarding screens
                    Constants.gapH12,
                    Text(
                      AppStrings.readingSectionOnboardingText,
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
                  context.push('/practice/reading');
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
