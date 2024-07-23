import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RichTextfield extends StatefulWidget {
  final QuestionTextFormFieldType type;
  final TextEditingController controller;
  final Function(String, String) onChanged;
  const RichTextfield(
      {super.key,
      required this.type,
      required this.controller,
      required this.onChanged});

  @override
  State<RichTextfield> createState() => _RichTextfieldState();
}

class _RichTextfieldState extends State<RichTextfield> {
  final TextEditingController _controller = TextEditingController();
  int blankStart = 0;
  int blankEnd = 0;
  int underlineStart = 0;
  int underlineEnd = 0;
  String answer = '';
  @override
  Widget build(BuildContext context) {
    return switch (widget.type) {
      QuestionTextFormFieldType.blank => buildBlankTextfield(),
      QuestionTextFormFieldType.underline => buildUnderlineTextfield()
    };
  }

  Widget buildUnderlineTextfield() {
    void insertUnderline() {
      final selection = _controller.selection;

      if (selection == const TextSelection(baseOffset: -1, extentOffset: -1)) {
        return;
      }
      underlineStart = selection.start;
      underlineEnd = selection.end;

      setState(() {});
    }

    return Column(
      children: [
        TextFormField(
          onChanged: (value) {
            if (value.length < underlineStart || value.length < underlineEnd) {
              underlineStart = underlineEnd = value.length;
            }
            widget.onChanged("", _controller.text);
          },
          controller: _controller,
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: "Full sentence (English)",
              hintText: "Ex: \"The boy kicks the ball.\"",
              suffixIcon: IconButton(
                icon: const Icon(Icons.format_underline),
                onPressed: () {
                  insertUnderline();
                },
              )),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the incomplete sentence in English';
            }
            return null;
          },
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5),
          ),
          width: double.infinity,
          height: 70.h,
          child: Column(
            children: [
              Text.rich(
                style: TextStyles.bodyLarge,
                TextSpan(children: [
                  TextSpan(
                    text: _controller.text.substring(0, underlineStart),
                    style: TextStyles.bodyLarge,
                  ),
                  TextSpan(
                    text: _controller.text
                        .substring(underlineStart, underlineEnd),
                    style: TextStyles.bodyLarge.copyWith(
                      decoration: TextDecoration.underline,
                      decorationThickness: 3,
                    ),
                  ),
                  TextSpan(
                    text: _controller.text.substring(underlineEnd),
                    style: TextStyles.bodyLarge,
                  ),
                ]),
              ),
              Text(
                  "Answer: ${_controller.text.substring(underlineStart, underlineEnd)}",
                  style: TextStyles.bodyLarge)
            ],
          ),
        )
      ],
    );
  }

  Widget buildBlankTextfield() {
    void insertBlank() {
      final selection = _controller.selection;

      if (selection == const TextSelection(baseOffset: -1, extentOffset: -1)) {
        return;
      }

      blankStart = selection.start;
      blankEnd = selection.end;
      answer = _controller.text.substring(blankStart, blankEnd);
      setState(() {});
    }

    return Column(
      children: [
        TextFormField(
          onChanged: (value) {
            if (value.length < blankStart || value.length < blankEnd) {
              blankStart = value.length;
              blankEnd = value.length;
            }
            widget.onChanged(answer, _controller.text);
          },
          controller: _controller,
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: "Full sentence (English)",
              hintText: "Ex: \"The boy kicks the ball.\"",
              suffixIcon: IconButton(
                icon: const Icon(Icons.space_bar),
                onPressed: () {
                  insertBlank();
                },
              )),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppStrings.requiredField;
            }
            return null;
          },
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5),
          ),
          width: double.infinity,
          height: 70.h,
          child: Column(
            children: [
              Text.rich(
                style: TextStyles.bodyLarge,
                TextSpan(
                  children: [
                    TextSpan(
                      text: _controller.text.substring(0, blankStart),
                      style: const TextStyle(color: Colors.black),
                    ),
                    if (blankEnd != blankStart)
                      const TextSpan(
                        text: '_____',
                        style: TextStyle(color: Palette.primaryText),
                      ),
                    TextSpan(
                      text: _controller.text.substring(blankEnd),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              Text(
                  "Answer: ${_controller.text.substring(blankStart, blankEnd)}",
                  style: TextStyles.bodyLarge)
            ],
          ),
        )
      ],
    );
  }
}

enum QuestionTextFormFieldType { blank, underline }
