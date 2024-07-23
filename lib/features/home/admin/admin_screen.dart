// ignore_for_file: avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:ez_english/core/constants.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/selectable_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Palette.primaryText),
        title: const Text(
          'Administrator',
          style: TextStyle(color: Palette.primaryText),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.all(Constants.padding12),
        child: Column(
          children: [
            Text(
              // viewmodel.totalUsers,
              "Total users: 10",
              style: TextStyles.bodyLarge,
            ),
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 10.w,
                runSpacing: 10.w,
                children: [
                  SelectableCard(
                    onPressed: () {
                      context.push(
                        "/all_users", // navigate user settings
                      );

                      print("selected");
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SvgPicture.asset(
                          "assets/images/users.svg",
                          height: 100,
                          width: 100,
                        ),
                        Text(
                          "Users",
                          style: TextStyles.bodyLarge,
                        )
                      ],
                    ),
                  ),
                  SelectableCard(
                    onPressed: () {
                      context.push(
                        "/all_questions",
                      );

                      print("selected");
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SvgPicture.asset(
                          "assets/images/question-mark.svg",
                          height: 60,
                          width: 60,
                        ),
                        Text(
                          "Questions",
                          style: TextStyles.bodyLarge,
                        )
                      ],
                    ),
                  ),
                  SelectableCard(
                    onPressed: null,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SvgPicture.asset(
                          "assets/images/statistics.svg",
                          height: 100,
                          width: 100,
                        ),
                        Text(
                          "Statistics",
                          style: TextStyles.bodyLarge,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
