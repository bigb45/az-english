import 'package:ez_english/theme/text_styles.dart';
import 'package:flutter/material.dart';

class ContentScreen extends StatelessWidget {
  const ContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          contentPadding: const EdgeInsets.only(left: 0, right: 0),
          title: Text(
            "Questions",
            style: TextStyles.titleTextStyle,
          ),
          subtitle: Text(
            "AZ English Questions",
            style: TextStyles.subtitleTextStyle,
          ),
        ),
      ),
      body: Placeholder(),
    );
  }
}
