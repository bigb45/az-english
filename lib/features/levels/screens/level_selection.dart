import 'package:ez_english/core/constants.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LevelSelection extends StatefulWidget {
  const LevelSelection({Key? key}) : super(key: key);

  @override
  State<LevelSelection> createState() => _LevelSelectionState();
}

class _LevelSelectionState extends State<LevelSelection> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Assigned Levels',
          style: TextStyle(color: Palette.blackColor),
        ),
      ),
      body: SizedBox(
        child: Column(
          children: [
            // First row
            Constants.gapH36,
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  _buildCard(
                      headerText: 'A1',
                      cardText:
                          "learn common everyday expressions and simple phrases"),
                  Constants.gapW10,
                  _buildCard(
                      headerText: 'A1',
                      cardText:
                          "learn common everyday expressions and simple phrases"),
                ],
              ),
            ),
            // Second row
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  _buildCard(
                      headerText: 'A1',
                      cardText:
                          "learn common everyday expressions and simple phrases"),
                  Constants.gapW10,
                  _buildCard(
                      headerText: 'A1',
                      cardText:
                          "learn common everyday expressions and simple phrases"),
                ],
              ),
            ),
            // Third row
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCard(
                    headerText: 'A1',
                    cardText:
                        "learn common everyday expressions and simple phrases",
                  ),
                ],
              ),
            ),
            Constants.gapH36,
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String headerText, required String cardText}) {
    return SelectableCard(
      onPressed: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            headerText,
            style: TextStyles.cardHeader,
            textAlign: TextAlign.center,
          ),
          Constants.gapH20,
          Text(
            cardText,
            style: TextStyles.cardText,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
