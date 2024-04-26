import 'package:flutter/material.dart';

class RadioGroup extends StatefulWidget {
  final Function(RadioItemData) onChanged;
  final List<RadioItemData> options;
  const RadioGroup({
    super.key,
    required this.onChanged,
    required this.options,
  });

  @override
  State<RadioGroup> createState() => _RadioGroupState();
}

class _RadioGroupState extends State<RadioGroup> {
  late RadioItemData selectedOption;

  @override
  void initState() {
    selectedOption = widget.options[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("rebuiling, selected option: ${selectedOption.title}");
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
                widget.onChanged(value!);
                setState(() {
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
}
