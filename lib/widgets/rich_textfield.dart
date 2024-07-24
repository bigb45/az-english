import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RichTextfield extends StatefulWidget {
  final QuestionTextFormFieldType type;
  final TextEditingController controller;
  final Function(String, String) onChanged;
  final bool isArabicText;
  final bool isRequired;
  final String? initialAnswer; // Add initial answer for edit mode

  const RichTextfield({
    super.key,
    required this.type,
    required this.controller,
    required this.onChanged,
    required this.isRequired,
    this.isArabicText = false,
    this.initialAnswer, // Initialize the initial answer
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
    _internalTextRepresentation = widget.controller.text;
    _initializeFromControllerText();
    _controller.text = _cleanText(widget.controller.text);
    _controller.addListener(_handleTextChanged);
  }

  void _initializeFromControllerText() {
    String text = widget.controller.text;

    // Find and initialize blanks
    RegExp blankRegExp = RegExp(r'_{3,}');
    Iterable<RegExpMatch> blankMatches = blankRegExp.allMatches(text);
    if (blankMatches.isNotEmpty) {
      RegExpMatch firstBlankMatch = blankMatches.first;
      blankRange =
          TextRange(start: firstBlankMatch.start, end: firstBlankMatch.end);
      answer = widget.initialAnswer ?? ''; // Use the initial answer if provided
    }

    // Find and initialize underlines
    RegExp underlineRegExp = RegExp(r'\{\{a(.+?)\}\}');
    int offset = 0;
    underlineRegExp.allMatches(text).forEach((match) {
      int start = match.start - offset;
      int length = match.group(1)!.length;
      underlines.add(TextRange(start: start, end: start + length));
      offset += 5; // Adjust for the length of '{{a' and '}}'
    });
  }

  void _handleTextChanged() {
    setState(() {
      String currentText = _controller.text;

      // Validate and adjust the blank range if needed
      if (blankRange != null) {
        int blankLength = blankRange!.end - blankRange!.start;
        if (blankRange!.start >= currentText.length ||
            blankRange!.end > currentText.length) {
          blankRange = null;
          answer = '';
        } else {
          String blankText =
              currentText.substring(blankRange!.start, blankRange!.end);
          if (blankText != '_' * blankLength) {
            // Only remove the blank if it's completely overwritten or its length changes
            blankRange = null;
            answer = '';
          }
        }
      }

      // Remove underlines that are out of bounds or overlapping with blank range
      underlines.removeWhere((range) =>
          range.start >= currentText.length || range.end > currentText.length);

      if (blankRange != null) {
        underlines.removeWhere((range) =>
            range.start < blankRange!.end && range.end > blankRange!.start);
      }

      // Recalculate the text representation
      updateInternalRepresentation();
      widget.onChanged(answer, _internalTextRepresentation);
    });
  }

  String _cleanText(String text) {
    // Clean text from special markers
    return text.replaceAllMapped(
        RegExp(r'\{\{a(.+?)\}\}'), (match) => match.group(1)!);
  }

  void updateInternalRepresentation() {
    _internalTextRepresentation = "";
    int lastEnd = 0;
    underlines.sort((a, b) =>
        a.start.compareTo(b.start)); // Ensure ranges are sorted by start index
    for (TextRange range in underlines) {
      // Append text before the current range
      if (range.start > lastEnd) {
        _internalTextRepresentation +=
            _controller.text.substring(lastEnd, range.start);
      }
      // Append the underlined text
      _internalTextRepresentation +=
          '{{a' + _controller.text.substring(range.start, range.end) + '}}';
      lastEnd = range.end;
    }
    // Append any remaining text after the last range
    if (lastEnd < _controller.text.length) {
      _internalTextRepresentation += _controller.text.substring(lastEnd);
    }
  }

  void insertOrRemoveBlank() {
    final selection = _controller.selection;

    if (!selection.isValid ||
        selection.start >= _controller.text.length ||
        selection.end > _controller.text.length ||
        selection.start == selection.end) {
      return; // Do not proceed if the selection is invalid
    }

    setState(() {
      if (blankRange != null &&
          selection.start == blankRange!.start &&
          selection.end == blankRange!.end) {
        // Remove the blank if the selection matches the blank range
        _controller.text = _controller.text
            .replaceRange(blankRange!.start, blankRange!.end, answer);
        blankRange = null;
        answer = '';
      } else {
        // Add or update the blank
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
        _controller.selection =
            TextSelection.collapsed(offset: blankRange!.end);
      }

      // Update the internal representation to reflect this change
      updateInternalRepresentation();
      widget.onChanged(answer, _internalTextRepresentation);
    });
  }

  void insertOrRemoveUnderline() {
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
      List<TextRange> newUnderlines = [];
      bool foundOverlap = false;

      for (var range in underlines) {
        if (selection.start >= range.start && selection.end <= range.end) {
          // Remove the underline if the selection is within an existing underline
          foundOverlap = true;
          if (selection.start > range.start) {
            newUnderlines
                .add(TextRange(start: range.start, end: selection.start));
          }
          if (selection.end < range.end) {
            newUnderlines.add(TextRange(start: selection.end, end: range.end));
          }
        } else if (selection.start < range.end && selection.end > range.start) {
          // Remove the underline if the selection fully or partially overlaps an existing underline
          foundOverlap = true;
          if (selection.start > range.start) {
            newUnderlines
                .add(TextRange(start: range.start, end: selection.start));
          }
          if (selection.end < range.end) {
            newUnderlines.add(TextRange(start: selection.end, end: range.end));
          }
        } else {
          // Keep the underline if there is no overlap
          newUnderlines.add(range);
        }
      }

      if (!foundOverlap) {
        // Add the new underline if no existing underline was affected
        newUnderlines
            .add(TextRange(start: selection.start, end: selection.end));
      }

      underlines = newUnderlines;

      // Update the internal representation to reflect changes
      updateInternalRepresentation();
      widget.onChanged(
          answer, _internalTextRepresentation); // Notify about the change
    });
  }

  @override
  Widget buildTextfield(
      {required VoidCallback onInsert,
      required IconData icon,
      List<Widget>? additionalIcons}) {
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

    String text = _controller.text;
    for (TextRange underlineRange in underlines) {
      if (underlineRange.start > lastEnd) {
        children.add(
          TextSpan(
            text: text.substring(lastEnd, underlineRange.start),
            style: TextStyles.bodyLarge,
          ),
        );
      }
      children.add(
        TextSpan(
          text: text.substring(underlineRange.start, underlineRange.end),
          style: TextStyles.bodyLarge.copyWith(
            decoration: TextDecoration.underline,
            decorationThickness: 3,
          ),
        ),
      );
      lastEnd = underlineRange.end;
    }

    if (lastEnd < text.length) {
      children.add(TextSpan(
        text: text.substring(lastEnd),
        style: TextStyles.bodyLarge,
      ));
    }

    return Text.rich(TextSpan(children: children));
  }

  Widget buildBlankTextfield() {
    return buildTextfield(
      onInsert: insertOrRemoveBlank,
      icon: Icons.space_bar,
    );
  }

  Widget buildUnderlineTextfield() {
    return buildTextfield(
      onInsert: insertOrRemoveUnderline,
      icon: Icons.format_underline,
    );
  }

  Widget buildBothTextfield() {
    return buildTextfield(
      onInsert: () {
        insertOrRemoveBlank();
        insertOrRemoveUnderline();
      },
      icon: Icons.space_bar,
      additionalIcons: [
        IconButton(
          icon: const Icon(Icons.format_underline),
          onPressed: insertOrRemoveUnderline,
        ),
      ],
    );
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
