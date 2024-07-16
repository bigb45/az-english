import 'package:ez_english/theme/text_styles.dart';
import 'package:flutter/material.dart';

class RadioGroup extends StatefulWidget {
  final Function(RadioItemData) onChanged;
  final List<RadioItemData> options;
  final RadioItemData? selectedOption;
  const RadioGroup({
    super.key,
    required this.onChanged,
    required this.options,
    required this.selectedOption,
  });

  @override
  State<RadioGroup> createState() => _RadioGroupState();
}

class _RadioGroupState extends State<RadioGroup> {
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
            title: Text(option.title, style: TextStyles.optionTextStyle),
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RadioItemData &&
        other.title == title &&
        other.value == value;
  }

  @override
  int get hashCode => title.hashCode ^ value.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'value': value,
    };
  }

  factory RadioItemData.fromMap(Map<String, dynamic> map) {
    return RadioItemData(
      title: map['title'],
      value: map['value'],
    );
  }
}
