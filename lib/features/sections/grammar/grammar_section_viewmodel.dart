import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/models/base_viewmodel.dart';
import 'package:ez_english/features/models/base_question.dart';

class GrammarSectionViewmodel extends BaseViewModel {
  final FirestoreService _firestoreService = FirestoreService();

  List<BaseQuestion> _questions = [];
  bool _isLoading = false;

  List<BaseQuestion> get questions => _questions;
  bool get isLoding => _isLoading;

  GrammarSectionViewmodel() {
    init();
  }

  @override
  void init() {
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    _isLoading = true;
    try {
      // TODO: replace with actual data
      _questions = await _firestoreService.fetchQuestions("grammar", "1", "1");

      notifyListeners();
    } catch (e) {
      print(e);
      // TODO: show error in ui
    }
  }
}
