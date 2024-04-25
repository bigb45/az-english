import 'package:flutter/material.dart';

class RadioGroup extends StatefulWidget {
  final Function(RadioItemData) onChanged;
  final List<RadioItemData> options;
  final RadioItemData defaultOption;
  const RadioGroup(
      {super.key,
      required this.onChanged,
      required this.options,
      required this.defaultOption});

  @override
  State<RadioGroup> createState() => _RadioGroupState();
}

class _RadioGroupState extends State<RadioGroup> {
  RadioItemData? selectedOption;
  @override
  void initState() {
    selectedOption = widget.options.isNotEmpty ? widget.options.first : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        widget.options.length,
        (index) {
          RadioItemData option = widget.options[index];
          return ListTile(
            title: Text(option.title),
            leading: Radio<RadioItemData>(
              value: option,
              groupValue: selectedOption,
              onChanged: (value) {
                if (value != null) {
                  widget.onChanged(value);
                  setState(() {
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

class RadioItemData {
  final String title;
  final String value;
  RadioItemData({required this.title, required this.value});
}
