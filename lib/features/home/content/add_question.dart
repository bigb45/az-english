import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/list_item_card.dart';
import 'package:flutter/material.dart';

class AddQuestion extends StatelessWidget {
  const AddQuestion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          contentPadding: const EdgeInsets.only(left: 0, right: 0),
          title: Text(
            "Add Question",
            style: TextStyles.titleTextStyle,
          ),
          subtitle: Text(
            "Add new questions",
            style: TextStyles.subtitleTextStyle,
          ),
        ),
      ),
      body: const Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListItemCard(
              mainText: "Question",
              subText: "Enter the question",
            ),
            ListItemCard(
              mainText: "Answer",
              subText: "Enter the answer",
            ),
            ListItemCard(
              mainText: "Options",
              subText: "Enter the options",
            ),
            ListItemCard(
              mainText: "Add",
              subText: "Add the question",
            ),
          ],
        ),
      ),
    );
  }
}
