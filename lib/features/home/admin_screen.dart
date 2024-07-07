import 'package:ez_english/core/constants.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/list_item_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListItemCard(
                    mainText: "User ${index + 1} name",
                    subText: "User ${index + 1} email",
                    info: Text(
                      UserType.values[index % 3].toString().split('.').last,
                      style: switch (UserType.values[index % 3]) {
                        UserType.admin => const TextStyle(color: Colors.orange),
                        UserType.superAdmin =>
                          const TextStyle(color: Colors.red),
                        UserType.user => const TextStyle(color: Colors.green),
                      },
                    ),
                    actionIcon: Icons.arrow_forward_ios,
                    onTap: () {
                      context.push(
                        "/user_settings/$index", // navigate user settings
                      );
                    },
                    // result:
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum UserType {
  superAdmin,
  admin,
  user,
}
