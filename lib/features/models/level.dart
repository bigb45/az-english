import 'dart:convert';

import 'package:ez_english/features/models/section.dart';

class Level {
  int id;
  String name;
  String description;
  List<Section>? sections;

  Level(
      {required this.name,
      required this.description,
      required this.sections,
      required this.id});

  factory Level.fromMap(Map<String, dynamic> map) {
    return Level(
      id: map["id"],
      name: map['name'],
      description: map['description'],
      sections: (map['sections'] as List?)
          ?.map((section) => Section.fromJson(section))
          .toList(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'sections': sections?.map((s) => s.toJson()).toList(),
    };
  }

  factory Level.fromJson(String data) {
    return Level.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());
}
