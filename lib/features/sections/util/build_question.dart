import 'package:ez_english/features/models/base_answer.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/components/checkbox_question.dart';
import 'package:ez_english/features/sections/components/dictation_question.dart';
import 'package:ez_english/features/sections/components/evaluation_section.dart';
import 'package:ez_english/features/sections/components/fill_the_blanks_question.dart';
import 'package:ez_english/features/sections/components/generic_multiple_choice_question.dart';
import 'package:ez_english/features/sections/components/sentence_forming_question.dart';
import 'package:ez_english/features/sections/components/speaking_question.dart';
import 'package:ez_english/features/sections/components/youtube_lesson.dart';
import 'package:ez_english/features/sections/models/checkbox_question_model.dart';
import 'package:ez_english/features/sections/models/dictation_question_model.dart';
import 'package:ez_english/features/sections/models/fill_the_blanks_question_model.dart';
import 'package:ez_english/features/sections/models/multiple_choice_question_model.dart';
import 'package:ez_english/features/sections/models/sentence_forming_question_model.dart';
import 'package:ez_english/features/sections/models/speaking_question_model.dart';
import 'package:ez_english/features/sections/models/string_answer.dart';
import 'package:ez_english/features/sections/models/youtube_lesson_model.dart';
import 'package:flutter/material.dart';

Widget buildQuestion({
  required BaseQuestion question,
  required Function(BaseAnswer) onChanged,
  required EvaluationState answerState,
}) {
  switch (question.questionType) {
    case QuestionType.speaking:
      return SpeakingQuestion(
        question: question as SpeakingQuestionModel,
      );

    case QuestionType.sentenceForming:
      return SentenceFormingQuestion(
        question: question as SentenceFormingQuestionModel,
        onChanged: (value) => onChanged(value as StringAnswer),
        answerState: answerState,
      );

    case QuestionType.multipleChoice:
      return GenericMultipleChoiceQuestion(
        question: question as MultipleChoiceQuestionModel,
        onChanged: (value) {
          onChanged(value);
        },
      );

    case QuestionType.checkbox:
      return CheckboxQuestion(
        question: question as CheckboxQuestionModel,
        onChanged: (value) {
          // print(
          //     "Checkbox Question Value: ${value.answer?.map((e) => e.title)}");
          onChanged(value);
        },
      );

    case QuestionType.dictation:
      return DictationQuestion(
        onAnswerChanged: (value) => onChanged(value as StringAnswer),
        question: question as DictationQuestionModel,
      );

    case QuestionType.findWordsFromPassage:
      return const Text("Find Words From Passage Question");

    case QuestionType.answerQuestionsFromPassage:
      return const Text("Answer Questions From Passage Question");

    case QuestionType.youtubeLesson:
      return RepaintBoundary(
        child: YouTubeVideoPlayer(
          key: ValueKey((question as YoutubeLessonModel).youtubeUrl ??
              "https://www.youtube.com/watch?v=ml5uvpfXcLU"),
          videoId: (question as YoutubeLessonModel).youtubeUrl ??
              // TODO: handle missing youtube url in a better way
              "https://www.youtube.com/watch?v=ml5uvpfXcLU",
        ),
      );

    case QuestionType.fillTheBlanks:
      return FillTheBlanksQuestion(
        key: ValueKey(question.answer),
        question: question as FillTheBlanksQuestionModel,
        onChanged: (value) => onChanged(value),
        answerState: answerState,
        // controller: TextEditingController(),
      );

    default:
      print("Unsupported Question Type: ${question.questionType}, ${question}");
      return const Text("Unsupported Question Type");
  }
}
