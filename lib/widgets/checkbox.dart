import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckboxGroup extends StatefulWidget {
  final Function(List<CheckboxData>) onChanged;
  final List<CheckboxData> options;
  final List<CheckboxState>? states;
  const CheckboxGroup(
      {super.key, required this.onChanged, required this.options, this.states});

  @override
  State<CheckboxGroup> createState() => _CheckboxGroupState();
}

class _CheckboxGroupState extends State<CheckboxGroup> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(widget.options.length, (index) {
        CheckboxData option = widget.options[index];
        return ListTile(
            title: Text(
              option.title,
              style: TextStyles.optionTextStyle,
            ),
            leading: CustomCheckbox(
              state: widget.states?[index] ?? CheckboxState.unchecked,
              onChanged: (state) {
                setState(() {
                  option.value = state == CheckboxState.checked;

                  widget.onChanged(
                      widget.options.where((e) => e.value!).toList());
                });
              },
            ));
      }),
    );
  }
}

class CustomCheckbox extends StatefulWidget {
  final CheckboxState state;
  final bool enabled;
  final Function(CheckboxState) onChanged;
  const CustomCheckbox(
      {super.key,
      required this.state,
      this.enabled = true,
      required this.onChanged});

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  CheckboxState? state;
  @override
  void initState() {
    state = widget.state;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.enabled &&
            (state != CheckboxState.incorrect &&
                state != CheckboxState.neutral)) {
          setState(() {
            state = state == CheckboxState.checked
                ? CheckboxState.unchecked
                : CheckboxState.checked;
          });
          widget.onChanged(state!);
        }
      },
      child: Container(
        width: 30.w,
        height: 30.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: switch (state) {
            CheckboxState.checked => Palette.primary,
            CheckboxState.unchecked => Palette.secondaryStroke,
            CheckboxState.incorrect => Palette.error,
            CheckboxState.neutral => Palette.tertiary,
            _ => null,
          },
        ),
        child: switch (state) {
          CheckboxState.checked => const Icon(
              Icons.check,
              color: Palette.secondary,
            ),
          CheckboxState.unchecked => null,
          CheckboxState.incorrect => const Icon(
              Icons.close,
              color: Palette.secondary,
            ),
          CheckboxState.neutral => const Icon(
              Icons.remove,
              color: Palette.secondary,
            ),
          _ => null,
        },
      ),
    );
  }
}

enum CheckboxState { checked, unchecked, incorrect, neutral }

class CheckboxData {
  final String title;
  bool? value;
  bool isSelected;

  CheckboxData(
      {required this.title, this.value = false, this.isSelected = false});
  Map<String, dynamic> toMap() {
    return {
      'value': value,
      'title': title,
    };
  }

  factory CheckboxData.fromMap(Map<String, dynamic> map) {
    return CheckboxData(
      title: map['title'],
      value: map['value'],
    );
  }
}
