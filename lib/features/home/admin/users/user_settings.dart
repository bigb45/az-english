import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/auth/view_model/auth_view_model.dart';
import 'package:ez_english/features/home/admin/users/users_settings_viewmodel.dart';
import 'package:ez_english/features/models/user.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:ez_english/widgets/checkbox.dart';
import 'package:ez_english/widgets/info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class UserSettings extends StatelessWidget {
  final String userId;
  const UserSettings({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final authViewmodel = Provider.of<AuthViewModel>(context, listen: false);
    List<String?>? assignedLevels;
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

        assignedLevels = user!
            .assignedQuestions![RouteConstants
                .sectionNameId[RouteConstants.speakingSectionName]]!
            .assignedLevels;

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
                    Button(
                        text: "assign questions",
                        onPressed: () {
                          context.push(
                              '/user_settings/$userId/question_assignment');
                        }),
                    InfoCard(
                      title: AppStrings.username,
                      subtitle: user.studentName!,
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
                            authViewmodel.refreshUserData();
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
                      title: "Speaking Section",
                      subtitle: (user.assignedLevels!.isNotEmpty)
                          ? [
                              ...user.assignedLevels!,
                            ].join(", ")
                          : "No Assigned Sections yet",
                      actionIcon: Icons.edit,
                      onTap: () {
                        showAssignedLevelsDialog(
                          context,
                          title: "Level Assignment",
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
                          onSubmitted: (List<String> selectedTitles) {
                            List<CheckboxData> selectedCheckboxData =
                                selectedTitles
                                    .map((title) => CheckboxData(
                                        title: title, isSelected: true))
                                    .toList();

                            viewmodel.updateAssignedLevels(
                                user.id!, selectedCheckboxData,
                                assignedQuestion: false);
                          },
                        );
                      },
                    ),
                    InfoCard(
                      title: "English Practice",
                      subtitle:
                          (assignedLevels != null && assignedLevels!.isNotEmpty)
                              ? [
                                  ...assignedLevels ?? [],
                                ].join(", ")
                              : "No Assigned Sections yet",
                      actionIcon: Icons.edit,
                      onTap: () {
                        showAssignedLevelsDialog(
                          context,
                          title: "Level Assignment",
                          allLevels: viewmodel.levels
                              .map(
                                (level) => CheckboxData(title: level!.name),
                              )
                              .toList(),
                          assignedLevels: assignedLevels
                              ?.map(
                                (name) => CheckboxData(title: name ?? ""),
                              )
                              .toList(),
                          onSubmitted: (List<String> selectedTitles) {
                            List<CheckboxData> selectedCheckboxData =
                                selectedTitles
                                    .map((title) => CheckboxData(
                                        title: title, isSelected: true))
                                    .toList();

                            viewmodel.updateAssignedLevels(
                                user.id!, selectedCheckboxData,
                                assignedQuestion: true);
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
  required Function(List<String>) onSubmitted,
}) {
  // Initialize selected state from assigned levels
  allLevels.forEach((level) {
    level.isSelected =
        assignedLevels?.any((assigned) => assigned.title == level.title) ??
            false;
  });

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          title,
          style: TextStyle(fontSize: 25.sp),
        ),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...allLevels.map((level) {
                  return CheckboxListTile(
                    title: Text(level.title),
                    value: level.isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value != null) {
                          if (value) {
                            for (var l in allLevels
                                .where((l) => l.title != level.title)) {
                              l.isSelected = false;
                            }
                          }
                          level.isSelected = value;
                        }
                      });
                    },
                  );
                }).toList(),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Convert the selected CheckboxData to List<String>
              List<String> selectedTitles = allLevels
                  .where((level) => level.isSelected)
                  .map((level) => level.title)
                  .toList();

              Navigator.pop(context);
              onSubmitted(
                  selectedTitles); // Pass the List<String> to onSubmitted
            },
            child: Text('Submit'),
          ),
        ],
      );
    },
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
