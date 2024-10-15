import 'package:ez_english/features/home/whiteboard/whiteboard_model.dart';
import 'package:ez_english/features/models/base_answer.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/components/checkbox_question.dart';
import 'package:ez_english/features/sections/components/dictation_question.dart';
import 'package:ez_english/features/sections/components/evaluation_section.dart';
import 'package:ez_english/features/sections/components/fill_the_blanks_question.dart';
import 'package:ez_english/features/sections/components/generic_multiple_choice_question.dart';
import 'package:ez_english/features/sections/components/sentence_forming_question.dart';
import 'package:ez_english/features/sections/components/speaking_question.dart';
import 'package:ez_english/features/sections/components/whiteboard_view.dart';
import 'package:ez_english/features/sections/components/word_view_question.dart';
import 'package:ez_english/features/sections/components/youtube_lesson.dart';
import 'package:ez_english/features/sections/models/checkbox_question_model.dart';
import 'package:ez_english/features/sections/models/dictation_question_model.dart';
import 'package:ez_english/features/sections/models/fill_the_blanks_question_model.dart';
import 'package:ez_english/features/sections/models/multiple_choice_question_model.dart';
import 'package:ez_english/features/sections/models/sentence_forming_question_model.dart';
import 'package:ez_english/features/sections/models/speaking_question_model.dart';
import 'package:ez_english/features/sections/models/string_answer.dart';
import 'package:ez_english/features/sections/models/word_definition.dart';
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
        onChanged: (value) => onChanged(value),
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
          onChanged(value);
        },
      );

    case QuestionType.dictation:
      return DictationQuestion(
        onAnswerChanged: (value) => onChanged(StringAnswer(answer: value)),
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
              "https://www.youtube.com/watch?v=aDm5WZ3QiIE"),
          videoId: (question).youtubeUrl ??
              "https://www.youtube.com/watch?v=aDm5WZ3QiIE",
        ),
      );

    case QuestionType.vocabularyWithListening:
    case QuestionType.vocabulary:
      return WordViewQuestion(wordData: question as WordDefinition);

    case QuestionType.fillTheBlanks:
      return FillTheBlanksQuestion(
        key: ValueKey(question.answer),
        question: question as FillTheBlanksQuestionModel,
        onChanged: (value) => onChanged(value),
        answerState: answerState,
        // controller: TextEditingController(),
      );

    case QuestionType.whiteboard:
      return WhiteboardView(whiteboardModel: question as WhiteboardModel);

    case QuestionType.speaking:
      return SpeakingQuestion(question: question as SpeakingQuestionModel);

    default:
      print(
          "Unsupported Question Type: ${question.questionType}, ${question.imageUrl}");
      return const Text("Unsupported Question Type");
  }
}
