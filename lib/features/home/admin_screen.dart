import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/home/viewmodel/users_settings_viewmodel.dart';
import 'package:ez_english/features/models/user.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/list_item_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
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
          title: const Text(
            'Administrator',
            style: TextStyle(color: Palette.primaryText),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
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
                      viewmodel.users.length.toString(),
                      style: TextStyles.bodyLarge,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: viewmodel.users.length,
                        itemBuilder: (context, index) {
                          return ListItemCard(
                            mainText: "${viewmodel.users[index]?.studentName}",
                            info: Text(
                              viewmodel.users[index]!.userType!.toShortString(),
                              style: switch (
                                  viewmodel.users[index]!.userType!) {
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
