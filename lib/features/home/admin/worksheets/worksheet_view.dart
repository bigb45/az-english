import 'package:ez_english/theme/palette.dart';
import 'package:flutter/material.dart';

class WorksheetView extends StatelessWidget {
  final String worksheetId;
  const WorksheetView({super.key, required this.worksheetId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Palette.primaryText),
        title: const Text(
          'Administrator',
          style: TextStyle(color: Palette.primaryText),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Container(
            child: InteractiveViewer(
          child: Image.asset(
            "logo2.png",
          ),
        )),
      ),
    );
  }
}
