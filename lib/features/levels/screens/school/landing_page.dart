// ignore_for_file: prefer_const_constructors

import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/levels/screens/levels/level_selection_viewmodel.dart';
import 'package:ez_english/features/levels/screens/school/school_section_viewmodel.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:ez_english/widgets/drawer_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SpeakingSection extends StatefulWidget {
  final String levelId;
  const SpeakingSection({super.key, required this.levelId});

  @override
  State<SpeakingSection> createState() => _SpeakingSectionState();
}

class _SpeakingSectionState extends State<SpeakingSection> {
  late SchoolSectionViewmodel viewmodel;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int originalCurrentUnitNumber = 0;
  int tempCurrentUnitNumber = 0;
  bool _isLoading = true;
  @override
  void initState() {
    viewmodel = Provider.of<SchoolSectionViewmodel>(context, listen: false);
    viewmodel.levelId = widget.levelId;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await viewmodel.setValuesAndInit();
      originalCurrentUnitNumber = await viewmodel.fetchSections();
      tempCurrentUnitNumber = originalCurrentUnitNumber;
      setState(() {
        _isLoading = false;
      });
    });

    super.initState();
  }

  Future<void> _fetchSections() async {
    viewmodel = Provider.of<SchoolSectionViewmodel>(context, listen: false);
    // setState(() {
    //   _isLoading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.all(Constants.padding20),
            child: DrawerActionButton(
              onPressed: () {
                _scaffoldKey.currentState?.openEndDrawer();
              },
            ),
          )
        ],
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
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Constants.padding12, vertical: Constants.padding20),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
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
      endDrawer: Drawer(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  SizedBox(
                    height: 158.h,
                    child: const DrawerHeader(
                      decoration: BoxDecoration(
                        color: Palette.primaryButtonStroke,
                      ),
                      child: Center(
                        child: Text(
                          'Choose a Unit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ...List.generate(originalCurrentUnitNumber, (index) {
                    int unitNumber = index + 1;
                    return ListTile(
                      leading: const Icon(Icons.book),
                      title: Text('Unit $unitNumber'),
                      selected: unitNumber == tempCurrentUnitNumber,
                      onTap: () async {
                        Navigator.of(context).pop();
                        setState(() {
                          tempCurrentUnitNumber = unitNumber;
                        });
                        if (unitNumber != originalCurrentUnitNumber) {
                          viewmodel.tempUnit = true;
                          setState(() {
                            _isLoading = true;
                          });
                          await viewmodel.fetchQuestionsFromLevel(
                              desiredDay: tempCurrentUnitNumber);
                          setState(() {
                            _isLoading = false;
                          });
                        } else {
                          setState(() {
                            _isLoading = true;
                          });
                          await viewmodel.fetchQuestionsFromLevel();
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      },
                    );
                  }),
                ],
              ),
      ),
    );
  }
}
