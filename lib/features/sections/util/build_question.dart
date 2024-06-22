import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/components/dictation_question.dart';
import 'package:ez_english/features/sections/components/evaluation_section.dart';
import 'package:ez_english/features/sections/components/generic_multiple_choice_question.dart';
import 'package:ez_english/features/sections/components/sentence_forming_question.dart';
import 'package:ez_english/features/sections/components/speaking_question.dart';
import 'package:ez_english/features/sections/components/youtube_lesson.dart';
import 'package:ez_english/features/sections/models/dictation_question_model.dart';
import 'package:ez_english/features/sections/models/multiple_choice_question_model.dart';
import 'package:ez_english/features/sections/models/sentence_forming_question_model.dart';
import 'package:ez_english/features/sections/models/speaking_question_model.dart';
import 'package:ez_english/features/sections/models/youtube_lesson_model.dart';
import 'package:flutter/material.dart';

Widget buildQuestion<T>(
    {required BaseQuestion question,
    required Function(T) onChanged,
    required EvaluationState answerState}) {
  switch (question.questionType) {
    case QuestionType.speaking:
      return SpeakingQuestion(
        question: question as SpeakingQuestionModel,
      );

    case QuestionType.sentenceForming:
      return SentenceFormingQuestion(
        question: question as SentenceFormingQuestionModel,
        onChanged: (value) => onChanged(value as T),
        answerState: answerState,
      );

    case QuestionType.multipleChoice:
      return GenericMultipleChoiceQuestion(
        question: question as MultipleChoiceQuestionModel,
        onChanged: (value) => onChanged(value as T),
      );

    // return const Text("Multiple Choice Question");

    case QuestionType.dictation:
      return DictationQuestion(
        onAnswerChanged: (value) => onChanged(value as T),
        question: question as DictationQuestionModel,
      );

    case QuestionType.findWordsFromPassage:
      return const Text("Find Words From Passage Question");

    case QuestionType.answerQuestionsFromPassage:
      return const Text("Answer Questions From Passage Question");

    case QuestionType.youtubeLesson:
      return YouTubeVideoPlayer(
        videoId: (question as YoutubeLessonModel).youtubeUrl!,
      );

    default:
      return const Text("Unsupported Question Type");
  }
}
