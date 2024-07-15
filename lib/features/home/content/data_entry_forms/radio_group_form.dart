import 'package:ez_english/widgets/radio_button.dart';
import 'package:flutter/material.dart';

class RadioGroupForm extends StatefulWidget {
  final Function(RadioItemData) onChanged;
  final List<RadioItemData> options;
  final RadioItemData? selectedOption;
  final Function(RadioItemData) onDeleteItem;
  final Function(String, RadioItemData) onAnswerUpdated;

  const RadioGroupForm({
    super.key,
    required this.onAnswerUpdated,
    required this.onChanged,
    required this.onDeleteItem,
    required this.options,
    required this.selectedOption,
  });

  @override
  State<RadioGroupForm> createState() => _RadioGroupFormState();
}

class _RadioGroupFormState extends State<RadioGroupForm> {
  late RadioItemData? selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = widget.selectedOption;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        widget.options.length,
        (index) {
          RadioItemData option = widget.options[index];
          return ListTile(
            onTap: () {
              if (option.title.isNotEmpty) {
                setState(() {
                  widget.onChanged(option);
                  selectedOption = option;
                });
              }
            },
            title: TextFormField(
              initialValue: option.title,
              onChanged: (newAnswer) {
                widget.onAnswerUpdated(newAnswer, option);
                if (newAnswer.isEmpty && selectedOption == option) {
                  setState(() {
                    selectedOption = null;
                  });
                }
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Option ${index + 1}",
                errorText:
                    option.title.isEmpty ? "Option cannot be empty" : null,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                widget.onDeleteItem(option);
              },
            ),
            leading: Radio<RadioItemData>(
              value: option,
              groupValue: selectedOption,
              onChanged: (value) {
                if (option.title.isNotEmpty) {
                  setState(() {
                    widget.onChanged(value!);
                    selectedOption = value;
                  });
                }
              },
            ),
          );
        },
      ),
    );
  }
}
