import 'package:ez_english/features/sections/vocabulary/components/word_list_tile.dart';

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
