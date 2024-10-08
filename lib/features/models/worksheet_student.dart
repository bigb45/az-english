import 'dart:convert';

class WorksheetStudent {
  String? studentName;
  String? imagePath;
  DateTime? dateSolved;
  String? worksheetId;
  String? unitNumber;

  WorksheetStudent({
    this.studentName,
    this.imagePath,
    this.dateSolved,
    this.worksheetId,
    this.unitNumber,
  });

  factory WorksheetStudent.fromMap(Map<String, dynamic> map) {
    return WorksheetStudent(
      studentName: map['studentName'],
      imagePath: map['imagePath'],
      dateSolved: DateTime.parse(map['dateSolved']),
      worksheetId: map['worksheetId'],
      unitNumber: map['unitNumber'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentName': studentName,
      'imagePath': imagePath,
      'dateSolved': dateSolved?.toIso8601String(),
      'worksheetId': worksheetId,
      'unitNumber': unitNumber,
    };
  }

  factory WorksheetStudent.fromJson(String data) {
    return WorksheetStudent.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());
}
