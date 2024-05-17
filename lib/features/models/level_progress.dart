import 'package:ez_english/features/models/section_progress.dart';

class LevelProgress {
  String name;
  String description;
  List<String> completedSections;
  List<SectionProgress> sectionProgress;

  LevelProgress(
      {required this.name,
      required this.description,
      required this.completedSections,
      required this.sectionProgress});

  factory LevelProgress.fromJson(Map<String, dynamic> json) {
    return LevelProgress(
      name: json['name'],
      description: json['description'],
      completedSections: List<String>.from(json['completedSections']),
      sectionProgress: (json['sectionProgress'] as List)
          .map((item) => SectionProgress.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'completedSections': completedSections,
      'sectionProgress': sectionProgress.map((sp) => sp.toJson()).toList(),
    };
  }
}
