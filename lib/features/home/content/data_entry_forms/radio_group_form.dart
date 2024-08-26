import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/widgets/radio_button.dart';
import 'package:flutter/material.dart';

class RadioGroupForm extends StatefulWidget {
  final Function(RadioItemData) onSelectionChanged;
  final Function(bool) onFormChanged;

  final List<RadioItemData> options;
  final RadioItemData selectedOption;
  final Function(RadioItemData) onDeleteItem;
  final Function(String, RadioItemData) onAnswerUpdated;

  const RadioGroupForm({
    super.key,
    required this.onFormChanged,
    required this.onAnswerUpdated,
    required this.onSelectionChanged,
    required this.onDeleteItem,
    required this.options,
    required this.selectedOption,
  });

  @override
  State<RadioGroupForm> createState() => _RadioGroupFormState();
}

class _RadioGroupFormState extends State<RadioGroupForm> {
  late RadioItemData? selectedOption;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    selectedOption = widget.selectedOption.title.isNotEmpty
        ? widget.selectedOption
        : widget.options.first;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      onChanged: () {
        widget.onFormChanged(_formKey.currentState!.validate());
      },
      autovalidateMode: AutovalidateMode.always,
      child: Column(
        children: List.generate(
          widget.options.length,
          (index) {
            RadioItemData option = widget.options[index];
            return ListTile(
              horizontalTitleGap: 0,
              minLeadingWidth: 0,
              key: ValueKey(option.value),
              onTap: () {
                if (option.title.isNotEmpty) {
                  setState(() {
                    widget.onSelectionChanged(option);
                    selectedOption = option;
                  });
                }
              },
              title: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.requiredField;
                  }

                  return null;
                },
                initialValue: option.title,
                onChanged: (newAnswer) {
                  widget.onAnswerUpdated(newAnswer, option);
                },
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "Option ${index + 1}",
                  errorText:
                      option.title.isEmpty ? AppStrings.requiredField : null,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    // _formKey.currentState!.validate();
                    widget.onDeleteItem(option);
                    if (selectedOption == option) {
                      selectedOption = widget.options[0];
                    }
                  });
                },
              ),
              leading: Radio<RadioItemData>(
                value: option,
                groupValue: selectedOption,
                onChanged: (value) {
                  // if (option.title.isNotEmpty) {
                  // print
                  setState(() {
                    selectedOption = value;
                    widget.onSelectionChanged(value!);
                  });
                  // }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
