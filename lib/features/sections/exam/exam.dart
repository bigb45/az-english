import 'package:flutter/material.dart';

class ExamSection extends StatefulWidget {
  const ExamSection({super.key});

  @override
  State<ExamSection> createState() => _ExamSectionState();
}

class _ExamSectionState extends State<ExamSection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Section'),
      ),
      body: const Center(
        child: Text('Exam Section'),
      ),
    );
  }
}
