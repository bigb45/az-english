import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/home/viewmodel/user_settings_viewmodel.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/widgets/checkbox.dart';
import 'package:ez_english/widgets/info_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserSettings extends StatelessWidget {
  final String userId;
  const UserSettings({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserSettingsViewmodel>(
      builder: (context, viewmodel, _) => Scaffold(
        appBar: AppBar(
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
                    subtitle: "name",
                    actionIcon: Icons.edit,
                    onTap: () {
                      showEditDialog(
                        context,
                        title: "Edit username",
                        content: "name",
                        hintText: "Enter new username",
                        onSubmitted: (value) {
                          viewmodel.updateName(value);
                        },
                      );
                    },
                  ),
                  InfoCard(title: AppStrings.emailAddress, subtitle: "email"),
                  InfoCard(
                      title: AppStrings.phoneNumber,
                      subtitle: "phone",
                      actionIcon: Icons.edit,
                      onTap: () {
                        showEditDialog(
                          context,
                          title: "Edit phone number",
                          content: "phone",
                          hintText: "Enter new phone number",
                          onSubmitted: (value) {
                            viewmodel.updatePhoneNumber(value);
                          },
                        );
                      }),
                  InfoCard(
                    title: "Assigned levels",
                    subtitle: viewmodel.levels.map((e) => e.title).join(", "),
                    actionIcon: Icons.edit,
                    onTap: () {
                      showAssignedLevelsDialog(
                        context,
                        title: "Assigned levels",
                        allLevels: [
                          CheckboxData(title: "A1"),
                          CheckboxData(title: "A2"),
                          CheckboxData(title: "B1"),
                          CheckboxData(title: "B2"),
                          CheckboxData(title: "C1"),
                          CheckboxData(title: "C2"),
                        ],
                        assignedLevels: viewmodel.levels,
                        onSubmitted: (value) {
                          viewmodel.updateAssignedLevels(value);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void showAssignedLevelsDialog(
  context, {
  required String title,
  required List<CheckboxData> allLevels,
  required List<CheckboxData> assignedLevels,
  required Function(List<CheckboxData>) onSubmitted,
}) {
  List<CheckboxState> states = [];
  //  List<CheckboxData> assignedLevels = viewmodel.levels;
  // List<CheckboxData> allLevels = [
  //   CheckboxData(title: "A1"),
  //   CheckboxData(title: "A2"),
  //   CheckboxData(title: "B1"),
  //   CheckboxData(title: "B2"),
  //   CheckboxData(title: "C1"),
  //   CheckboxData(title: "C2"),
  // ];
  // set the states for assigned levels
  allLevels.forEach((element) {
    if (assignedLevels.any((assigned) => assigned.title == element.title)) {
      states.add(CheckboxState.checked);
      element.value = true;
    } else {
      states.add(CheckboxState.unchecked);
      element.value = false;
    }
  });
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Assigned levels"),
      content: SingleChildScrollView(
        child: CheckboxGroup(
            states: states,
            onChanged: (value) {
              assignedLevels = value;
            },
            options: allLevels),
      ),
      actions: [
        TextButton(
          onPressed: () {
            onSubmitted(assignedLevels);

            Navigator.pop(context);
          },
          child: const Text("Submit"),
        ),
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"))
      ],
    ),
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
        title: const Text("Edit username"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: "Enter new username",
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
