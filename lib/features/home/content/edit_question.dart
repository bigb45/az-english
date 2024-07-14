import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/list_item_card.dart';
import 'package:flutter/material.dart';

class EditQuestion extends StatelessWidget {
  final String questionId;
  const EditQuestion({super.key, required this.questionId});

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("question id: $questionId"),
            const ListItemCard(
              mainText: "Question",
              subText: "Enter the question",
            ),
            const ListItemCard(
              mainText: "Answer",
              subText: "Enter the answer",
            ),
            const ListItemCard(
              mainText: "Options",
              subText: "Enter the options",
            ),
            const ListItemCard(
              mainText: "Add",
              subText: "Add the question",
            ),
          ],
        ),
      ),
    );
  }
}
