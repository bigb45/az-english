import 'package:ez_english/features/levels/screens/worksheet_view/worksheet_view_viewmodel.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorksheetView extends StatelessWidget {
  const WorksheetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WorksheetViewViewmodel>(
      builder: (context, viewmodel, _) => Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Palette.primaryText),
          title: const Text(
            'Worksheet view',
            style: TextStyle(color: Palette.primaryText),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: viewmodel.isLoading
              ? const CircularProgressIndicator()
              : const Text(
                  "Worksheet View",
                ),
        ),
      ),
    );
  }
}
