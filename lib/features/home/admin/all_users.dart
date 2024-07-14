// ignore_for_file: avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:ez_english/core/constants.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/list_item_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AllUsers extends StatelessWidget {
  const AllUsers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          contentPadding: const EdgeInsets.only(left: 0, right: 0),
          title: Text(
            "All Users",
            style: TextStyles.titleTextStyle,
          ),
          // subtitle: Text(
          //   "",
          //   style: TextStyles.subtitleTextStyle,
          // ),
        ),
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
