// ignore_for_file: avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/home/admin/users_settings_viewmodel.dart';
import 'package:ez_english/features/models/user.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/list_item_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({super.key});

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  late UsersSettingsViewmodel viewmodel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      viewmodel = Provider.of<UsersSettingsViewmodel>(context, listen: false);
      viewmodel.myInit();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UsersSettingsViewmodel>(builder: (BuildContext context,
        UsersSettingsViewmodel viewmodel, Widget? child) {
      return Scaffold(
        appBar: AppBar(
          title: ListTile(
            contentPadding: const EdgeInsets.only(left: 0, right: 0),
            title: Text(
              "All Users",
              style: TextStyles.titleTextStyle,
            ),
            subtitle: Text(
              "All users in the system",
              style: TextStyles.subtitleTextStyle,
            ),
          ),
        ),
        body: viewmodel.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.all(Constants.padding12),
                child: Column(
                  children: [
                    Text(
                      "Total users: ${viewmodel.users.length.toString()}",
                      style: TextStyles.bodyLarge,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: viewmodel.users.length,
                        itemBuilder: (context, index) {
                          return ListItemCard(
                            mainText: "${viewmodel.users[index]?.studentName}",
                            info: Text(
                              viewmodel.users[index]!.userType.toShortString(),
                              style: switch (viewmodel.users[index]!.userType) {
                                UserType.admin =>
                                  const TextStyle(color: Colors.orange),
                                UserType.developer =>
                                  const TextStyle(color: Colors.red),
                                UserType.student =>
                                  const TextStyle(color: Colors.green),
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
    });
  }
}
