import 'package:ez_english/features/models/unit.dart';

class Section {
  String name;
  String? description;
  List<Unit>? units;
  bool attempted;
  bool isAssigned;
  int numberOfQuestions;
  Section(
      {required this.name,
      required this.description,
      required this.units,
      this.isAssigned = false,
      this.numberOfQuestions = 0,
      this.attempted = false});

  factory Section.fromMap(Map<String, dynamic> json) {
    return Section(
        name: json['name'],
        description: json['description'],
        units: (json['units'] as List?)
            ?.map((item) => Unit.fromMap(item))
            .toList(),
        attempted: json['attempted']);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'attempted': attempted,
      'units': units?.map((u) => u.toJson()).toList(),
    };
  }
}
