import 'package:ez_english/theme/palette.dart';
import 'package:flutter/material.dart';

class ResultCard extends StatelessWidget {
  final String mainText;
  final String topText;
  final Score score;
  const ResultCard(
      {super.key,
      required this.mainText,
      required this.topText,
      this.score = Score.good});

  @override
  Widget build(BuildContext context) {
    var color = switch (score) {
      Score.good => Theme.of(context).primaryColor,
      Score.average => Palette.tertiary,
      Score.bad => Palette.error,
    };
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(topText,
              style: const TextStyle(
                color: Palette.secondary,
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w700,
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            width: 180,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Center(
                child: Text(
                  mainText,
                  style: TextStyle(
                      color: color,
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }
}

enum Score { good, average, bad }
