import 'package:ez_english/features/models/level.dart';
import 'package:flutter/material.dart';

class LevelSelectionViewmodel extends ChangeNotifier {
  int _selectedLevelId = 0;
  List<Level> _assignedLevels = [];

  int get selectedLevel => _selectedLevelId;
  List<Level> get assignedLevels => _assignedLevels;

  LevelSelectionViewmodel() {
    init();
  }

  void init() {
    // TODO: get levels from api call
    _assignedLevels = [
      Level(name: 'A1', description: 'Basics of English', sections: []),
      Level(name: 'A2', description: 'This is the second level', sections: []),
      Level(name: 'B1', description: 'This is the third level', sections: []),
    ];
    notifyListeners();
  }

  void setSelectedLevel(int level) {
    _selectedLevelId = level;
    notifyListeners();
  }

  // TODO: get level details from api call
}
