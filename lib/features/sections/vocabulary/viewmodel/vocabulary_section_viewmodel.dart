import 'dart:async';

import 'package:ez_english/features/models/base_viewmodel.dart';
import 'package:ez_english/features/sections/components/word_list_tile.dart';
import 'package:ez_english/features/sections/vocabulary/words_list.dart';

import '../../models/word_model.dart';

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
