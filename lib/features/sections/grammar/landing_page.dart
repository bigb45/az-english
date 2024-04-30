// ignore_for_file: prefer_const_constructors

import 'package:ez_english/core/constants.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GrammarSection extends StatefulWidget {
  const GrammarSection({super.key});

  @override
  State<GrammarSection> createState() => _GrammarSectionState();
}

class _GrammarSectionState extends State<GrammarSection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          contentPadding: EdgeInsets.only(left: 0, right: 0),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Palette.secondary,
            ),
            onPressed: () {
              print("Navigate back");
            },
          ),
          title: Text('Grammar', style: TextStyles.titleTextStyle),
          subtitle:
              Text("Daily Conversations", style: TextStyles.subtitleTextStyle),
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
                      'assets/images/grammar_section.svg',
                      width: 200,
                      colorFilter: ColorFilter.mode(
                          Palette.primaryText, BlendMode.srcIn),
                    ),
                    Text(
                      "Grammar Section",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32.sp,
                        color: Palette.primaryText,
                        fontFamily: 'Inter',
                        height: 2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "In this section you will read a paragraph out loud and afterwards,  you will be asked some questions regarding the passage",
                      textAlign: TextAlign.center,
                      style: TextStyles.bodyMedium,
                    ),
                  ],
                ),
              ),
              Button(
                  onPressed: () {
                    print("Navigate to practice page");
                  },
                  type: ButtonType.primary,
                  text: "continue")
            ],
          ),
        ),
      ),
    );
  }
}
