import 'package:ez_english/features/sections/models/word_definition.dart';

class WordModel {
  final String word;
  final WordType type;
  final bool isNew;
  const WordModel({
    required this.word,
    required this.type,
    required this.isNew,
  });
}
