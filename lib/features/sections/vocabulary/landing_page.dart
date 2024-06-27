// this may not be necessary
import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/sections/vocabulary/viewmodel/vocabulary_section_viewmodel.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class VocabularySection extends StatefulWidget {
  final String levelId;
  VocabularySection({super.key, required this.levelId});

  @override
  State<VocabularySection> createState() => _VocabularySectionState();
}

class _VocabularySectionState extends State<VocabularySection> {
  late VocabularySectionViewmodel vocabularySectionVm;

  void initState() {
    vocabularySectionVm =
        Provider.of<VocabularySectionViewmodel>(context, listen: false);
    vocabularySectionVm.levelId = widget.levelId;
    // no need to pass section Id since each viewmodel is already knows its section
    // readingSectionVm.sectionId = widget.sectionId;

    // TODO: refactor myInit to use the viewmodel's built in init function
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      vocabularySectionVm.setValuesAndInit();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          contentPadding: const EdgeInsets.only(left: 0, right: 0),
          title: Text(
            AppStrings.vocabularySectionOnboardingAppbarTitle,
            style: TextStyle(
              fontSize: 24.sp,
              color: Palette.secondary,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            "Common Words",
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
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/vocabulary_section.svg',
                        width: 200,
                        colorFilter: const ColorFilter.mode(
                            Palette.primaryText, BlendMode.srcIn),
                      ),
                      Text(
                        AppStrings.vocabularySectionOnboardingTitle,
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
                        vocabularySectionVm.unit.descriptionInArabic ??
                            AppStrings.vocabularySectionOnboardingDescription,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          height: 1.5,
                          fontSize: 16.sp,
                          color: Palette.primaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Button(
                onPressed: () {
                  context.push('/practice/vocabulary');
                },
                text: "Continue",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
