// ignore_for_file: prefer_const_constructors

import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/sections/listening/viewmodel/listening_section_viewmodel.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ListeningSection extends StatefulWidget {
  final String levelId;

  const ListeningSection({super.key, required this.levelId});

  @override
  State<ListeningSection> createState() => _ListeningSectionState();
}

class _ListeningSectionState extends State<ListeningSection> {
  late ListeningSectionViewmodel viewmodel;
  @override
  void initState() {
    viewmodel = Provider.of<ListeningSectionViewmodel>(context, listen: false);
    viewmodel.levelId = widget.levelId;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      viewmodel.myInit();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    viewmodel = Provider.of<ListeningSectionViewmodel>(context);
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          contentPadding: EdgeInsets.only(left: 0, right: 0),
          title: Text(
            'Listening',
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
                      "Listening Section",
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
                onPressed: () {
                  context.push('/practice/listening');
                },
                type: ButtonType.primary,
                text: "continue",
              )
            ],
          ),
        ),
      ),
    );
  }
}
