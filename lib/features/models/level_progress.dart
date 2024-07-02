import 'dart:convert';
import 'package:ez_english/features/models/section_progress.dart';

class LevelProgress {
  String name;
  String description;
  List<String> completedSections;
  Map<String, SectionProgress>? sectionProgress; // Change to map
  int currentDay; // Add currentDay field

  LevelProgress({
    required this.name,
    required this.description,
    required this.completedSections,
    this.sectionProgress, // Make sectionProgress nullable
    this.currentDay = 1, // Default to day 1
  });

  factory LevelProgress.fromMap(Map<String, dynamic> map) {
    return LevelProgress(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      completedSections: List<String>.from(map['completedSections'] ?? []),
      sectionProgress: (map['sectionProgress'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry<String, SectionProgress>(
          key,
          SectionProgress.fromMap(value),
        ),
      ),
      currentDay: map['currentDay'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'completedSections': completedSections,
      'sectionProgress':
          sectionProgress?.map((key, value) => MapEntry(key, value.toMap())),
      'currentDay': currentDay,
    };
  }

  factory LevelProgress.fromJson(String data) {
    return LevelProgress.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());
}
