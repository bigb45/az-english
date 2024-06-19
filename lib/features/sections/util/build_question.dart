import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/components/dictation_question.dart';
import 'package:ez_english/features/sections/components/evaluation_section.dart';
import 'package:ez_english/features/sections/components/multiple_choice_question.dart';
import 'package:ez_english/features/sections/components/sentence_forming_question.dart';
import 'package:ez_english/features/sections/components/speaking_question.dart';
import 'package:ez_english/features/sections/components/youtube_lesson.dart';
import 'package:ez_english/features/sections/models/dictation_question_model.dart';
import 'package:ez_english/features/sections/models/sentence_forming_question_model.dart';
import 'package:ez_english/features/sections/models/speaking_question_model.dart';
import 'package:ez_english/features/sections/models/youtube_lesson_model.dart';
import 'package:flutter/material.dart';

Widget buildQuestion(
    {required BaseQuestion question,
    required Function(String) onChanged,
    required EvaluationState answerState}) {
  switch (question.questionType) {
    case QuestionType.speaking:
      return SpeakingQuestion(
        question: question as SpeakingQuestionModel,
      );

    case QuestionType.sentenceForming:
      return SentenceFormingQuestion(
        question: question as SentenceFormingQuestionModel,
        onChanged: onChanged,
        answerState: answerState,
      );

    case QuestionType.multipleChoice:
      return const MultipleChoiceQuestion();

    case QuestionType.dictation:
      return DictationQuestion(
        onAnswerChanged: onChanged,
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
