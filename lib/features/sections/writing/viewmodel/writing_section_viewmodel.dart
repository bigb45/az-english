import 'dart:async';

import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/models/base_viewmodel.dart';

class WritingSectionViewmodel extends BaseViewModel {
  String? sectionId = "writing";
  String? levelId;

  List<BaseQuestion> question = [];

  @override
  FutureOr<void> init() {}
}
