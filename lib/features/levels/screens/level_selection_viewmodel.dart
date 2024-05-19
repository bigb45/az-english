import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/features/models/base_viewmodel.dart';
import 'package:ez_english/features/models/level.dart';

class LevelSelectionViewmodel extends BaseViewModel {
  int _selectedLevelId = 0;
  List<Level> _levels = [];

  int get selectedLevel => _selectedLevelId;
  List<Level> get levels => _levels;

  @override
  void init() {
    fetchLevels();
  }

  Future<void> fetchLevels() async {
    isLoading = true;
    notifyListeners();
    try {
      error = null;
      _levels = await firestoreService.fetchLevels();
    } catch (e) {
      error = e as CustomException;
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedLevel(int level) {
    _selectedLevelId = level;
    notifyListeners();
  }
}
