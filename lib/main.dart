// ignore_for_file: prefer_const_constructors

import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:ez_english/widgets/card.dart';
import 'package:ez_english/widgets/result_card.dart';
import 'package:ez_english/widgets/text_field.dart';
import 'package:ez_english/widgets/word_chip.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Palette.primary,
        scaffoldBackgroundColor: Palette.secondary,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Button(
                  onPressed: () {},
                  type: ButtonType.primary,
                  child: Text(
                    "CONTINUE",
                    style: TextStyle(
                      color: Palette.secondary,
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                CustomTextField(),
                SelectableCard(
                  onPressed: () {},
                  child: Text(
                    "Long Vocabulary Card",
                    style: TextStyle(
                      color: Palette.primaryText,
                      fontFamily: 'Inter',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                WordChip(
                  onPressed: () {},
                  child: Text(
                    "word",
                    style: TextStyle(
                      color: Palette.primaryText,
                      fontFamily: 'Inter',
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                ResultCard(
                  topText: "BAD",
                  score: Score.bad,
                  mainText: "8/10 ANSWERED CORRECTLY",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
