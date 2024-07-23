import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RichTextfield extends StatefulWidget {
  final QuestionTextFormFieldType type;
  final TextEditingController controller;
  final Function(String, String) onChanged;
  final bool isArabicText;
  final bool isRequired;

  const RichTextfield({
    super.key,
    required this.type,
    required this.controller,
    required this.onChanged,
    required this.isRequired,
    this.isArabicText = false,
  });

  @override
  State<RichTextfield> createState() => _RichTextfieldState();
}

class _RichTextfieldState extends State<RichTextfield> {
  final TextEditingController _controller = TextEditingController();
  TextRange? blankRange;
  List<TextRange> underlines = [];
  String answer = '';
  late String _internalTextRepresentation;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.controller.text;
    _internalTextRepresentation = _controller.text;
    _controller.addListener(_handleTextChanged);
  }

  Widget buildBlankTextfield() {
    return buildTextfield(
      onInsert: insertBlank,
      icon: Icons.space_bar,
    );
  }

  Widget buildUnderlineTextfield() {
    return buildTextfield(
      onInsert: insertUnderline,
      icon: Icons.format_underline,
    );
  }

  Widget buildBothTextfield() {
    return buildTextfield(
      onInsert: () {
        insertBlank();
        insertUnderline();
      },
      icon: Icons.space_bar,
      additionalIcons: [
        IconButton(
          icon: const Icon(Icons.format_underline),
          onPressed: insertUnderline,
        ),
      ],
    );
  }

  void _handleTextChanged() {
    setState(() {
      if (blankRange != null) {
        final blankText =
            _controller.text.substring(blankRange!.start, blankRange!.end);
        if (!blankText.contains('_') ||
            blankText.length != blankRange!.end - blankRange!.start ||
            blankText != '_' * (blankRange!.end - blankRange!.start)) {
          String originalText = _controller.text
              .replaceRange(blankRange!.start, blankRange!.end, answer);
          _controller.value = TextEditingValue(
            text: originalText,
            selection: TextSelection.collapsed(
                offset: blankRange!.start + answer.length),
          );
          blankRange = null;
          answer = '';
        }
      }

      underlines.removeWhere((range) =>
          range.start >= _controller.text.length ||
          range.end > _controller.text.length);

      if (blankRange != null) {
        underlines.removeWhere((range) =>
            range.start < blankRange!.end && range.end > blankRange!.start);
      }

      updateInternalRepresentation();
      widget.onChanged(answer, _internalTextRepresentation);
    });
  }

  void updateInternalRepresentation() {
    _internalTextRepresentation = "";
    int lastEnd = 0;
    for (TextRange range in underlines) {
      if (range.start > lastEnd) {
        _internalTextRepresentation +=
            _controller.text.substring(lastEnd, range.start);
      }
      _internalTextRepresentation +=
          '{{a' + _controller.text.substring(range.start, range.end) + '}}';
      lastEnd = range.end;
    }
    _internalTextRepresentation += _controller.text.substring(lastEnd);
  }

  void insertBlank() {
    final selection = _controller.selection;

    if (!selection.isValid ||
        selection.start >= _controller.text.length ||
        selection.end > _controller.text.length ||
        selection.start == selection.end) {
      return;
    }

    setState(() {
      if (blankRange != null) {
        // Replace the previous blank range with the original text
        _controller.text = _controller.text
            .replaceRange(blankRange!.start, blankRange!.end, answer);
      }
      // Set the new blank range
      blankRange = TextRange(start: selection.start, end: selection.end);
      answer = _controller.text.substring(blankRange!.start, blankRange!.end);
      String blankText = '_' * (blankRange!.end - blankRange!.start);
      _controller.text = _controller.text
          .replaceRange(blankRange!.start, blankRange!.end, blankText);
      _controller.selection = TextSelection.collapsed(offset: blankRange!.end);

      // Update the internal representation to reflect this change
      updateInternalRepresentation();
      widget.onChanged(answer, _internalTextRepresentation);
    });
  }

  void insertUnderline() {
    final selection = _controller.selection;

    if (!selection.isValid ||
        selection.start >= _controller.text.length ||
        selection.end > _controller.text.length ||
        selection.start == selection.end) {
      return; // Do not proceed if the selection is invalid
    }

    // Check if the selection overlaps with an existing blank
    if (blankRange != null &&
        selection.start < blankRange!.end &&
        selection.end > blankRange!.start) {
      return; // Do not add an underline if it overlaps with a blank
    }

    setState(() {
      // Proceed to add underline if there is no overlap with blanks
      underlines.add(TextRange(start: selection.start, end: selection.end));
      updateInternalRepresentation(); // Update the internal text to reflect changes
      widget.onChanged(
          answer, _internalTextRepresentation); // Notify about the change
    });
  }

  @override
  Widget buildTextfield({
    required VoidCallback onInsert,
    required IconData icon,
    List<Widget>? additionalIcons,
  }) {
    return Column(
      children: [
        TextFormField(
          onChanged: (value) => _handleTextChanged(),
          controller: _controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: widget.isArabicText
                ? "الجملة الكاملة (عربي)"
                : "Full sentence (English)",
            hintText: widget.isArabicText
                ? "مثال: \"الولد يركل الكرة.\""
                : "Ex: \"The boy kicks the ball.\"",
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(icon),
                  onPressed: onInsert,
                ),
                if (additionalIcons != null) ...additionalIcons,
              ],
            ),
          ),
          validator: widget.isRequired
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.requiredField;
                  }
                  return null;
                }
              : null,
        ),
        SizedBox(height: 10.h),
        Container(
          constraints: BoxConstraints(minHeight: 70.h),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.r),
          ),
          width: double.infinity,
          child: Column(
            children: [
              buildRichText(),
              if (!widget.isArabicText)
                Text("Answer: $answer", style: TextStyles.bodyLarge),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildRichText() {
    List<InlineSpan> children = [];
    int lastEnd = 0;

    for (int i = 0; i < _controller.text.length; i++) {
      if (blankRange != null && blankRange!.start == i) {
        children.add(TextSpan(
          text: _controller.text.substring(lastEnd, blankRange!.start),
        ));
        children.add(TextSpan(
          text: '_' * (blankRange!.end - blankRange!.start),
          style: TextStyle(color: Palette.primaryText),
        ));
        lastEnd = blankRange!.end;
        i = blankRange!.end - 1;
      } else if (underlines.any((range) => range.start == i)) {
        var range = underlines.firstWhere((range) => range.start == i);
        children.add(TextSpan(
          text: _controller.text.substring(lastEnd, range.start),
        ));
        children.add(TextSpan(
          text: _controller.text.substring(range.start, range.end),
          style: TextStyle(
            decoration: TextDecoration.underline,
            decorationThickness: 3,
          ),
        ));
        lastEnd = range.end;
        i = range.end - 1;
      }
    }

    if (lastEnd < _controller.text.length) {
      children.add(TextSpan(
        text: _controller.text.substring(lastEnd),
      ));
    }

    return Text.rich(TextSpan(children: children));
  }

  @override
  Widget build(BuildContext context) {
    return switch (widget.type) {
      QuestionTextFormFieldType.blank => buildBlankTextfield(),
      QuestionTextFormFieldType.underline => buildUnderlineTextfield(),
      QuestionTextFormFieldType.both => buildBothTextfield(),
    };
  }
}

enum QuestionTextFormFieldType { blank, underline, both }
