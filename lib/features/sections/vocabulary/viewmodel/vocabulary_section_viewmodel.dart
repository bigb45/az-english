import 'dart:async';

import 'package:ez_english/features/models/base_viewmodel.dart';
import 'package:ez_english/features/sections/vocabulary/components/word_list_tile.dart';
import 'package:ez_english/features/sections/vocabulary/words_list.dart';

class VocabularySectionViewmodel extends BaseViewModel {
  late List<WordModel> _words;

  get words => _words;

  @override
  FutureOr<void> init() {
    _words = [
      WordModel(word: "View", type: WordType.verb, isNew: false),
      WordModel(word: "View", type: WordType.verb, isNew: false),
      WordModel(word: "View", type: WordType.verb, isNew: false),
      WordModel(word: "View", type: WordType.verb, isNew: false),
      WordModel(word: "View", type: WordType.verb, isNew: false),
      WordModel(word: "View", type: WordType.verb, isNew: false),
    ];
  }
}
