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
              setState(() {
                widget.onChanged(option);
                selectedOption = option;
              });
            },
            title: TextFormField(
              onChanged: (newAnswer) {
                widget.onAnswerUpdated(newAnswer, option);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: option.title,
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
                setState(() {
                  widget.onChanged(value!);
                  selectedOption = value;
                });
              },
            ),
          );
        },
      ),
    );
  }
}

class RadioItemData {
  final String title;
  final String value;
  RadioItemData({required this.title, required this.value});
  Map<String, dynamic> toMap() {
    return {
      'value': value,
      'title': title,
    };
  }

  factory RadioItemData.fromMap(Map<String, dynamic> map) {
    return RadioItemData(
      title: map['title'],
      value: map['value'],
    );
  }
}
