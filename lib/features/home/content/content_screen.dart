import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/list_item_card.dart';
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
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListItemCard(
              mainText: "Add Questions",
              subText: "Edit existing questions and answers",
              actionIcon: Icons.arrow_forward_ios,
            ),
            ListItemCard(
              mainText: "Edit Qusetions",
              subText: "Add new questions",
              actionIcon: Icons.arrow_forward_ios,
            ),
          ],
        ),
      ),
    );
  }
}
