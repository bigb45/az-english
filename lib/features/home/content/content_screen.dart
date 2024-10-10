import 'package:ez_english/core/constants.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/vertical_list_item_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
      body: Padding(
        padding: EdgeInsets.all(Constants.padding12),
        child: Column(
          children: [
            VerticalListItemCard(
              mainText: "Edit Qusetions",
              subText: "Edit existing questions",
              action: Icons.arrow_forward_ios,
              showDeleteIcon: false,
              showIconDivider: false,
              onTap: () {
                context.push('/edit_question/2');
              },
            ),
            VerticalListItemCard(
              mainText: "Add Questions",
              subText: "Add new questions",
              action: Icons.arrow_forward_ios,
              showDeleteIcon: false,
              showIconDivider: false,
              onTap: () {
                context.push('/add_question');
              },
            ),
          ],
        ),
      ),
    );
  }
}
