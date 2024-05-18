import 'package:ez_english/features/models/section.dart';

class Level {
  String name;
  String description;
  List<Section> sections;
  bool isAssigned;

  Level(
      {required this.name,
      required this.description,
      required this.sections,
      this.isAssigned = false});

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      name: json['name'],
      description: json['description'],
      sections: (json['sections'] as List)
          .map((item) => Section.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'sections': sections.map((s) => s.toJson()).toList(),
    };
  }
}
