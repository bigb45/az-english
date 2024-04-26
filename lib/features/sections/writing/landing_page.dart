// ignore_for_file: prefer_const_constructors

import 'package:ez_english/core/constants.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WritingSection extends StatefulWidget {
  const WritingSection({super.key});

  @override
  State<WritingSection> createState() => _WritingSectionState();
}

class _WritingSectionState extends State<WritingSection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO: use the default theme from the palette file
      appBar: AppBar(
        toolbarHeight: 90.h,
        backgroundColor: Palette.primaryShadow,
        elevation: 0,
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
          title: Text(
            'Writing & Listening',
            style: TextStyle(
              fontSize: 24.sp,
              color: Palette.secondary,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
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
                      'assets/images/writing_section.svg',
                      width: 200,
                      colorFilter: ColorFilter.mode(
                          Palette.primaryText, BlendMode.srcIn),
                    ),
                    Text(
                      "Writing & Listening Section",
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
                onPressed: () {},
                type: ButtonType.primary,
                child: Text(
                  "CONTINUE",
                  style: TextStyle(
                    color: Palette.secondary,
                    fontFamily: 'Inter',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
