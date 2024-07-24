import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/home/admin/users_settings_viewmodel.dart';
import 'package:ez_english/features/models/user.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/widgets/checkbox.dart';
import 'package:ez_english/widgets/info_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class UserSettings extends StatelessWidget {
  final String userId;
  const UserSettings({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Consumer<UsersSettingsViewmodel>(
      builder: (context, viewmodel, _) {
        int userIdNumber = int.tryParse(userId)!;
        if (userIdNumber < 0 || userIdNumber >= viewmodel.users.length) {
          return const Scaffold(
            body: Center(
              child: Text(
                'User not found',
              ),
            ),
          );
        }

        UserModel? user = viewmodel.users[userIdNumber];
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(Icons.arrow_back),
              color: Palette.primaryText,
            ),
            title: const Text(
              'User Settings',
              style: TextStyle(color: Palette.primaryText),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
          ),
          body: Padding(
            padding: EdgeInsets.all(Constants.padding12),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.account_circle,
                      size: 200,
                      color: Palette.primaryText,
                    ),
                    InfoCard(
                      title: AppStrings.username,
                      subtitle: user!.studentName!,
                      actionIcon: Icons.edit,
                      onTap: () {
                        showEditDialog(
                          context,
                          title: "Edit username",
                          content: user.studentName!,
                          hintText: "Enter new username",
                          onSubmitted: (value) {
                            viewmodel.updateName(user.id!, value);
                          },
                        );
                      },
                    ),
                    InfoCard(
                      title: AppStrings.emailAddress,
                      subtitle: user.emailAddress,
                    ),
                    InfoCard(
                      title: "User Type",
                      subtitle: user.userType.toShortString(),
                      actionIcon: Icons.edit,
                      onTap: () {
                        showEditUserTypeDialog(
                          context,
                          type: user.userType,
                          onSubmitted: (value) {
                            viewmodel.updateUserType(value, user.id!);
                          },
                        );
                      },
                    ),
                    InfoCard(
                      title: AppStrings.phoneNumber,
                      subtitle: user.parentPhoneNumber!,
                      actionIcon: Icons.edit,
                      onTap: () {
                        showEditDialog(
                          context,
                          title: "Edit phone number",
                          content: user.parentPhoneNumber!,
                          hintText: "Enter new phone number",
                          onSubmitted: (value) {
                            viewmodel.updateParentPhoneNumber(user.id!, value);
                          },
                        );
                      },
                    ),
                    InfoCard(
                      title: "Assigned levels",
                      subtitle: user.assignedLevels!.isNotEmpty
                          ? user.assignedLevels!.join(", ")
                          : "No Assigned Levels yet",
                      actionIcon: Icons.edit,
                      onTap: () {
                        showAssignedLevelsDialog(
                          context,
                          title: "Assigned levels",
                          allLevels: viewmodel.levels
                              .map(
                                (level) => CheckboxData(title: level!.name),
                              )
                              .toList(),
                          assignedLevels: user.assignedLevels
                              ?.map(
                                (name) => CheckboxData(title: name),
                              )
                              .toList(),
                          onSubmitted: (value) {
                            viewmodel.updateAssignedLevels(user.id!, value);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

void showAssignedLevelsDialog(
  BuildContext context, {
  required String title,
  required List<CheckboxData> allLevels,
  required List<CheckboxData>? assignedLevels,
  required Function(List<CheckboxData>?) onSubmitted,
}) {
  List<CheckboxState> states = [];

  allLevels.forEach((element) {
    if (assignedLevels != null &&
        assignedLevels!.any((assigned) => assigned.title == element.title)) {
      states.add(CheckboxState.checked);
      element.value = true;
    } else {
      states.add(CheckboxState.unchecked);
      element.value = false;
    }
  });

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) => AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: CheckboxGroup(
          states: states,
          onChanged: (value) {
            assignedLevels = value;
          },
          options: allLevels,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            onSubmitted(assignedLevels);
            Navigator.pop(dialogContext);
          },
          child: const Text("Submit"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text("Cancel"),
        ),
      ],
    ),
  );
}

void showEditUserTypeDialog(context,
    {required UserType type, required Function(UserType) onSubmitted}) {
  UserType newType = type;
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Edit User Type"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: UserType.values
              .where((userTypeIter) => userTypeIter != UserType.developer)
              .map((e) {
            return RadioListTile(
              title: Text(e.toShortString()),
              value: e,
              groupValue: newType,
              onChanged: (value) {
                onSubmitted(value!);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      );
    },
  );
}

void showEditDialog(context,
    {required String title,
    required String content,
    required String hintText,
    required Function(String) onSubmitted}) {
  final controller = TextEditingController(text: content);
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: hintText,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              onSubmitted(controller.text);
              Navigator.pop(context);
            },
            child: const Text("Submit"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      );
    },
  );
}
