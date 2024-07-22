import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RichTextfield extends StatefulWidget {
  const RichTextfield({super.key});

  @override
  State<RichTextfield> createState() => _RichTextfieldState();
}

class _RichTextfieldState extends State<RichTextfield> {
  int blankStart = 0;
  int blankEnd = 0;
  int underlineStart = 0;
  int underlineEnd = 0;
  String answer = '';
  final TextEditingController _controller = TextEditingController();
  void insertBlank() {
    if (_controller.selection ==
        TextSelection(baseOffset: -1, extentOffset: -1)) {
      return;
    }
    final selection = _controller.selection;

    blankStart = selection.start;
    blankEnd = selection.end;
    // answer = _controller.text.substring(blankStart, blankEnd);

    setState(() {});
  }

  void insertUnderline() {
    if (_controller.selection ==
        TextSelection(baseOffset: -1, extentOffset: -1)) {
      return;
    }
    final selection = _controller.selection;

    underlineStart = selection.start;
    underlineEnd = selection.end;
    answer = _controller.text.substring(blankStart, blankEnd);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          onChanged: (value) {
            if (value.length < blankStart || value.length < blankEnd) {
              blankStart = value.length;
              blankEnd = value.length;
            }
          },
          controller: _controller,
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: "Full sentence (English)",
              hintText: "Ex: \"The boy kicks the ball.\"",
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.format_underline),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.minimize),
                    onPressed: () {
                      insertBlank();
                    },
                  ),
                ],
              )),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the incomplete sentence in English';
            }
            return null;
          },
        ),
        SizedBox(
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
                    if (blankStart != blankEnd)
                      TextSpan(
                        text: '_____',
                        style: const TextStyle(color: Palette.primaryText),
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
